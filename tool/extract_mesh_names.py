import json
import os
from pygltflib import GLTF2

def extract_names(glb_path):
    gltf = GLTF2().load(glb_path)
    names = []
    # We want nodes that have a mesh
    for node in gltf.nodes:
        if node.mesh is not None:
            names.append(node.name)
    return names

def main():
    base_path = "myotwin/packages/myotwin_app/assets/models"
    layers = ["skeletal", "muscular", "nervous", "cardiovascular", "joints", "insertions"]
    
    results = {}
    
    for layer in layers:
        glb_name = f"myotwin_{layer}.glb"
        path = os.path.join(base_path, glb_name)
        if os.path.exists(path):
            print(f"Processing {glb_name}...")
            results[layer] = extract_names(path)
        else:
            print(f"Warning: {path} not found.")

    with open("physical_node_dump.json", "w") as f:
        json.dump(results, f, indent=2)
    
    print("\nExtraction complete. Results saved to physical_node_dump.json")
    for layer, names in results.items():
        print(f" - {layer}: {len(names)} nodes")

if __name__ == "__main__":
    main()
