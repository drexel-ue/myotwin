"""
MyoTwin Anatomical Asset Pipeline — Z-Anatomy Exporter

A single, unified script to process the raw Z-Anatomy Blender file into 
mobile-optimized .glb assets and the anatomy_encoding_schema.json required 
by the Flutter procedural animation engine.

Key Features:
- Idempotent & Memoized: Hashes source collections to skip decimation and processing for unchanged layers.
- Curve-to-Mesh Conversion: Automatically converts Blender curves into meshes.
- Anatomy-Aware Decimation: Uses specific decimation ratios (e.g., higher retention for vessels/nerves).
- Procedural Vertex Encoding: Bakes flow direction, pressure, and hierarchy into the "MyoData" vertex layer.
- Schema Generation: Automatically builds anatomy_encoding_schema.json.

Usage:
  1. Open the Z-Anatomy .blend file.
  2. Open this script in the Scripting workspace.
  3. Run the script.
"""

import bpy
import os
import json
import math
import time
import hashlib
import sys

# ==============================================================================
# CONFIGURATION
# ==============================================================================

def print_progress(iteration, total, prefix='', suffix='', decimals=1, length=30, fill='█', printEnd="\r"):
    """
    Call in a loop to create terminal progress bar
    """
    if total == 0:
        return
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    print(f'\r{prefix} |{bar}| {percent}% {suffix}', end=printEnd)
    if iteration == total: 
        print()


# Output directory for the GLB assets and JSON schema
OUTPUT_DIR = "/Users/ikkeshpack/Development/LamontLabs/myotwin_workspace/myotwin/packages/myotwin_app/assets/models/"
SCHEMA_PATH = os.path.join(OUTPUT_DIR, "anatomy_encoding_schema.json")

# Map Z-Anatomy collection names to output GLB filenames
LAYER_MAP = {
    "1: Skeletal system":        "myotwin_skeletal",
    "2: Muscular insertions":    "myotwin_insertions",
    "3: Joints":                 "myotwin_joints",
    "4: Muscular system":        "myotwin_muscular",
    "5: Cardiovascular system":  "myotwin_cardiovascular",
    "7: Nervous system & Sense organs": "myotwin_nervous",
}

# Decimation ratios (lower = more geometry removed)
DECIMATE_RATIO = {
    "skeletal":           0.20,
    "insertions":         0.20,
    "joints":             0.25,
    "muscular":           0.20,
    "cardiovascular":     0.50,
    "nervous":            0.45,
}

HEART_CENTER = (0.0, 1.15, -0.05)
MAX_BODY_RADIUS = 2.0

TEXT_BLACKLIST = {
    "joints.g", "muscular system.g", "fasciae.g",
    "arterial system.g", "venous system.g",
    "nervous system & sense organs.g", "skeletal system.g",
    "vaisseaux.g", "blood vessels.g", "systemic arteries.g", "systemic veins.g",
}

PROCEDURAL_TAGS = {
    "myotwin_cardiovascular": [
        ("ventricle",  "heart_ventricle"),
        ("atrium",     "heart_atrium"),
        ("aorta",      "heart_aorta"),
        ("pulmonary",  "heart_pulmonary"),
        ("caval",      "heart_caval"),
        ("septum",     "heart_septum"),
        ("heart",      "heart_myo"),
        ("artery",     "artery"),
        ("carotid",    "artery"),
        ("vein",       "vein"),
        ("vena",       "vein"),
        ("cav",        "vein"),       
        ("venule",     "vein"),
        ("valve",      "heart_valve"),
    ],
    "myotwin_nervous": [
        ("brain",      "brain_core"),
        ("spinal",     "spinal_cord"),
        ("brainstem",  "brainstem"),
        ("thalamus",   "brain_core"),
        ("cerebellum", "cerebellum"),
        ("nerve",      "nerve_trunk"),
        ("vagus",      "nerve_vagus"),
        ("sciatic",    "nerve_trunk"),
        ("phrenic",    "nerve_trunk"),
        ("cranial",    "nerve_cranial"),
        ("ganglion",   "nerve_ganglion"),
        ("pudendal",   "nerve_trunk"),
        ("radial",     "nerve_trunk"),
        ("ulnar",      "nerve_trunk"),
        ("median",     "nerve_trunk"),
        ("femoral",    "nerve_trunk"),
        ("tibial",     "nerve_trunk"),
        ("peroneal",   "nerve_trunk"),
        ("brachial",   "nerve_brachial"),
        ("plexus",     "nerve_ganglion"),
    ],
    "myotwin_muscular": [
        ("diaphragm",  "muscle_diaphragm"),
        ("pector",     "muscle_pector"),
        ("biceps",     "muscle_arm"),
        ("triceps",    "muscle_arm"),
        ("quadriceps", "muscle_leg"),
        ("quadr",      "muscle_leg"),
        ("deltoid",    "muscle_shoulder"),
        ("trapezius",  "muscle_upper"),
        ("latiss",     "muscle_back"),
        ("rectus",     "muscore_core"),
        ("abdomin",    "muscle_core"),
        ("glute",      "muscle_leg"),
        ("calves",     "muscle_leg"),
        ("gastrocn",   "muscle_leg"),
        ("soleus",     "muscle_leg"),
        ("sartorius",  "muscle_leg"),
        ("flexor",     "muscle_appendicular"),
        ("extensor",   "muscle_appendicular"),
    ],
    "myotwin_skeletal": [
        ("skull",      "bone_skull"),
        ("vertebra",   "bone_spine"),
        ("cervical",   "bone_spine"),
        ("thoracic",   "bone_spine"),
        ("lumbar",     "bone_spine"),
        ("humerus",    "bone_arm"),
        ("radius",     "bone_arm"),
        ("ulna",       "bone_arm"),
        ("femur",      "bone_leg"),
        ("tibia",      "bone_leg"),
        ("fibula",     "bone_leg"),
        ("sternum",    "bone_chest"),
        ("rib",        "bone_chest"),
        ("clavicl",    "bone_shoulder"),
        ("scapula",    "bone_shoulder"),
        ("pelvis",     "bone_pelvis"),
        ("patella",    "bone_joint"),
        ("sacrum",     "bone_spine"),
    ],
    "myotwin_joints": [
        ("shoulder",   "joint_shoulder"),
        ("hip",        "joint_hip"),
        ("knee",       "joint_knee"),
        ("elbow",      "joint_elbow"),
        ("wrist",      "joint_wrist"),
        ("ankle",      "joint_ankle"),
        ("spine",      "joint_spine"),
        ("sternoclavic", "joint_clavicle"),
        ("acetab",     "joint_hip"),
    ],
    "myotwin_insertions": [
        ("tendon",     "insertion_tendon"),
        ("aponeurosis", "insertion_aponeurosis"),
    ],
}

# ==============================================================================
# PIPELINE FUNCTIONS
# ==============================================================================

def ensure_object_mode():
    if bpy.ops.object.mode_set.poll():
        bpy.ops.object.mode_set(mode="OBJECT")

def get_collection_hash(col: bpy.types.Collection) -> str:
    """Generates a hash for a collection based on its objects and vertex counts."""
    data = []
    for obj in sorted(col.all_objects, key=lambda o: o.name):
        if obj.type == 'MESH':
            data.append(f"{obj.name}:M{len(obj.data.vertices)}")
        elif obj.type == 'CURVE':
            pts = sum(len(s.bezier_points) for s in obj.data.splines if s.type == 'BEZIER')
            data.append(f"{obj.name}:C{pts}")
    return hashlib.md5("".join(data).encode()).hexdigest()

def encode_vertex_colors(obj: bpy.types.Object, proc_type: str, id_in_layer: int):
    """Encodes procedural animation data into mesh vertex colors."""
    mesh = obj.data
    world_mat = obj.matrix_world

    if not mesh.vertex_colors:
        mesh.vertex_colors.new(name="MyoData")
    vc = mesh.vertex_colors["MyoData"]

    bb_min = [1e9] * 3
    bb_max = [-1e9] * 3
    for v in mesh.vertices:
        co_world = world_mat @ v.co
        for i in range(3):
            bb_min[i] = min(bb_min[i], co_world[i])
            bb_max[i] = max(bb_max[i], co_world[i])
    mesh_size = max(bb_max[i] - bb_min[i] for i in range(3)) or 1.0

    v_world_cache = {}
    for poly in mesh.polygons:
        for li in poly.loop_indices:
            vi = mesh.loops[li].vertex_index
            v_world_cache[vi] = world_mat @ mesh.vertices[vi].co

    for poly in mesh.polygons:
        for li in poly.loop_indices:
            vi = mesh.loops[li].vertex_index
            v_world = v_world_cache[vi]

            dx = v_world.x - HEART_CENTER[0]
            dy = v_world.y - HEART_CENTER[1]
            dz = v_world.z - HEART_CENTER[2]
            dist_from_heart = math.sqrt(dx * dx + dy * dy + dz * dz)
            dist_norm = min(dist_from_heart / MAX_BODY_RADIUS, 1.0)

            if proc_type.startswith(("artery", "vein")):
                flow_forward = proc_type == "artery"
                flow_pos = dist_norm if flow_forward else 1.0 - dist_norm
                vessel_rad = min(mesh_size / 0.6, 1.0)
                color = (flow_pos, 1.0 if flow_forward else 0.0, vessel_rad, 1.0)

            elif proc_type.startswith("heart_"):
                pressure = 1.0 - dist_norm * 0.5
                layer_depth = 0.2 if "ventricle" in proc_type else 0.5
                chamber_id = id_in_layer % 8 / 255.0
                color = (pressure, layer_depth, chamber_id, 1.0)

            elif proc_type.startswith(("nerve_", "brain", "spinal")):
                signal_origin = 1.0 - dist_norm
                signal_type = 0.0
                branch_depth = min(id_in_layer / 200.0, 1.0)
                color = (signal_origin, signal_type, branch_depth, 1.0)

            elif proc_type.startswith("muscle_"):
                activation_pos = dist_norm
                muscle_type = 0.1 * hash(proc_type) % 9
                color = (activation_pos, muscle_type, 1.0, 1.0)

            else:
                region_id = hash(f"{obj.name}") % 256 / 255.0
                color = (1.0, region_id, 1.0, 1.0)

            vc.data[li].color = color

def match_proc_type(name: str) -> str:
    lower = name.lower()
    for category in PROCEDURAL_TAGS.values():
        for tag in category:
            if tag[0].lower() in lower:
                return tag[1]
    return "generic"

def decimate_mesh(obj: bpy.types.Object, ratio: float):
    mod = obj.modifiers.new(name="Decimate_v2", type="DECIMATE")
    mod.ratio = ratio
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=mod.name)

def export_glb(filepath, use_selection=True):
    """Resilient GLTF exporter that handles naming changes across Blender versions."""
    kwargs = {
        "filepath": filepath,
        "use_selection": use_selection,
        "export_format": "GLB",
        "export_materials": "NONE",
        "export_texcoords": True,
        "export_normals": True,
        "export_draco_mesh_compression_enable": False,
        "export_extras": True,
        "export_animations": False,
    }
    
    if bpy.app.version >= (2, 93, 0):
        kwargs["export_colors"] = True
    else:
        kwargs["export_vcolors"] = True
        
    try:
        bpy.ops.export_scene.gltf(**kwargs)
    except TypeError:
        if "export_colors" in kwargs: del kwargs["export_colors"]
        if "export_vcolors" in kwargs: del kwargs["export_vcolors"]
        bpy.ops.export_scene.gltf(**kwargs)

# ==============================================================================
# MAIN EXPORT ROUTINE
# ==============================================================================

def process():
    start_time = time.time()
    ensure_object_mode()

    if not os.path.isdir(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    schema = {
        "version": "2.1",
        "heart_center": list(HEART_CENTER),
        "layers": {},
    }

    total_layers = len(LAYER_MAP)
    for layer_idx, (layer_col_name, glb_base) in enumerate(LAYER_MAP.items(), 1):
        layer_key = glb_base.replace("myotwin_", "")
        print(f"\n▸ Processing Layer {layer_idx}/{total_layers}: {layer_key:25s} ({layer_col_name})")
        print_progress(layer_idx - 1, total_layers, prefix='  OVERALL PROGRESS:', suffix='Complete', length=40)

        master_col = bpy.data.collections.get(layer_col_name)
        if not master_col:
            print(f"\n  ✗ Collection '{layer_col_name}' NOT FOUND — skipping")
            continue

        source_hash = get_collection_hash(master_col)
        export_col_name = f"Export_{layer_key}"
        export_col = bpy.data.collections.get(export_col_name)
        export_path = os.path.join(OUTPUT_DIR, f"{glb_base}.glb")
        
        needs_processing = True

        if export_col:
            cached_hash = export_col.get("source_hash", "")
            if cached_hash == source_hash and os.path.exists(export_path):
                print(f"\n  ✓ Cached and unchanged. Skipping heavy processing.")
                needs_processing = False
            else:
                print(f"\n  ↻ Source changed or GLB missing. Re-processing.")
                for obj in list(export_col.objects):
                    bpy.data.objects.remove(obj, do_unlink=True)
                bpy.data.collections.remove(export_col)
                export_col = None

        if needs_processing:
            export_col = bpy.data.collections.new(export_col_name)
            export_col["source_hash"] = source_hash
            bpy.context.scene.collection.children.link(export_col)

            valid_objects = []
            for obj in master_col.all_objects:
                if obj.type not in {"MESH", "CURVE"}:
                    continue
                name_lower = obj.name.lower()
                if any(name_lower.startswith(p) for p in TEXT_BLACKLIST):
                    continue
                valid_objects.append(obj)

            valid_objects.sort(key=lambda o: len(o.data.vertices) if o.type == 'MESH' else 0, reverse=True)

            print(f"    - Duplicating, converting, and coloring {len(valid_objects)} objects...")
            
            bpy.context.window_manager.progress_begin(0, len(valid_objects))
            total_objs = len(valid_objects)
            print_progress(0, total_objs, prefix='      Step 1/2 [Convert]:', suffix='', length=30)
            for i, obj in enumerate(valid_objects):
                print_progress(i + 1, total_objs, prefix='      Step 1/2 [Convert]:', suffix='', length=30)
                bpy.context.window_manager.progress_update(i)

                dup = obj.copy()
                dup.data = obj.data.copy()
                dup.matrix_world = obj.matrix_world.copy()
                export_col.objects.link(dup)
                
                # IMPORTANT: Ensure visibility BEFORE running operators
                dup.hide_viewport = False
                dup.hide_render = False

                if dup.type == "CURVE":
                    bpy.ops.object.select_all(action="DESELECT")
                    dup.select_set(True)
                    bpy.context.view_layer.objects.active = dup
                    bpy.ops.object.convert(target="MESH")
                    # Get the newly created active object
                    dup = bpy.context.active_object

                # Safety check: if conversion failed or it's not a mesh, remove and skip
                if getattr(dup, 'type', '') != 'MESH':
                    if dup:
                        bpy.data.objects.remove(dup, do_unlink=True)
                    continue

                proc_type = match_proc_type(dup.name)
                dup["MyoTwin_ProcType"] = proc_type
                encode_vertex_colors(dup, proc_type, i)
                
            bpy.context.window_manager.progress_end()

            ratio = DECIMATE_RATIO.get(layer_key, 0.25)
            print(f"    - Decimating to {ratio*100}%...")
            bpy.context.window_manager.progress_begin(0, len(export_col.objects))
            total_export_objs = len(export_col.objects)
            print_progress(0, total_export_objs, prefix='      Step 2/2 [Decimate]:', suffix='', length=30)
            for i, obj in enumerate(export_col.objects):
                print_progress(i + 1, total_export_objs, prefix='      Step 2/2 [Decimate]:', suffix='', length=30)
                bpy.context.window_manager.progress_update(i)
                decimate_mesh(obj, ratio)
                
                bpy.context.view_layer.objects.active = obj
                bpy.ops.object.shade_smooth()
                if hasattr(obj.data, "use_auto_smooth"):
                    obj.data.use_auto_smooth = True
            bpy.context.window_manager.progress_end()

            print(f"    - Exporting {glb_base}.glb...")
            bpy.ops.object.select_all(action="DESELECT")
            for obj in export_col.objects:
                obj.select_set(True)
            bpy.context.view_layer.objects.active = export_col.objects[0]
            export_glb(export_path, use_selection=True)
            
            size_kb = os.path.getsize(export_path) / 1024
            print(f"  ✓ Exported ({size_kb:.1f} KB, {len(export_col.objects)} nodes)")

        layer_schema = {
            "meshes": {},
            "procedural_types": {},
        }
        
        for obj in export_col.objects:
            if obj.type != 'MESH':
                continue
                
            proc_type = obj.get("MyoTwin_ProcType", match_proc_type(obj.name))
            layer_schema["meshes"][obj.name] = {
                "procedural_type": proc_type,
                "vertex_count": len(obj.data.vertices),
                "face_count": len(obj.data.polygons),
                "origin": [round(c, 4) for c in obj.location],
                "bounding_center": [
                    round((obj.matrix_world @ obj.data.vertices[0].co)[j], 4)
                    if len(obj.data.vertices) > 0 else [0,0,0]
                    for j in range(3)
                ],
            }
            layer_schema["procedural_types"].setdefault(proc_type, []).append(obj.name)

        schema["layers"][layer_key] = layer_schema
        print_progress(layer_idx, total_layers, prefix='  OVERALL PROGRESS:', suffix='Complete', length=40)

    with open(SCHEMA_PATH, "w") as fp:
        json.dump(schema, fp, indent=2)
    print(f"\n  → Written encoding schema: {SCHEMA_PATH}")

    elapsed = time.time() - start_time
    total_nodes = sum(len(l.get("meshes", {})) for l in schema["layers"].values())
    print(f"\n{'='*60}")
    print(f"  PIPELINE COMPLETE")
    print(f"  TOTAL: {total_nodes} nodes across {len(schema['layers'])} layers")
    print(f"  ELAPSED: {int(elapsed // 60)}m {int(elapsed % 60)}s")
    print(f"{'='*60}")

if __name__ == "__main__":
    try:
        process()
    except Exception as exc:
        print(f"\n✗ Pipeline FAILED: {exc}")
        import traceback
        traceback.print_exc()
        raise
