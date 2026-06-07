import json
import re

# This script generates a full semantic map from the Blender outliner dump.
# It uses an extensive matrix of anatomical keywords to enrich the "regions"
# array, allowing for true semantic-style search matching in the UI.

KEYWORD_MAP = {
    r"bone|vertebra|skeleton|skull|axial|girdle|phalanx|clavicle|humerus|femur|tibia|fibula|pelvis|ilium|ischium|pubis|mandible|maxilla|sacrum|coccyx|rib|sternum": "skeletal",
    r"muscle|abductor|adductor|extensor|flexor|vastus|rectus|oblique|teres|biceps|triceps|deltoid|pronator|masseter|diaphragm": "muscular",
    r"joint|ligament|suture|syndesmosis|capsule|disc|meniscus|zonule": "joints",
    r"nerve|spinal cord|brain|plexus|ganglion|sense organ|eye|ear|cortex|nucleus|thalamus": "nervous",
    r"artery|vein|vessel|aorta|cardiovascular|heart|valve|sinus|atrium|ventricle": "cardiovascular",
    r"insertion": "insertions",
}

# The Semantic Matrix: Maps regex patterns to lists of rich semantic tags
SEMANTIC_MATRIX = [
    (r"radius|ulna|brachioradialis|flexor_carpi|extensor_carpi|pronator|supinator|antebrachial", ["forearm", "lower arm", "arm", "upper limb", "wrist"]),
    (r"humerus|biceps|triceps|brachialis|coracobrachialis", ["upper arm", "arm", "upper limb", "bicep", "tricep"]),
    (r"scapula|clavicle|deltoid|supraspinatus|infraspinatus|teres|subscapularis|acromioclavicular|glenohumeral", ["shoulder", "arm", "upper limb", "rotator cuff", "shoulder blade", "collar bone"]),
    (r"carpal|metacarpal|phalanx.*hand|digit.*hand|pollicis|digiti_minimi.*hand|thenar|hypothenar", ["hand", "wrist", "fingers", "thumb", "upper limb"]),
    (r"femur|quadriceps|hamstring|sartorius|rectus_femoris|vastus|biceps_femoris|semitendinosus|semimembranosus|iliopsoas|pectineus|gracilis", ["thigh", "upper leg", "leg", "lower limb", "quad", "hammy", "hamstring"]),
    (r"tibia|fibula|calf|soleus|gastrocnemius|tibialis|peroneal|fibularis|extensor_digitorum_longus|flexor_digitorum_longus", ["calf", "lower leg", "leg", "lower limb", "shin"]),
    (r"tarsal|metatarsal|phalanx.*foot|digit.*foot|hallucis|calcaneus|talus|cuboid|cuneiform|navicular", ["foot", "ankle", "toes", "lower limb", "heel"]),
    (r"patella|cruciate|meniscus|collateral_ligament.*knee|popliteal", ["knee", "leg", "lower limb", "joint"]),
    (r"pelvis|ilium|ischium|pubis|sacrum|coccyx|gluteus|piriformis|obturator|gemellus|quadratus_femoris|sacroiliac", ["pelvis", "hip", "glutes", "buttocks", "core", "tailbone"]),
    (r"vertebra|spine|spinal|intervertebral|erector_spinae|multifidus|rotatores|iliocostalis|longissimus|spinalis", ["spine", "back", "core", "vertebral column"]),
    (r"cervical|atlas|axis", ["neck", "cervical spine"]),
    (r"lumbar|sacral", ["lower back", "lumbar spine"]),
    (r"thoracic", ["mid back", "thoracic spine"]),
    (r"rib|sternum|costal|intercostal|pectoral|thorax|chest", ["chest", "thorax", "ribcage", "core", "pecs"]),
    (r"abdominis|oblique|transversus|linea_alba|diaphragm", ["abdomen", "abs", "core", "belly", "stomach"]),
    (r"skull|cranium|facial|mandible|maxilla|zygomatic|parietal|frontal|occipital|temporal|sphenoid|ethmoid|nasal", ["head", "skull", "face", "jaw", "cheek"]),
    (r"brain|cerebrum|cerebellum|pons|medulla|thalamus|hypothalamus|cortex|gyrus|sulcus|ventricle|meninges|dura|pia|arachnoid", ["brain", "central nervous system", "head"]),
    (r"eye|optic|retina|sclera|cornea|iris|lens|ciliary|macula|fovea|orbicularis_oculi", ["eye", "vision", "head"]),
    (r"ear|cochlea|vestibular|tympanic|malleus|incus|stapes|auricle", ["ear", "hearing", "head"]),
    (r"heart|atrium|ventricle|aorta|vena_cava|pulmonary|coronary|mitral|tricuspid|myocardium|pericardium", ["heart", "chest", "cardiovascular"]),
    (r"lung|bronchi|pleura|trachea|alveoli", ["lung", "respiratory", "chest"]),
    (r"liver|hepatic|gallbladder|biliary", ["liver", "abdomen", "digestive"]),
    (r"stomach|gastric|pyloric|esophagus", ["stomach", "abdomen", "digestive", "gut"]),
    (r"kidney|renal|ureter|bladder|urethra", ["kidney", "abdomen", "urinary"]),
    (r"intestine|colon|cecum|rectum|anal|bowel", ["intestine", "abdomen", "digestive", "bowel"]),
]

def sanitize_id(raw_name):
    clean_name = raw_name.split('.')[0]
    clean_name = clean_name.replace(" ", "").replace("(", "").replace(")", "").replace("-", "").replace("'", "")
    if ".r" in raw_name.lower() or "right_" in clean_name.lower():
        if not clean_name.endswith("_R"):
            clean_name += "_R"
    elif ".l" in raw_name.lower() or "left_" in clean_name.lower():
        if not clean_name.endswith("_L"):
            clean_name += "_L"
    return clean_name

def generate_layman(raw_name):
    name = raw_name.split('.')[0]
    name = name.replace("(", "").replace(")", "").replace("-", " ").replace("'", "")
    if ".r" in raw_name.lower():
        name += " (Right)"
    elif ".l" in raw_name.lower():
        name += " (Left)"
    return " ".join(word.capitalize() for word in name.split())

def process():
    semantic_map = []
    current_layer = None
    
    with open('blender_outliner_dump.txt', 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith("Collection:"):
                col_name = line.replace("Collection: ", "").lower()
                for pattern, layer in KEYWORD_MAP.items():
                    if re.search(pattern, col_name):
                        current_layer = layer
                        break
            
            elif line.startswith("-") and "(Type: MESH)" in line:
                if current_layer is None: continue
                
                raw_name = line.replace("- ", "").replace(" (Type: MESH)", "")
                id = sanitize_id(raw_name)
                
                if any(m['id'] == id for m in semantic_map): continue

                layman = generate_layman(raw_name)
                
                # Apply Semantic Matrix (matching against the mesh name)
                regions = set()
                raw_lower = raw_name.lower()
                for pattern, tags in SEMANTIC_MATRIX:
                    if re.search(pattern, raw_lower):
                        regions.update(tags)
                
                semantic_map.append({
                    "id": id,
                    "laymanName": layman,
                    "layer": current_layer,
                    "regions": list(regions)
                })

    VALID_LAYERS = ["skeletal", "muscular", "nervous", "cardiovascular", "joints", "insertions"]
    final_map = [n for n in semantic_map if n["layer"] in VALID_LAYERS]

    with open('myotwin/packages/myotwin_app/assets/models/semantic_anatomy.json', 'w') as f:
        json.dump(final_map, f, indent=2)

    print(f"Total Unique Meshes Mapped: {len(final_map)}")
    for layer in VALID_LAYERS:
        count = len([n for n in final_map if n["layer"] == layer])
        print(f" - {layer.capitalize()}: {count} nodes")

process()
