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

## 5. Blender Cleanup Steps (Required)

Regardless of source, model must pass through Blender before import:

1. **Mesh Names Cleanup**: Rename all meshes per naming convention above.
2. **Layer Separation**: Ensure muscle groups, bones, and vessels are separate top-level objects.
3. **Origin to Geometry**: Set each mesh origin to its geometry center.
4. **Apply Transforms**: Apply scale and rotation to all meshes.
5. **Remove Doubles**: Merge vertices within 0.001m threshold to remove Z-fighting.
6. **Remove Non-Manifold Geometry**: Remove degenerate faces.
7. **Export as .glb**: glTF 2.0, compress mesh data, include custom attributes.

## 6. Mesh-to-Node Mapper JSON

After export, a mapping JSON must be generated (via Blender Python script or manually):

```json
{
  "Glenohumeral_Joint_L": {
    "mesh_name": "Shoulder_Joint_GL",
    "vertex_count": 1240,
    "bounding_center": [0.15, 0.62, 0.0],
    "anatomical_region": "shoulder",
    "layer": "skeletal"
  },
  "Trapezius_L": {
    "mesh_name": "Upper_Trapezius_L",
    "vertex_count": 3800,
    "bounding_center": [-0.12, 0.35, 0.0],
    "anatomical_region": "shoulder",
    "layer": "muscular"
  }
}
```

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
