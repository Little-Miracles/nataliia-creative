class RelaxExercise {
  final String id;
  final String title;
  final String description;
  final String purpose;
  final String contraindications;
  final int duration;
  final double kcal; // Оставляем
  final String image;

  RelaxExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.image,
    this.kcal = 0.0, // СДЕЛАЛИ ПО УМОЛЧАНИЮ (Ошибки исчезнут здесь)
    this.purpose = "General health improvement.",
    this.contraindications = "Consult a doctor if you have injuries.",
  });
}

class RelaxData {
  // 1. Energy Flow (Surya Namaskar)
  static List<RelaxExercise> energyFlow = [
    RelaxExercise(id: 'M042', title: 'Prayer Pose', description: 'Stand upright, feet together, palms at heart center. Breathe deeply.', duration: 15, image: 'res_gym/M042.png'),
    RelaxExercise(id: 'M043', title: 'Raised Arms Pose', description: 'Inhale, lift arms up and slightly back, pushing hips forward.', duration: 15, image: 'res_gym/M043.png'),
    RelaxExercise(id: 'M044', title: 'Hand to Foot Pose', description: 'Exhale, fold forward from the hips. Touch the floor or your ankles.', duration: 20, image: 'res_gym/M044.png'),
    RelaxExercise(id: 'M045', title: 'Equestrian Pose', description: 'Inhale, step your right leg back, knee on the floor. Look up.', duration: 20, image: 'res_gym/M045.png'),
    RelaxExercise(id: 'M046', title: 'Plank Pose', description: 'Hold your breath, bring the other leg back. Keep your body straight.', duration: 15, image: 'res_gym/M046.png'),
    RelaxExercise(id: 'M047', title: 'Eight-Limbed Pose', description: 'Exhale, drop knees, chest, and chin to the floor. Keep hips raised.', duration: 15, image: 'res_gym/M047.png'),
    RelaxExercise(id: 'M048', title: 'Cobra Pose', description: 'Inhale, slide forward and lift your chest. Keep shoulders down.', duration: 20, image: 'res_gym/M048.png'),
    RelaxExercise(id: 'M049', title: 'Downward Dog', description: 'Exhale, lift your hips high, forming an inverted V-shape.', duration: 20, image: 'res_gym/M049.png'),
    RelaxExercise(id: 'M050', title: 'Equestrian Pose (Left)', description: 'Inhale, step your left leg forward between your hands.', duration: 20, image: 'res_gym/M050.png'),
    RelaxExercise(id: 'M051', title: 'Hand to Foot Pose', description: 'Exhale, bring the back leg forward and fold down.', duration: 20, image: 'res_gym/M051.png'),
    RelaxExercise(id: 'M052', title: 'Raised Arms Pose', description: 'Inhale, reach up and back to stretch the front of your body.', duration: 15, image: 'res_gym/M052.png'),
    RelaxExercise(id: 'M053', title: 'Mountain Pose', description: 'Exhale, return to a standing position. Feel the energy flow.', duration: 15, image: 'res_gym/M053.png'),
  ];

  // 2. Deep Recovery (Sivananda 12)
  static List<RelaxExercise> deepRecovery = [
    RelaxExercise(id: 'M054', title: 'Shoulderstand', description: 'Lift legs and torso vertically. Support your back with hands.', duration: 60, image: 'res_gym/M054.png'),
    RelaxExercise(id: 'M055', title: 'Plough Pose', description: 'From shoulderstand, lower feet behind your head to the floor.', duration: 45, image: 'res_gym/M055.png'),
    RelaxExercise(id: 'M056', title: 'Fish Pose', description: 'Arch your back while lying down, resting on elbows and head.', duration: 30, image: 'res_gym/M056.png'),
    RelaxExercise(id: 'M057', title: 'Sitting Forward Fold', description: 'Sit with legs straight, fold forward and hold your toes.', duration: 60, image: 'res_gym/M057.png'),
    RelaxExercise(id: 'M058', title: 'Cobra (Power Hold)', description: 'Lift chest using back muscles. Hold for strength.', duration: 30, image: 'res_gym/M058.png'),
    RelaxExercise(id: 'M059', title: 'Locust Pose', description: 'Lift legs and chest simultaneously. Balance on your abdomen.', duration: 30, image: 'res_gym/M059.png'),
    RelaxExercise(id: 'M060', title: 'Bow Pose', description: 'Hold your ankles and arch your back like a bow.', duration: 30, image: 'res_gym/M060.png'),
    RelaxExercise(id: 'M061', title: 'Spinal Twist', description: 'Sit and twist your torso to the side. Improve spine flexibility.', duration: 45, image: 'res_gym/M061.png'),
    RelaxExercise(id: 'M062', title: 'Crow Pose', description: 'Balance on your hands with knees tucked into your armpits.', duration: 20, image: 'res_gym/M062.png'),
    RelaxExercise(id: 'M063', title: 'Standing Fold', description: 'A deep standing stretch for the hamstrings and spine.', duration: 45, image: 'res_gym/M063.png'),
    RelaxExercise(id: 'M064', title: 'Triangle Pose', description: 'Wide stance, reach down to your foot, other arm up.', duration: 30, image: 'res_gym/M064.png'),
    RelaxExercise(id: 'M065', title: 'Corpse Pose', description: 'Lie flat on your back, relax every muscle. Total stillness.', duration: 120, image: 'res_gym/M065.png'),
  ];

  // 3. Zen Breath (Pranayama)
  static List<RelaxExercise> zenBreath = [
    RelaxExercise(id: 'M066', title: 'Easy Pose', description: 'Sit with a straight back. Prepare for breathing exercises.', duration: 30, image: 'res_gym/M066.png'),
    RelaxExercise(id: 'M067', title: 'Skull Shining Breath', description: 'Forceful exhales using the abdomen to clear the lungs.', duration: 60, image: 'res_gym/M067.png'),
    RelaxExercise(id: 'M068', title: 'Bellows Breath', description: 'Equal, powerful inhalations and exhalations for energy.', duration: 60, image: 'res_gym/M068.png'),
    RelaxExercise(id: 'M069', title: 'Alternate Nostril', description: 'Balance your energy by breathing through one nostril at a time.', duration: 120, image: 'res_gym/M069.png'),
    RelaxExercise(id: 'M070', title: 'Cooling Breath', description: 'Inhale through a rolled tongue to cool the body and mind.', duration: 60, image: 'res_gym/M070.png'),
    RelaxExercise(id: 'M071', title: 'Humming Bee Breath', description: 'Cover ears and eyes, exhale with a humming sound.', duration: 60, image: 'res_gym/M071.png'),
    RelaxExercise(id: 'M072', title: 'Deep Meditation', description: 'Silent observation of the breath. Final mental reset.', duration: 180, image: 'res_gym/M072.png'),
  ];
  // 4. Golden Vertical (Deep Alignment)
  static List<RelaxExercise> goldenVertical = [
    RelaxExercise(
      id: 'M073', 
      title: 'Golden Scan (Back)', 
      description: 'Lower your chin to your chest. Feel the elastic band stretching from your neck down to your heels.', 
      duration: 20, 
      image: 'res_gym/M073.png',
      purpose: 'Posterior chain elongation and spinal decompression.'
    ),
    RelaxExercise(
      id: 'M074', 
      title: 'Golden Front', 
      description: 'Lean your head back gently. Feel the front lines of your body tightening down to your big toes.', 
      duration: 20, 
      image: 'res_gym/M074.png',
      purpose: 'Anterior line lifting and posture correction.'
    ),
    RelaxExercise(
      id: 'M075', 
      title: 'Golden Side (Right)', 
      description: 'Right ear to shoulder. Stretch your left index finger to the floor. Feel the side line like a string.', 
      duration: 20, 
      image: 'res_gym/M075.png',
      purpose: 'Lateral neck stretching and shoulder release.'
    ),
    RelaxExercise(
      id: 'M076', 
      title: 'Golden Side (Left)', 
      description: 'Left ear to shoulder. Stretch your right index finger to the floor. Feel the tension in your right side.', 
      duration: 20, 
      image: 'res_gym/M076.png',
      purpose: 'Lateral neck stretching and shoulder release.'
    ),
    RelaxExercise(
      id: 'M077', 
      title: 'Golden Sculpt (Right)', 
      description: 'Tilt 45° back-right. Phase 1: Clench fist (neck lift). Phase 2: Open palm (flow to the right leg).', 
      duration: 40, 
      image: 'res_gym/M077.png',
      purpose: 'Deep facial contouring and fascia release.'
    ),
    RelaxExercise(
      id: 'M078', 
      title: 'Golden Sculpt (Left)', 
      description: 'Tilt 45° back-left. Phase 1: Clench fist (neck lift). Phase 2: Open palm (flow to the left leg).', 
      duration: 40, 
      image: 'res_gym/M078.png',
      purpose: 'Deep facial contouring and fascia release.'
    ),
    RelaxExercise(
      id: 'id:M079', 
      title: 'Golden Release (Right)', 
      description: 'Tilt 45° forward (nose to right armpit). Clench fist, then open palm to let the flow reach your heel.', 
      duration: 40, 
      image: 'res_gym/M079.png',
      purpose: 'Scapula release and posterior diagonal stretch.'
    ),
    RelaxExercise(
      id: 'M080', 
      title: 'Golden Release (Left)', 
      description: 'Tilt 45° forward (nose to left armpit). Clench fist, then open palm to let the flow reach your heel.', 
      duration: 40, 
      image: 'res_gym/M080.png',
      purpose: 'Scapula release and posterior diagonal stretch.'
    ),
    RelaxExercise(
      id: 'M081', 
      title: 'Golden Harmony (Right)', 
      description: 'Place your ear on the right shoulder. Perform 3 slow 360° rolls. Feel the head weight.', 
      duration: 30, 
      image: 'res_gym/M081.png',
      purpose: 'Neck stabilization and harmonization.'
    ),
    RelaxExercise(
      id: 'M082', 
      title: 'Golden Harmony (Left)', 
      description: 'Place your ear on the left shoulder. Perform 3 slow 360° rolls in the opposite direction.', 
      duration: 30, 
      image: 'res_gym/M082.png',
      purpose: 'Neck stabilization and harmonization.'
    ),
    RelaxExercise(
      id: 'M083', 
      title: 'Golden Axis', 
      description: 'Turn your head slowly right and left (5 times). Listen to the spine adjusting to its natural axis.', 
      duration: 30, 
      image: 'res_gym/M083.png',
      purpose: 'Final spinal alignment and self-correction.'
    ),
  ];
  static List<RelaxExercise> taiChi = [
  RelaxExercise(
    id: 'tc_01',
    title: 'Commencing Form',
    image: 'res_gym/tc_01.png',
    duration: 60,
    kcal: 1.8,
    description: 'Slowly raise and lower your arms to synchronize breath and body.',
  ),
  RelaxExercise(
    id: 'tc_02',
    title: 'Parting Wild Horse\'s Mane',
    image: 'res_gym/tc_02.png',
    duration: 90,
    kcal: 2.5,
    description: 'A flowing movement where you step forward and "part" the energy with your hands.',
  ),
  RelaxExercise(
    id: 'tc_03',
    title: 'White Crane Spreads Wings',
    image: 'res_gym/tc_03.png',
    duration: 60,
    kcal: 1.8,
    description: 'Balance on one leg while gracefully extending your arms like wings.',
  ),
  RelaxExercise(
    id: 'tc_04',
    title: 'Brush Knee and Step',
    image: 'res_gym/tc_04.png',
    duration: 90,
    kcal: 2.5,
    description: 'Circular hand movements combined with steady steps for coordination.',
  ),
  RelaxExercise(
    id: 'tc_05',
    title: 'Cloud Hands',
    image: 'res_gym/tc_05.png',
    duration: 120,
    kcal: 3.2,
    description: 'The most famous movement: hands move like clouds passing in the sky.',
  ),
  RelaxExercise(
    id: 'tc_06',
    title: 'Single Whip',
    image: 'res_gym/tc_06.png',
    duration: 60,
    kcal: 1.8,
    description: 'A powerful posture focusing on extension and internal strength.',
  ),
  RelaxExercise(
    id: 'tc_07',
    title: 'Grasp the Bird\'s Tail',
    image: 'res_gym/tc_07.png',
    duration: 90,
    kcal: 2.5,
    description: 'A sequence of four movements: ward off, roll back, press, and push.',
  ),
  RelaxExercise(
    id: 'tc_08',
    title: 'Golden Rooster Stands on One Leg',
    image: 'res_gym/tc_08.png',
    duration: 60,
    kcal: 1.8,
    description: 'Test your balance by raising one knee and the opposite hand.',
  ),
  RelaxExercise(
    id: 'tc_09',
    title: 'Fair Lady Works at Shuttles',
    image: 'res_gym/tc_09.png',
    duration: 90,
    kcal: 2.5,
    description: 'Graceful diagonal movements focusing on agility and focus.',
  ),
  RelaxExercise(
    id: 'tc_10',
    title: 'Closing Form',
    image: 'res_gym/tc_10.png',
    duration: 60,
    kcal: 1.8,
    description: 'Gather your energy and return to a calm, centered state.',
  ),
];
}