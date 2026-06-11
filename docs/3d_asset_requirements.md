# MyoTwin 3D Asset Requirements — Checklist

This checklist ensures any GLB model source (Z-Anatomy, Sketchfab, TurboSquid, CGTrader, NIH 3D Exchange) is suitable for import into the MyoTwin rendering pipeline. A good asset makes Phase 2 trivial; a bad one makes it painful.

## 1. Mesh Geometry & Organization

- [ ] **Discrete Objects**: Model must NOT be a single merged mesh. Every muscle, bone, vessel, and joint must be a separate object/node in the GLB hierarchy.
- [ ] **Parent-Child Hierarchy**: Objects grouped logically (e.g., `Right_Arm_Group > Humerus > Bicep_LongHead`). Required for group-based mechanical explosion later.
- [ ] **Origin Points (Pivots)**: Each mesh origin at its anatomical center of mass (not world origin). Required for correct exploded view radial offsets.
- [ ] **No Overlapping Geometry**: Avoid Z-fighting (two meshes occupying the same space). Causes shader flickering.

## 2. Naming Conventions

- [ ] **Anatomical Naming**: Clean, meaningful names matching `BodySegment` IDs in `shared_core`. No `Mesh.001`, `Object.456`, or Blender defaults.
  - ✅ `Trapezius_L`, `Serratus_Anterior_R`, `Gastrocnemius_Lateral`, `Glenohumeral_Joint_L`
  - ❌ `mesh_12`, `l_deltoid copy`, `torso_001`
- [ ] **Case Consistency**: Use PascalCase or camelCase consistently across all meshes.
- [ ] **Side Suffix**: Left = `_L`, Right = `_R`. No exceptions.

## 3. Anatomical Layers

- [ ] **Skeletal Layer**: All bones (minimum 206), grouped by region. Names: `Skull_*`, `Humerus_L`, `Femur_R`, etc.
- [ ] **Muscular Layer**: All major muscle groups (minimum 500), grouped by region. Names: `Biceps_Brachii_L`, `Gluteus_Maximus_R`, etc.
- [ ] **Cardiovascular Layer** (V2): Heart and major vessels. Names: `Aorta`, `Left_Ventricle`, `Lung_L`, etc.
- [ ] **Joint Capsules**: Named joint boundaries for heatmap mapping.

## 4. Performance

- [ ] **Triangle Count**: Total model < 150,000 triangles across all layers. Mobile GPU budget.
- [ ] **No Textures Needed**: Default/base material only. No textures, normal maps, or PBR materials. Shaders handle all color.
- [ ] **No Rigging/Bones**: Static mesh only. No armature, skin weights, or bone animations. Rendering is material color manipulation via shaders.
- [ ] **File Format**: `.glb` (binary glTF) — single-file format.
- [ ] **Export Settings**: glTF 2.0, "Include Custom Attributes" checked, "Compress Mesh Data" enabled.

## 5. Automated Pipeline: Z-Anatomy Exporter

The manual cleanup and export process has been completely automated. We now use the unified `auto_process_and_export.py` script located in `myotwin/tool/auto_process_and_export.py`.

### How to use:
1. Open your Z-Anatomy `.blend` file in Blender.
2. Ensure collections are named correctly (e.g., `1: Skeletal system`, `4: Muscular system`).
3. Switch to the **Scripting** workspace in Blender.
4. Open the `myotwin/tool/auto_process_and_export.py` script.
5. Run the script.

### What the script does:
- **Idempotency**: Hashes the source collections and skips unaltered layers.
- **Curve-to-Mesh**: Automatically converts necessary curves into valid geometry.
- **Decimation**: Reduces mesh density based on anatomical type (e.g., bones 20%, cardiovascular 50%) for mobile performance.
- **Procedural Baking**: Encodes flow direction, blood pressure, and neural hierarchies into vertex colors (`MyoData`) for the procedural animation engine.
- **Simultaneous Export**: Automatically outputs the optimized `.glb` files and builds the required `anatomy_encoding_schema.json` directly into the Flutter app's assets folder (`assets/models/`).

There is no longer a need to manually create the Mesh-to-Node JSON schema or manually export GLTF files.


## 7. Recommended Sources

| Source | Type | Cost | Notes |
|---|---|---|---|
| [Z-Anatomy](https://z-anatomy.github.io/z-anatomy/) | Open-source anatomical atlas | Free | Mesh groups, hierarchical. Best starting point. |
| [Sketchfab](https://sketchfab.com) | Web-ready 3D models | Free or paid | Search "anatomy layered" or "segregated". Look for "segmented" description. |
| [NIH 3D Exchange](https://3d.nih.gov) | NIH/NLM medical models | Free | High accuracy. Verify mesh separation. |
| [TurboSquid / CGTrader](https://turboquid.com) | Professional medical models | Paid ($100–$500) | Highest topology quality. May need FBX → Blender → glb conversion. |

## 8. Red Flags — Reject If Present

- ❌ "Single mesh" or "non-segregated" in description
- ❌ "One piece" or "solid" object
- ❌ Blender `.blend` source without `.glb` export capability
- ❌ >150k triangles
- ❌ Textures >1MB
- ❌ Rigged/animated only without clean static export
- ❌ Mesh names include `mesh`, `object`, `part`, `group` (e.g. `mesh_001`)
- ❌ Z-fighting visible in Blender preview mode

---

**Document version**: 1.0
**Last updated**: 2026-05-11
