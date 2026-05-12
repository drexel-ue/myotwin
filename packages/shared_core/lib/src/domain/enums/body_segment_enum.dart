/// Enumeration of BodySegment nodes in the kinetic graph.
/// Mesh names in the GLB model must match these values for shader-driven heatmap mapping.
enum BodySegment {
  trapeziusUpperL('Trapezius_Upper_L', 'Upper back left'),
  trapeziusLowerL('Trapezius_Lower_L', 'Lower back left'),
  trapeziusR('Trapezius_Upper_R', 'Upper back right'),
  trapeziusLowerR('Trapezius_Lower_R', 'Lower back right'),
  deltoidAnteriorL('Deltoid_Anterior_L', 'Front shoulder left'),
  deltoidAnteriorR('Deltoid_Anterior_R', 'Front shoulder right'),
  deltoidLateralL('Deltoid_Lateral_L', 'Side shoulder left'),
  deltoidLateralR('Deltoid_Lateral_R', 'Side shoulder right'),
  serratusAnteriorL('Serratus_Anterior_L', 'Side torso left'),
  serratusAnteriorR('Serratus_Anterior_R', 'Side torso right'),
  pectoralisMajorL('Pectoralis_Major_L', 'Chest left'),
  pectoralisMajorR('Pectoralis_Major_R', 'Chest right'),
  latissimusDorsiL('Latissimus_Dorsi_L', 'Mid-back left'),
  latissimusDorsiR('Latissimus_Dorsi_R', 'Mid-back right'),
  bicepsBrachiiL('Biceps_Brachii_L', 'Bicep left'),
  bicepsBrachiiR('Biceps_Brachii_R', 'Bicep right'),
  tricepsBrachiiL('Triceps_Brachii_L', 'Tricep left'),
  tricepsBrachiiR('Triceps_Brachii_R', 'Tricep right'),
  forearmFlexorL('Forearm_Flexor_L', 'Inner forearm left'),
  forearmFlexorR('Forearm_Flexor_R', 'Inner forearm right'),
  forearmExtensorL('Forearm_Extensor_L', 'Outer forearm left'),
  forearmExtensorR('Forearm_Extensor_R', 'Outer forearm right'),
  erectorSpinaeL('Erector_Spinae_L', 'Lower back left'),
  erectorSpinaeR('Erector_Spinae_R', 'Lower back right'),
  erectorSpinae('Erector_Spinae', 'Lower back center'),
  obliquesExternalL('Obliques_External_L', 'Side waist left'),
  obliquesExternalR('Obliques_External_R', 'Side waist right'),
  obliquesInternalL('Obliques_Internal_L', 'Inner oblique left'),
  obliquesInternalR('Obliques_Internal_R', 'Inner oblique right'),
  rectusAbdominis('Rectus_Abdominis', 'Front abs'),
  gluteusMaximusL('Gluteus_Maximus_L', 'Glute left'),
  gluteusMaximusR('Gluteus_Maximus_R', 'Glute right'),
  gluteusMediusL('Gluteus_Medius_L', 'Hip left'),
  gluteusMediusR('Gluteus_Medius_R', 'Hip right'),
  quadricepsL('Quadriceps_L', 'Front thigh left'),
  quadricepsR('Quadriceps_R', 'Front thigh right'),
  hamstringsL('Hamstrings_L', 'Back thigh left'),
  hamstringsR('Hamstrings_R', 'Back thigh right'),
  gastrocnemiusL('Gastrocnemius_L', 'Calf left'),
  gastrocnemiusR('Gastrocnemius_R', 'Calf right'),
  tibialisAnteriorL('Tibialis_Anterior_L', 'Shin left'),
  tibialisAnteriorR('Tibialis_Anterior_R', 'Shin right'),
  hipFlexorL('Hip_Flexor_L', 'Hip flexor left'),
  hipFlexorR('Hip_Flexor_R', 'Hip flexor right'),
  inguinalL('Inguinal_L', 'Groin left'),
  inguinalR('Inguinal_R', 'Groin right'),
  glenohumeralL('Glenohumeral_L', 'Shoulder joint left'),
  glenohumeralR('Glenohumeral_R', 'Shoulder joint right'),
  thoracicSpine('Thoracic_Spine', 'Mid spine'),
  lumbarSpine('Lumbar_Spine', 'Lower spine'),
  cervicalSpine('Cervical_Spine', 'Neck'),
  coreNode('Core_Node', 'Core center'),
  ankleL('L_Ankle', 'Ankle left'),
  ankleR('L_Ankle_R', 'Ankle right'),
  shoulderL('Shoulder_L', 'Left shoulder joint'),
  shoulderR('Shoulder_R', 'Right shoulder joint')
  ;

  const BodySegment(this.anatomicalId, this.description);
  
  /// Anatomical identifier used in database and GLB mesh names.
  final String anatomicalId;

  /// Human-readable description.
  final String description;

}
