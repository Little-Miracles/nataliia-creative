import '../screens/workout_data_models.dart';

// ==========================================
// ЛАБОРАТОРИЯ ТРЕНАЖЕРОВ (M001 - M033)
// ==========================================

// --- НОГИ (LEGS) ---
final exM001 = Exercise(
  title: 'Leg Extension',
  category: 'machine',
  machineCode: 'M001',
  targetMuscles: 'Quadriceps',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M001.png',
  description: '1. Align knees with pivot. 2. Extend legs. 3. Squeeze at top.\nTIP: Adjust shin pad just above ankles. Avoid locking knees forcefully.',
);

final exM004 = Exercise(
  title: 'Rear Leg Extension',
  category: 'machine',
  machineCode: 'M004',
  targetMuscles: 'Glutes',
  sets: 3, reps: '12-15', restTime: '45s',
  image: 'res_gym/M004.png',
  description: '1. Push pad straight backward. 2. Squeeze glute at peak.\nTIP: Do not arch lower back. Keep torso stable.',
);

final exM010 = Exercise(
  title: 'Hip Adductor/Abductor',
  category: 'machine',
  machineCode: 'M010',
  targetMuscles: 'Inner/Outer Thighs',
  sets: 3, reps: '15-20', restTime: '45s',
  image: 'res_gym/M010.png',
  description: 'Adductor: Squeeze inward. Abductor: Push outward.\nTIP: Focus on slow, controlled contractions.',
);

final exM011 = Exercise(
  title: 'Seated Leg Curl',
  category: 'machine',
  machineCode: 'M011',
  targetMuscles: 'Hamstrings',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M011.png',
  description: '1. Align knees with pivot. 2. Curl weight under seat.\nTIP: Keep hips pressed firmly against the seat pad.',
);

final exM012 = Exercise(
  title: 'Lying Leg Curl',
  category: 'machine',
  machineCode: 'M012',
  targetMuscles: 'Hamstrings',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M012.png',
  description: '1. Curl weight towards glutes. 2. Squeeze at peak.\nTIP: Avoid lifting the pelvis while curling.',
);

final exM019 = Exercise(
  title: 'Leg Press',
  category: 'machine',
  machineCode: 'M019',
  targetMuscles: 'Quads/Glutes',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M019.png',
  description: '1. Lower platform to 90 degrees. 2. Push up with heels.\nTIP: Never lock knees at the top.',
);

final exM022 = Exercise(
  title: 'Seated Calf Raise',
  category: 'machine',
  machineCode: 'M022',
  targetMuscles: 'Calves (Soleus)',
  sets: 3, reps: '15-20', restTime: '45s',
  image: 'res_gym/M022.png',
  description: '1. Lower heels for stretch. 2. Press up powerfully.\nTIP: Do not bounce; use a controlled range of motion.',
);

// --- ГРУДЬ (CHEST) ---
final exM005 = Exercise(
  title: 'Pec Deck Fly',
  category: 'machine',
  machineCode: 'M005',
  targetMuscles: 'Chest/Rear Delts',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M005.png',
  description: 'Fly: Bring arms together in front. Rear: Pull arms back.\nTIP: Maintain control in the negative (return) phase.',
);

final exM018 = Exercise(
  title: 'Seated Chest Press',
  category: 'machine',
  machineCode: 'M018',
  targetMuscles: 'Chest/Shoulders',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M018.png',
  // 👇 ИСПОЛЬЗУЕМ СУЩЕСТВУЮЩЕЕ ПОЛЕ PARAMS
  params: {'alternatives': 'M026,M027'},
  description: '1. Align handles with middle chest. 2. Push forward.\nTIP: Keep shoulders down and retracted.',
);

final exM021 = Exercise(
  title: 'Incline Chest Press',
  category: 'machine',
  machineCode: 'M021',
  targetMuscles: 'Upper Chest',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M021.png',
  description: '1. Press forward and up. 2. Squeeze chest at top.\nTIP: Align handles with the top third of your chest.',
);

final exM025 = Exercise(
  title: 'Chest Press (Lever)',
  category: 'machine',
  machineCode: 'M025',
  targetMuscles: 'Chest/Triceps',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M025.png',
  description: '1. Push levers forward. 2. Squeeze muscles.\nTIP: Keep shoulders pressed back against the pad.',
);

// --- СПИНА (BACK) ---
final exM017 = Exercise(
  title: 'Lat Pulldown/Low Row',
  category: 'machine',
  machineCode: 'M017',
  targetMuscles: 'Lats/Mid-Back',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M017.png',
  description: 'Pulldown: Pull to chest. Row: Pull to abdomen.\nTIP: Ensure correct cable line is selected.',
);

final exM020 = Exercise(
  title: 'Lat Pulldown',
  category: 'machine',
  machineCode: 'M020',
  targetMuscles: 'Latissimus Dorsi',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M020.png',
  description: '1. Pull bar to upper chest. 2. Squeeze lats.\nTIP: Avoid swinging; torso should remain stable.',
);

// --- ПЛЕЧИ (SHOULDERS) ---
final exM008 = Exercise(
  title: 'Torso Rotation',
  category: 'machine',
  machineCode: 'M008',
  targetMuscles: 'Obliques',
  sets: 3, reps: '15 reps', restTime: '45s',
  image: 'res_gym/M008.png',
  description: '1. Rotate torso against resistance. 2. Stop at comfort.\nTIP: Never use momentum. Rotation only from torso.',
);

final exM023 = Exercise(
  title: 'Overhead Press',
  category: 'machine',
  machineCode: 'M023',
  targetMuscles: 'Deltoids',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M023.png',
  description: '1. Press vertically straight up. 2. Lower under control.\nTIP: Keep core tight. Avoid arching lower back.',
);

final exM024 = Exercise(
  title: 'Independent Shoulder Press',
  category: 'machine',
  machineCode: 'M024',
  targetMuscles: 'Deltoids',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M024.png',
  description: '1. Push handles independently. 2. Maintain posture.\nTIP: Align handles with your ears.',
);

final exM031 = Exercise(
  title: 'Shoulder Rotations',
  category: 'gymnastics',
  machineCode: 'M031',
  targetMuscles: 'Rotator Cuff',
  sets: 1, reps: '20 reps', restTime: '0s',
  image: 'res_gym/M031.png',
  description: 'Rotate shoulders in large controlled circular motions.\nTIP: Move smoothly; avoid sharp movements.',
);

// --- РУКИ (ARMS) ---
final exM002 = Exercise(
  title: 'Abs Machine',
  category: 'machine',
  machineCode: 'M002',
  targetMuscles: 'Abs',
  sets: 3, reps: '20 reps', restTime: '45s',
  image: 'res_gym/M002.png',
  description: '1. Crunch abs, moving elbows to knees. 2. Exhale.\nTIP: Do not pull with your arms; use abs only.',
);

final exM006 = Exercise(
  title: 'Cable Work',
  category: 'machine',
  machineCode: 'M006',
  targetMuscles: 'Full Body',
  sets: 3, reps: '12-15', restTime: '45s',
  image: 'res_gym/M006.png',
  description: 'Pull or push movement slowly with tight core.\nTIP: Ensure body is stable to prevent imbalances.',
);

final exM013 = Exercise(
  title: 'Triceps Extension',
  category: 'machine',
  machineCode: 'M013',
  targetMuscles: 'Triceps',
  sets: 3, reps: '12-15', restTime: '45s',
  image: 'res_gym/M013.png',
  description: '1. Press down until arms are straight. 2. 90-deg bend back.\nTIP: Keep elbows close to the body; do not flare out.',
);

// --- КАРДИО (CARDIO) ---
final exM003 = Exercise(
  title: 'Elliptical Walking',
  category: 'cardio',
  machineCode: 'M003',
  targetMuscles: 'Full Body',
  sets: 1, reps: '15 min', restTime: '0s',
  image: 'res_gym/M003.png',
  description: '1. Maintain upright posture. 2. Pump pedals/handles.\nTIP: Avoid leaning on handles; let core do the work.',
);

final exM007 = Exercise(
  title: 'Treadmill',          // Используем title, а не name!
  category: 'cardio',
  machineCode: 'M007',         // Используем machineCode, а не id!
  targetMuscles: 'Legs, Core',
  sets: 1, reps: '10 min', restTime: '0s',
  image: 'res_gym/M007.png', // Добавляем путь, которого там не было
  description: 'Heart health and calorie burn. Natural running form. Attach safety clip.',
);

final exM009 = Exercise(
  title: 'Stair Climbing',
  category: 'cardio',
  machineCode: 'M009',
  targetMuscles: 'Glutes/Quads',
  sets: 1, reps: '10 min', restTime: '0s',
  image: 'res_gym/M009.png',
  description: 'Rhythmic climbing motion. Lean slightly forward.\nTIP: Drive through the heel for better glute activation.',
);

final exM014 = Exercise(
  title: 'Cycling',
  category: 'cardio',
  machineCode: 'M014',
  targetMuscles: 'Legs',
  sets: 1, reps: '15 min', restTime: '0s',
  image: 'res_gym/M014.png',
  description: 'Constant pedalling pace. Set seat height correctly.\nTIP: Knee should be slightly bent at the lowest point.',
);

final exM016 = Exercise(
  title: 'Row Run',
  category: 'cardio',
  machineCode: 'M016',
  targetMuscles: 'Full Body',
  sets: 1, reps: '10 min', restTime: '0s',
  image: 'res_gym/M016.png',
  description: '1. Push with legs. 2. Lean back. 3. Pull with arms.\nTIP: Legs initiate the movement, not arms.',
);

// --- ДОПОЛНИТЕЛЬНО / СВОБОДНЫЕ ВЕСА ---
final exM015 = Exercise(
  title: 'Radial Glute Thrust',
  category: 'machine',
  machineCode: 'M015',
  targetMuscles: 'Glutes',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M015.png',
  description: 'Push backward along motion path. Drive with heels.\nTIP: Perform slowly to increase glute activation.',
);

final exM026 = Exercise(
  title: 'Dumbbells (General)',
  category: 'freeWeight',
  machineCode: 'M026',
  targetMuscles: 'Full Body',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M026.png',
  description: 'Maintain strict control and stabilize the weight.\nTIP: Do not drop; always lift with control.',
);

final exM027 = Exercise(
  title: 'Barbell (General)',
  category: 'freeWeight',
  machineCode: 'M027',
  targetMuscles: 'Full Body',
  sets: 3, reps: '8-12', restTime: '90s',
  image: 'res_gym/M027.png',
  description: 'Heavy compound lifting for maximum strength.\nTIP: Always use collars/clips to secure plates.',
);

final exM028 = Exercise(
  title: 'Stability Ball',
  category: 'gymnastics',
  machineCode: 'M028',
  targetMuscles: 'Core',
  sets: 3, reps: '15 reps', restTime: '30s',
  image: 'res_gym/M028.png',
  description: 'Engage core to maintain balance on the ball.\nTIP: Ensure ball is inflated firm; use non-slip floor.',
);

final exM029 = Exercise(
  title: 'Resistance Band',
  category: 'gymnastics',
  machineCode: 'M029',
  targetMuscles: 'Full Body',
  sets: 3, reps: '15-20', restTime: '30s',
  image: 'res_gym/M029.png',
  description: 'Variable resistance for activation or isolation.\nTIP: Do not release suddenly to prevent injury.',
);

final exM030 = Exercise(
  title: 'Kettlebell (General)',
  category: 'freeWeight',
  machineCode: 'M030',
  targetMuscles: 'Glutes/Back',
  sets: 3, reps: '12-15', restTime: '60s',
  image: 'res_gym/M030.png',
  description: 'Hinge at hips, drive kettlebell to chest level.\nTIP: Master the hip hinge; do not pull with arms.',
);

// --- РАСТЯЖКА (STRETCH) ---
final exM032 = Exercise(
  title: 'Hamstring Stretch',
  category: 'gymnastics',
  machineCode: 'M032',
  targetMuscles: 'Hamstrings',
  sets: 1, reps: '30 sec', restTime: '0s',
  image: 'res_gym/M032.png',
  description: 'Lean forward from hips towards toes.\nTIP: Static stretch; do not bounce or pulse.',
);

final exM033 = Exercise(
  title: 'Quad Stretch',
  category: 'gymnastics',
  machineCode: 'M033',
  targetMuscles: 'Quadriceps',
  sets: 1, reps: '30 sec', restTime: '0s',
  image: 'res_gym/M033.png',
  description: 'Pull heel toward glutes standing on one leg.\nTIP: Keep knees aligned together during stretch.',
);