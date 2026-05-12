/// Enumeration of BodySegment nodes in the kinetic graph.
/// Mesh names in the GLB model must match these values for shader-driven heatmap mapping.
enum BodySegment {
  TrapeziusUpperL('Trapezius_Upper_L', 'Upper back left'),
  TrapeziusLowerL('Trapezius_Lower_L', 'Lower back left'),
  TrapeziusR('Trapezius_Upper_R', 'Upper back right'),
  TrapeziusLowerR('Trapezius_Lower_R', 'Lower back right'),
  DeltoidAnteriorL('Deltoid_Anterior_L', 'Front shoulder left'),
  DeltoidAnteriorR('Deltoid_Anterior_R', 'Front shoulder right'),
  DeltoidLateralL('Deltoid_Lateral_L', 'Side shoulder left'),
  DeltoidLateralR('Deltoid_Lateral_R', 'Side shoulder right'),
  SerratusAnteriorL('Serratus_Anterior_L', 'Side torso left'),
  SerratusAnteriorR('Serratus_Anterior_R', 'Side torso right'),
  PectoralisMajorL('Pectoralis_Major_L', 'Chest left'),
  PectoralisMajorR('Pectoralis_Major_R', 'Chest right'),
  LatissimusDorsiL('Latissimus_Dorsi_L', 'Mid-back left'),
  LatissimusDorsiR('Latissimus_Dorsi_R', 'Mid-back right'),
  BicepsBrachiiL('Biceps_Brachii_L', 'Bicep left'),
  BicepsBrachiiR('Biceps_Brachii_R', 'Bicep right'),
  TricepsBrachiiL('Triceps_Brachii_L', 'Tricep left'),
  TricepsBrachiiR('Triceps_Brachii_R', 'Tricep right'),
  ForearmFlexorL('Forearm_Flexor_L', 'Inner forearm left'),
  ForearmFlexorR('Forearm_Flexor_R', 'Inner forearm right'),
  ForearmExtensorL('Forearm_Extensor_L', 'Outer forearm left'),
  ForearmExtensorR('Forearm_Extensor_R', 'Outer forearm right'),
  ErectorSpinaeL(' Erector_Spinae_L', 'Lower back left'),
  ErectorSpinaeR('Erector_Spinae_R', 'Lower back right'),
  ErectorSpinae('Erector_Spinae', 'Lower back center'),
  ObliquesExternalL('Obliques_External_L', 'Side waist left'),
  ObliquesExternalR('Obliques_External_R', 'Side waist right'),
  ObliquesInternalL('Obliques_Internal_L', 'Inner oblique left'),
  ObliquesInternalR('Obliques_Internal_R', 'Inner oblique right'),
  RectusAbdominis('Rectus_Abdominis', 'Front abs'),
  GluteusMaximusL('Gluteus_Maximus_L', 'Glute left'),
  GluteusMaximusR('Gluteus_Maximus_R', 'Glute right'),
  GluteusMediusL('Gluteus_Medius_L', 'Hip left'),
  GluteusMediusR('Gluteus_Medius_R', 'Hip right'),
  QuadricepsL('Quadriceps_L', 'Front thigh left'),
  QuadricepsR('Quadriceps_R', 'Front thigh right'),
  HamstringsL('Hamstrings_L', 'Back thigh left'),
  HamstringsR('Hamstrings_R', 'Back thigh right'),
  GastrocnemiusL('Gastrocnemius_L', 'Calf left'),
  GastrocnemiusR('Gastrocnemius_R', 'Calf right'),
  TibialisAnteriorL('Tibialis_Anterior_L', 'Shin left'),
  TibialisAnteriorR('Tibialis_Anterior_R', 'Shin right'),
  HipFlexorL('Hip_Flexor_L', 'Hip flexor left'),
  HipFlexorR('Hip_Flexor_R', 'Hip flexor right'),
  InguinalL('Inguinal_L', 'Groin left'),
  InguinalR('Inguinal_R', 'Groin right'),
  GlenohumeralL('Glenohumeral_L', 'Shoulder joint left'),
  GlenohumeralR('Glenohumeral_R', 'Shoulder joint right'),
  ThoracicSpine('Thoracic_Spine', 'Mid spine'),
  LumbarSpine('Lumbar_Spine', 'Lower spine'),
  CervicalSpine('Cervical_Spine', 'Neck'),
  CoreNode('Core_Node', 'Core center'),
  AnkleL('L_Ankle', 'Ankle left'),
  AnkleR('L_Ankle_R', 'Ankle right'),
  ShoulderL('Shoulder_L', 'Left shoulder joint'),
  ShoulderR('Shoulder_R', 'Right shoulder joint')
  ;

  /// Anatomical identifier used in database and GLB mesh names.
  final String anatomicalId;

  /// Human-readable description.
  final String description;

  const BodySegment(this.anatomicalId, this.description);
}
