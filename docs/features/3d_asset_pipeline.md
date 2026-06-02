# 3D Anatomy Asset Pipeline (Blender to Flutter)

## Overview
This document outlines the specialized pipeline used to extract, optimize, and sanitize the 3D anatomical assets for the MyoTwin HUD. Because the source Z-Anatomy model is massive (~400k triangles), this pipeline is critical for ensuring fluid 60FPS performance on mobile devices.

---

## 1. Blender Scene Setup
1. **Application Template**: Install the `Z-Anatomy.zip` file as a Blender Application Template (**Blender Icon > Install Application Template**).
2. **Initialize Scene**: Open a new scene using the **File > New > Z-Anatomy** option.
3. **Core Collections**: The source model organizes systems into numbered collections (e.g., `1: Skeletal system`, `4: Muscular system`).

---

## 2. Polygon Optimization (Mobile Performance)
To run on Impeller (Flutter's 3D engine), the polygon count must be significantly reduced.
1. Select a high-density collection (e.g., `Muscular system`).
2. Mouse over the 3D viewport and press **`A`** to select all meshes.
3. In the **Modifier Properties** (Wrench Icon), add a **Decimate** modifier.
4. Set the **Ratio** to **`0.35`** (65% reduction).
5. Apply the modifier (**v arrow > Apply**).
   - *Result*: Dramatically reduces file size and GPU draw time while preserving anatomical volume.

---

## 3. The Master Export Script
The following Python script must be run in Blender's **Scripting** tab. It automates the sanitization of mesh names (required for AI heatmap targeting) and batch-exports the 6 system layers in the **Uncompressed GLB** format required by `flutter_scene`.

```python
import bpy
import os

# Update this path to your local myotwin workspace
OUTPUT_DIR = "/Users/ikkeshpack/Development/LamontLabs/myotwin_workspace/myotwin/packages/myotwin_app/assets/models/"

def setup_export():
    if not os.path.exists(OUTPUT_DIR):
        os.makedirs(OUTPUT_DIR)

    collections_to_export = {
        "1: Skeletal system": "myotwin_skeletal",
        "2: Muscular insertions": "myotwin_insertions",
        "3: Joints": "myotwin_joints",
        "4: Muscular system": "myotwin_muscular",
        "5: Cardiovascular system": "myotwin_cardiovascular",
        "7: Nervous system & Sense organs": "myotwin_nervous"
    }

    def process_collection(source_name, target_name):
        source_col = bpy.data.collections.get(source_name)
        if not source_col: return None
            
        target_col = bpy.data.collections.new(target_name)
        bpy.context.scene.collection.children.link(target_col)

        for obj in source_col.all_objects:
            if obj.type == 'MESH':
                raw_name = obj.name
                # Sanitize name: remove extensions (.r, .l) and symbols
                clean_name = raw_name.split('.')[0] 
                clean_name = clean_name.replace(" ", "_").replace("(", "").replace(")", "").replace("-", "_").replace("'", "")
                
                # Append standard MyoTwin L/R suffixes
                if ".r" in raw_name.lower() or "right_" in clean_name.lower():
                    clean_name += "_R"
                elif ".l" in raw_name.lower() or "left_" in clean_name.lower():
                    if not clean_name.endswith("_L"):
                        clean_name += "_L"
                
                obj.name = clean_name
                try: target_col.objects.link(obj)
                except Exception: pass
        return target_col

    for source_name, target_file_base in collections_to_export.items():
        clean_col = process_collection(source_name, f"Export_{target_file_base}")
        if not clean_col: continue
        bpy.ops.object.select_all(action='DESELECT')
        for obj in clean_col.objects: obj.select_set(True)
        
        # EXPORT SETTINGS: Uncompressed GLB + Normals
        export_path = os.path.join(OUTPUT_DIR, f"{target_file_base}.glb")
        bpy.ops.export_scene.gltf(
            filepath=export_path,
            use_selection=True,
            export_format='GLB',
            export_materials='NONE', # We use procedural Flutter shaders
            export_draco_mesh_compression_enable=False, # Mandatory: flutter_scene doesn't support Draco
            export_normals=True # Mandatory: Required for lighting
        )

setup_export()
```

---

## 4. Flutter Asset Registration
Once exported, the files live in `myotwin_app/assets/models/`. They are registered in the `pubspec.yaml` of the app package:

```yaml
flutter:
  assets:
    - assets/models/
```
