/// Enumeration of BodySegment nodes in the kinetic graph.
/// Mesh names in the GLB model must match these values for shader-driven heatmap mapping.
enum BodySegment {
  /// Upper back left.
  trapeziusUpperL('Trapezius_Upper_L', 'Upper back left'),

  /// Lower back left.
  trapeziusLowerL('Trapezius_Lower_L', 'Lower back left'),

  /// Upper back right.
  trapeziusR('Trapezius_Upper_R', 'Upper back right'),

  /// Lower back right.
  trapeziusLowerR('Trapezius_Lower_R', 'Lower back right'),

  /// Front shoulder left.
  deltoidAnteriorL('Deltoid_Anterior_L', 'Front shoulder left'),

  /// Front shoulder right.
  deltoidAnteriorR('Deltoid_Anterior_R', 'Front shoulder right'),

  /// Side shoulder left.
  deltoidLateralL('Deltoid_Lateral_L', 'Side shoulder left'),

  /// Side shoulder right.
  deltoidLateralR('Deltoid_Lateral_R', 'Side shoulder right'),

  /// Side torso left.
  serratusAnteriorL('Serratus_Anterior_L', 'Side torso left'),

  /// Side torso right.
  serratusAnteriorR('Serratus_Anterior_R', 'Side torso right'),

  /// Chest left.
  pectoralisMajorL('Pectoralis_Major_L', 'Chest left'),

  /// Chest right.
  pectoralisMajorR('Pectoralis_Major_R', 'Chest right'),

  /// Mid-back left.
  latissimusDorsiL('Latissimus_Dorsi_L', 'Mid-back left'),

  /// Mid-back right.
  latissimusDorsiR('Latissimus_Dorsi_R', 'Mid-back right'),

  /// Bicep left.
  bicepsBrachiiL('Biceps_Brachii_L', 'Bicep left'),

  /// Bicep right.
  bicepsBrachiiR('Biceps_Brachii_R', 'Bicep right'),

  /// Tricep left.
  tricepsBrachiiL('Triceps_Brachii_L', 'Tricep left'),

  /// Tricep right.
  tricepsBrachiiR('Triceps_Brachii_R', 'Tricep right'),

  /// Inner forearm left.
  forearmFlexorL('Forearm_Flexor_L', 'Inner forearm left'),

  /// Inner forearm right.
  forearmFlexorR('Forearm_Flexor_R', 'Inner forearm right'),

  /// Outer forearm left.
  forearmExtensorL('Forearm_Extensor_L', 'Outer forearm left'),

  /// Outer forearm right.
  forearmExtensorR('Forearm_Extensor_R', 'Outer forearm right'),

  /// Lower back left.
  erectorSpinaeL('Erector_Spinae_L', 'Lower back left'),

  /// Lower back right.
  erectorSpinaeR('Erector_Spinae_R', 'Lower back right'),

  /// Lower back center.
  erectorSpinae('Erector_Spinae', 'Lower back center'),

  /// Side waist left.
  obliquesExternalL('Obliques_External_L', 'Side waist left'),

  /// Side waist right.
  obliquesExternalR('Obliques_External_R', 'Side waist right'),

  /// Inner oblique left.
  obliquesInternalL('Obliques_Internal_L', 'Inner oblique left'),

  /// Inner oblique right.
  obliquesInternalR('Obliques_Internal_R', 'Inner oblique right'),

  /// Front abs.
  rectusAbdominis('Rectus_Abdominis', 'Front abs'),

  /// Glute left.
  gluteusMaximusL('Gluteus_Maximus_L', 'Glute left'),

  /// Glute right.
  gluteusMaximusR('Gluteus_Maximus_R', 'Glute right'),

  /// Hip left.
  gluteusMediusL('Gluteus_Medius_L', 'Hip left'),

  /// Hip right.
  gluteusMediusR('Gluteus_Medius_R', 'Hip right'),

  /// Front thigh left.
  quadricepsL('Quadriceps_L', 'Front thigh left'),

  /// Front thigh right.
  quadricepsR('Quadriceps_R', 'Front thigh right'),

  /// Back thigh left.
  hamstringsL('Hamstrings_L', 'Back thigh left'),

  /// Back thigh right.
  hamstringsR('Hamstrings_R', 'Back thigh right'),

  /// Calf left.
  gastrocnemiusL('Gastrocnemius_L', 'Calf left'),

  /// Calf right.
  gastrocnemiusR('Gastrocnemius_R', 'Calf right'),

  /// Shin left.
  tibialisAnteriorL('Tibialis_Anterior_L', 'Shin left'),

  /// Shin right.
  tibialisAnteriorR('Tibialis_Anterior_R', 'Shin right'),

  /// Hip flexor left.
  hipFlexorL('Hip_Flexor_L', 'Hip flexor left'),

  /// Hip flexor right.
  hipFlexorR('Hip_Flexor_R', 'Hip flexor right'),

  /// Groin left.
  inguinalL('Inguinal_L', 'Groin left'),

  /// Groin right.
  inguinalR('Inguinal_R', 'Groin right'),

  /// Shoulder joint left.
  glenohumeralL('Glenohumeral_L', 'Shoulder joint left'),

  /// Shoulder joint right.
  glenohumeralR('Glenohumeral_R', 'Shoulder joint right'),

  /// Mid spine.
  thoracicSpine('Thoracic_Spine', 'Mid spine'),

  /// Lower spine.
  lumbarSpine('Lumbar_Spine', 'Lower spine'),

  /// Neck.
  cervicalSpine('Cervical_Spine', 'Neck'),

  /// Core center.
  coreNode('Core_Node', 'Core center'),

  /// Ankle left.
  ankleL('L_Ankle', 'Ankle left'),

  /// Ankle right.
  ankleR('L_Ankle_R', 'Ankle right'),

  /// Left shoulder joint.
  shoulderL('Shoulder_L', 'Left shoulder joint'),

  /// Right shoulder joint.
  shoulderR('Shoulder_R', 'Right shoulder joint')
  ;

  const BodySegment(this.anatomicalId, this.description);

  /// Anatomical identifier used in database and GLB mesh names.
  final String anatomicalId;

  /// Human-readable description.
  final String description;
}
