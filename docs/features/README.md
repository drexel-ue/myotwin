# MyoTwin HUD Feature Documentation

This directory contains technical references and architectural deep-dives for the unique hardware-inspired features of the MyoTwin HUD.

---

## Technical Pillars

### [Biomechanical Intelligence & Multi-Goal Context](./biomechanical_intelligence.md)
How Motus maintains global awareness of user objectives and anatomical nodes (Kinetic Chains) across multiple concurrent goals.

### [3D Digital Twin & Visualization](./3d_digital_twin.md)
Architectural overview of the Impeller-powered 3D anatomy viewport, including tactical shaders, reactive heatmaps, and the cinematic interaction model.

### [Interactive GenUI Model](./interactive_genui_model.md)
Deep-dive into the mechanical interaction language: parabolic FAB sliders, rotary command menus, and shader-masked HUD overlays.

---

## Asset Pipelines

### [3D Anatomy Asset Pipeline](./3d_asset_pipeline.md)
The specialized "Blender-to-Flutter" workflow for extracting, optimizing (decimating), and sanitizing anatomical models for high-performance mobile rendering.

### [Unstructured Data Strategy](./unstructured_data_strategy.md)
Our approach to evolving AI data schemas using Drift JSONB columns and zero-cost Dart 3.3 Extension Type wrappers.
