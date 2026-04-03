import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:smart_body_life/data/activity_timer_screen.dart';
import 'package:smart_body_life/data/relax_data.dart';
import 'package:smart_body_life/data/training_data.dart';
import 'package:smart_body_life/data/exercise_library_data.dart';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/screens/artifact_constructor.dart';
//import 'package:smart_body_life/providers/workout_provider.dart';
import 'package:smart_body_life/screens/barbell_calc_screen.dart';
import 'package:smart_body_life/screens/dumbbell_calc_screen.dart';
//import 'package:smart_body_life/screens/active_workout_screen.dart';
import 'package:smart_body_life/screens/evolution_session_screen.dart';
//import 'package:smart_body_life/screens/live_action_timer_screen.dart';
import 'package:smart_body_life/screens/notebook_screen.dart';
import 'package:smart_body_life/screens/outdoor_list_screen.dart';
import 'package:smart_body_life/screens/protocol_session_screen.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/screens/yoga_player_screen.dart';
import 'package:smart_body_life/utils/translation_service.dart' as TranslationService;
import 'package:smart_body_life/widgets/smart_banner.dart';
import 'weight_loss_plans_screen.dart';
import 'muscle_gain_plans_screen.dart';
import 'package:smart_body_life/screens/my_artifacts_screen.dart';
//import 'package:smart_body_life/screens/live_action_timer_screen.dart';

// --- ДАННЫЕ (kMachineData) ---
const Map<String, List<Map<String, String>>> kMachineData = {
  'CARDIO MACHINES': [
    {'title': 'Elliptical Walking', 'image': 'res_gym/M003.png', 'level': 'BEG', 'kcal': '7.0'},
    {'title': 'Running / Walking', 'image': 'res_gym/M007.png', 'level': 'BEG', 'kcal': '10.0'},
    {'title': 'Stair Climbing', 'image': 'res_gym/M009.png', 'level': 'MED', 'kcal': '9.0'},
    {'title': 'Cycling', 'image': 'res_gym/M014.png', 'level': 'BEG', 'kcal': '8.0'},
    {'title': 'Row Run', 'image': 'res_gym/M016.png', 'level': 'MED', 'kcal': '7.5'},
  ],
  'STRENGTH MACHINES': [
    {'title': 'Leg Extension', 'image': 'res_gym/M001.png', 'level': 'BEG', 'kcal': '4.0'},
    {'title': 'Abs Machine', 'image': 'res_gym/M002.png', 'level': 'BEG', 'kcal': '3.5'},
    {'title': 'Glute Kickback', 'image': 'res_gym/M004.png', 'level': 'BEG', 'kcal': '4.0'},
    {'title': 'Pec Deck Fly / Rear Delt', 'image': 'res_gym/M005.png', 'level': 'MED', 'kcal': '4.5'},
    {'title': 'Torso Rotation', 'image': 'res_gym/M008.png', 'level': 'MED', 'kcal': '3.0'},
    {'title': 'Cable Work', 'image': 'res_gym/M006.png', 'level': 'MED', 'kcal': '4.0'},
    {'title': 'Hip Adductor/Abductor', 'image': 'res_gym/M010.png', 'level': 'BEG', 'kcal': '3.5'},
    {'title': 'Seated Leg Curl', 'image': 'res_gym/M011.png', 'level': 'BEG', 'kcal': '4.0'},
    {'title': 'Lying Leg Curl', 'image': 'res_gym/M012.png', 'level': 'MED', 'kcal': '4.5'},
    {'title': 'Radial Glute Thrust', 'image': 'res_gym/M015.png', 'level': 'MED', 'kcal': '5.0'},
    {'title': 'Lat Pulldown/Low Row', 'image': 'res_gym/M017.png', 'level': 'BEG', 'kcal': '4.5'},
    {'title': 'Seated Chest Press', 'image': 'res_gym/M018.png', 'level': 'BEG', 'kcal': '4.0'},
    {'title': 'Leg Press', 'image': 'res_gym/M019.png', 'level': 'MED', 'kcal': '5.5'},
    {'title': 'Lat Pulldown', 'image': 'res_gym/M020.png', 'level': 'MED', 'kcal': '4.5'},
    {'title': 'Incline Chest Press', 'image': 'res_gym/M021.png', 'level': 'MED', 'kcal': '4.5'},
    {'title': 'Seated Calf Raise', 'image': 'res_gym/M022.png', 'level': 'MED', 'kcal': '3.0'},
    {'title': 'Overhead Press', 'image': 'res_gym/M023.png', 'level': 'MED', 'kcal': '4.5'},
    {'title': 'Independent Shoulder Press', 'image': 'res_gym/M024.png', 'level': 'ADV', 'kcal': '5.0'},
    {'title': 'Seated Chest Press (Lever)', 'image': 'res_gym/M025.png', 'level': 'ADV', 'kcal': '5.0'},
  ],
  'FREE WEIGHTS': [
    {'title': 'Dumbbells (General)', 'image': 'res_gym/M026.png', 'level': 'ADV', 'kcal': '5.0'},
    {'title': 'Barbell (General)', 'image': 'res_gym/M027.png', 'level': 'BEG', 'kcal': '6.0'},
    {'title': 'Kettlebell (General)', 'image': 'res_gym/M030.png', 'level': 'ADV', 'kcal': '6.5'},
  ],
  'QUICK STRETCH': [
    {'title': 'Shoulder Rotations', 'image': 'res_gym/M031.png', 'level': 'BEG', 'kcal': '1.5'},
    {'title': 'Hamstring Stretch', 'image': 'res_gym/M032.png', 'level': 'BEG', 'kcal': '1.5'},
    {'title': 'Quad Stretch', 'image': 'res_gym/M033.png', 'level': 'ADV', 'kcal': '1.5'},
    {'title': 'Stability Ball (General)', 'image': 'res_gym/M028.png', 'level': 'BEG', 'kcal': '2.5'},
    {'title': 'Resistance Band', 'image': 'res_gym/M029.png', 'level': 'MED', 'kcal': '3.0'},
  ],
  'OUTDOOR WORKOUTS': [
    {'title': 'Power Walking', 'image': 'res_gym/M035.png', 'level': 'BEG', 'kcal': '6.0'},
    {'title': 'Nordic Walking', 'image': 'res_gym/M036.png', 'level': 'MED', 'kcal': '7.5'},
    {'title': 'Outdoor Cycling', 'image': 'res_gym/M037.png', 'level': 'BEG', 'kcal': '8.0'},
    {'title': 'E-Scooter Ride', 'image': 'res_gym/M038.png', 'level': 'BEG', 'kcal': '2.5'},
  ],
  'WATER WORKOUTS': [
    {'title': 'Recreational Swimming', 'image': 'res_gym/M039.png', 'level': 'BEG', 'kcal': '7.0'},
    {'title': 'Active Laps (Cardio)', 'image': 'res_gym/M040.png', 'level': 'ADV', 'kcal': '10.0'},
    {'title': 'Aqua Balance', 'image': 'res_gym/M041.png', 'level': 'BEG', 'kcal': '5.5'},
  ],
};

class GymScreen extends StatefulWidget {
  const GymScreen({super.key});

  @override
  State<GymScreen> createState() => _GymScreenState();
}

class _GymScreenState extends State<GymScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Создаем контроллер на 3 вкладки
    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
    
    // Сразу передаем его в провайдер, чтобы Блокнот мог им управлять
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ActiveSessionProvider>().setTabController(_tabController);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      body: SafeArea(
        child: Column(
          children: [
            // --- ДОБАВЛЯЕМ ВЕРХНЮЮ ПАНЕЛЬ С КНОПКОЙ НАЗАД ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37), size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(), // Толкает всё остальное, чтобы сохранить центровку
                ],
              ),
            ),
            // Оставляем твой заголовок, но чуть уменьшим отступ сверху
            const Text(
              "WORKOUT ZONE",
              style: TextStyle(
                color: Color(0xFFFFAB00),
                fontSize: 24,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.2,
                shadows: [Shadow(blurRadius: 10, color: Colors.orange)],
              ),
            ),
            const SizedBox(height: 10),
            const SmartOrangeBanner(),
            const SizedBox(height: 10),
            Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  decoration: BoxDecoration(
    color: Colors.white.withOpacity(0.05),
    borderRadius: BorderRadius.circular(10),
  ),
  child: TabBar(
    controller: _tabController, // ТВОЙ КОНТРОЛЛЕР НА МЕСТЕ
    // Делаем индикатор объемным и золотым
    indicator: BoxDecoration(
  borderRadius: BorderRadius.circular(10),
  // Используем более насыщенные цвета для яркости
  gradient: const LinearGradient(
    colors: [
      Color(0xFFFFD600), // Яркое золото сверху
      Color(0xFFFFAB00), // Глубокое золото снизу
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  boxShadow: [
    BoxShadow(
      color: const Color(0xFFFFAB00).withOpacity(0.4),
      blurRadius: 4, // Уменьшили с 8 до 4, чтобы убрать "размытость"
      spreadRadius: 1, // Добавили плотности
      offset: const Offset(0, 1),
    ),
  ],
),
    // Когда вкладка выбрана — текст черный (на золоте так лучше читается)
    labelColor: Colors.black, 
    labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
    // Когда не выбрана — текст серый
    unselectedLabelColor: Colors.white38,
    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
    tabs: const [
      Tab(text: "EQUIPMENT"),
      Tab(text: "WORKOUTS"),
      Tab(text: "BUILD"),
    ],
  ),
),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController, // ИСПОЛЬЗУЕМ НАШ КОНТРОЛЛЕР
                children: const [
                  _EquipmentGrid(),
                  _WorkoutsGrid(),
                  _BuildGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BeautifulSquareTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isGold;

  const BeautifulSquareTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isGold = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isGold
                ? [
                    const Color(0xFFC79E31), // СОСТАРЕННОЕ, ТЕМНОЕ ЗОЛОТО сверху
                    const Color(0xFF8B6B1A), // ГЛУБОКИЙ, ЯНТАРНЫЙ ОТЛИВ снизу
                  ]
                : [
                    const Color(0xFF263238), // МАТОВЫЙ СЕРЫЙ
                    const Color(0xFF000000), // ЧЕРНЫЙ
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          // Приглушенная обводка в цвет металла
          border: Border.all(
              color: isGold ? const Color(0xFF8B6B1A) : Colors.white12, width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                // Темный акцент внутри
                color: isGold ? const Color(0xFF3E2723) : const Color(0xFFFFAB00),
                size: 32),
            const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                // Темный акцент внутри
                color: isGold ? const Color(0xFF3E2723) : Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentGrid extends StatelessWidget {
  const _EquipmentGrid();
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        BeautifulSquareTile(
            title: "STRENGTH",
            icon: Icons.fitness_center,
            onTap: () => _go(context, "STRENGTH MACHINES")),
        BeautifulSquareTile(
            title: "CARDIO",
            icon: Icons.directions_run,
            onTap: () => _go(context, "CARDIO MACHINES")),
        BeautifulSquareTile(
            title: "FREE WEIGHTS",
            icon: Icons.handyman,
            onTap: () => _go(context, "FREE WEIGHTS")),
        BeautifulSquareTile(
            title: "CALCULATORS",
            icon: Icons.calculate,
            onTap: () => _showCalcPicker(context)),
        // 1. Плитка для твоих личных разработок
        BeautifulSquareTile(
          title: "MY ARSENAL", 
          icon: Icons.biotech, 
          onTap: () {
            // ВОЗВРАЩАЕМ ПУТЬ НА СКЛАД: 
            // Чтобы видеть готовые тренажеры и нажать там "+"
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyArtifactsScreen()),
            );
          },
        ),
 // <-- Закрыли плитку Арсенала (обязательно ставим запятую!)

        // 2. Плитка Эволюции (будущие рекорды)
        BeautifulSquareTile(
  title: "FUTURE TECH", 
  icon: Icons.lock_outline, 
  onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        "SYSTEM ACCESS RESTRICTED: NEW MODULE UNDER DEVELOPMENT",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurple, // Стандартный системный цвет без ошибок
      duration: Duration(seconds: 2),
    ),
  );
},
),//-- Закрыли плитку Эволюции
      ], // <-- Это закрывает список детей GridView (children: [])
    ); // <-- Это закрывает сам GridView.count(
  } // <-- Это закрывает метод build

  void _go(BuildContext context, String cat) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ExerciseListScreen(categoryName: cat)));

  void _showCalcPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF111111),
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                    leading: const Icon(Icons.fitness_center, color: Color(0xFFFFAB00)),
                    title: const Text("DUMBBELL CALC"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const DumbbellCalcScreen()))),
                ListTile(
                    leading: const Icon(Icons.straighten, color: Color(0xFFFFAB00)),
                    title: const Text("BARBELL CALC"),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (c) => const BarbellCalcScreen()))),
              ],
            ));
  }
}

class _WorkoutsGrid extends StatelessWidget {
  const _WorkoutsGrid();
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        BeautifulSquareTile(
            title: "LOSE WEIGHT",
            icon: Icons.trending_down,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const WeightLossPlansScreen()))),
        BeautifulSquareTile(
            title: "GAIN MUSCLE",
            icon: Icons.trending_up,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => const MuscleGainPlansScreen()))),
                    
// --- 5. ТВОЙ НОВЫЙ БЛОК: OUTDOOR ---
        BeautifulSquareTile(
          title: "OUTDOOR",
          icon: Icons.terrain,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OutdoorLabList(category: "OUTDOOR"),
              ),
            );
          }, // <-- Закрыли функцию
        ),   // <-- Закрыли плитку

        // --- 6. ТВОЙ НОВЫЙ БЛОК: WATER ---
        BeautifulSquareTile(
          title: "WATER",
          icon: Icons.waves,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OutdoorLabList(category: "WATER"),
              ),
            );
          }, // <-- Закрыли функцию
        ),   // <-- Закрыли плитку
        BeautifulSquareTile(
            title: "YOGA",
            icon: Icons.self_improvement,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (c) => const YogaProgramsScreen()))),
        BeautifulSquareTile(
            title: "TAI-CHI",
            icon: Icons.blur_on,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => YogaTimerPlayerScreen(
                          exercises: RelaxData.taiChi, programName: "TAI CHI")));
            }),
      ],
    );
  }

 void _go(BuildContext context, String cat) => Navigator.push(context,
      MaterialPageRoute(builder: (context) => ExerciseListScreen(categoryName: cat)));
}

class _BuildGrid extends StatelessWidget {
  const _BuildGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.1,
      children: [
        // 1. НАСТОЯЩЕЕ ЗОЛОТО - Создать тренировку
        BeautifulSquareTile(
          isGold: true,
          title: "CREATE WORKOUT",
          icon: Icons.add_circle_outline,
          onTap: () {
            final session = context.read<ActiveSessionProvider>();
            if (session.currentRunningWorkout == null) {
              session.startLiveWorkout();
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotebookScreen(),
                settings: const RouteSettings(name: 'NotebookScreen'),
              ),
            );
          },
        ),

        // 2. ЧЕРНАЯ МЕТАЛЛИЧЕСКАЯ - Мои тренировки
        BeautifulSquareTile(
          title: "MY WORKOUTS",
          icon: Icons.folder_copy,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProtocolSessionScreen()),
            );
          },
        ),

        // 3. ГЛУБОКИЙ ФИОЛЕТОВЫЙ - Лаборатория
        _BeautifulPurpleTile(
          title: "LABORATORY",
          icon: Icons.biotech,
          onTap: () {
  // ПУТЬ ДЛЯ СОЗДАНИЯ: Переходим в Конструктор (Лабораторию)
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ArtifactConstructor()),
  );
},
        ),

        // 4. ЧЕРНАЯ МЕТАЛЛИЧЕСКАЯ - Эволюция
        BeautifulSquareTile(
          title: "MY EVOLUTION",
          icon: Icons.insights_rounded,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EvolutionSessionScreen()),
            );
          },
        ),
      ],
    );
  }
}

// Вспомогательный виджет для ГЛУБОКОЙ ФИОЛЕТОВОЙ металлической кнопки
class _BeautifulPurpleTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _BeautifulPurpleTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF20133A), // Очень темный, почти черный
              Color(0xFF0F0820), // Глубокий чернильный
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          // Легкая фиолетовая обводка для объема
          border: Border.all(color: const Color(0xFF6A1B9A).withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF6A1B9A), size: 32),
            const SizedBox(height: 12),
            Text(
              title.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ExerciseListScreen extends StatelessWidget {
  final String categoryName;
  const ExerciseListScreen({super.key, required this.categoryName});

  void _showInfoBottomSheet(BuildContext context, Map<String, String> data) {
    final String rawPath = data['image'] ?? "";
    final String cleanCode = rawPath.split('/').last.split('.').first;
    
    final fullExercise = TrainingData.getAllExercises().firstWhere(
      (e) => e.machineCode == cleanCode,
      orElse: () => TrainingData.getAllExercises().first,
    );

    String desc = fullExercise.description ?? "No info";
    String setup = fullExercise.setup ?? "No setup";
    String inst = fullExercise.instructions ?? "No technique";
    String safe = fullExercise.safety ?? "No safety";
    bool isTranslating = false;
    String currentActiveLang = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF05100A),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(
                    child: Text(fullExercise.title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                  ),
                  isTranslating
                      ? const SizedBox(width: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFAB00))))
                      : IconButton(
                          icon: const Icon(Icons.language, color: Color(0xFFFFAB00)),
                          onPressed: () async {
                            final lang = await _showLanguagePicker(context);
                            if (lang != null) {
                              setModalState(() {
                                isTranslating = true;
                                currentActiveLang = lang;
                                desc = "Loading..."; setup = "Loading..."; inst = "Loading..."; safe = "Loading...";
                              });

                              try {
                                final tDesc = await TranslationService.TranslationService.translateText(fullExercise.description ?? "", lang);
                                final tSetup = await TranslationService.TranslationService.translateText(fullExercise.setup ?? "", lang);
                                final tInst = await TranslationService.TranslationService.translateText(fullExercise.instructions ?? "", lang);
                                final tSafe = await TranslationService.TranslationService.translateText(fullExercise.safety ?? "", lang);

                                if (currentActiveLang == lang) {
                                  setModalState(() {
                                    desc = tDesc; setup = tSetup; inst = tInst; safe = tSafe;
                                    isTranslating = false;
                                  });
                                }
                              } catch (e) {
                                setModalState(() => isTranslating = false);
                              }
                            }
                          },
                        ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildInfoRow(Icons.info_outline, "INFO", desc),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.build_circle_outlined, "BUILD", setup),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.fitness_center, "TECHNIQUE", inst),
                    const SizedBox(height: 25),
                    _buildInfoRow(Icons.security, "SAFETY", safe),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFAB00), width: 1)),
          child: Icon(icon, color: const Color(0xFFFFAB00), size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(text, style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }

  void _showWeightCalculator(BuildContext context, Map<String, String> data) {
    final String title = (data['title'] ?? "").toUpperCase();
    if (title.contains("BARBELL")) {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const BarbellCalcScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (c) => const DumbbellCalcScreen()));
    }
  }

  bool _isIron(String title) {
    final t = title.toUpperCase();
    return t.contains("BARBELL") || t.contains("DUMBBELL") || t.contains("KETTLEBELL");
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>>? exercises = kMachineData[categoryName];
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFF05100A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: exercises == null || exercises.isEmpty
          ? const Center(child: Text('No machines found', style: TextStyle(color: Colors.grey)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 15),
              itemBuilder: (context, index) {
                final data = exercises[index];
                final String rawPath = data['image'] ?? "";
                final String cleanCode = rawPath.split('/').last.split('.').first;
                return Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111111),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withAlpha(50)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80, height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                          image: DecorationImage(image: AssetImage(rawPath), fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data['title'] ?? "", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(" Level: ${data['level']}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isIron(data['title'] ?? ""))
                            GestureDetector(
                              onTap: () => _showWeightCalculator(context, data),
                              child: Container(
                                width: 36, height: 36, margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(color: Colors.white.withAlpha(20), shape: BoxShape.circle),
                                child: const Icon(Icons.calculate_outlined, color: Colors.white70, size: 20),
                              ),
                            ),
                          GestureDetector(
                            onTap: () => _showInfoBottomSheet(context, data),
                            child: Container(
                              width: 36, height: 36, margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFAB00), width: 1.0)),
                              child: const Icon(Icons.info_outline, color: Color(0xFFFFAB00), size: 20),
                            ),
                          ),
                          Consumer<ActiveSessionProvider>(
  builder: (context, activeSession, child) {
    final String title = data['title'] ?? "";
    
    // ПРОВЕРКА: Есть ли этот тренажер ПРЯМО СЕЙЧАС в активном блокноте?
    final bool isInNotebook = activeSession.currentRunningWorkout?.exercises
        .any((e) => e.title == title) ?? false;

    // Иконка будет галочкой только если он реально в блокноте
    final bool isAdded = isInNotebook || 
                         activeSession.isInEvolution(title) || 
                         activeSession.isInProtocol(title);

    return InkWell(
      onTap: () {
        final exerciseObj = Exercise(
          id: cleanCode, title: title, image: rawPath, machineCode: cleanCode, 
          targetMuscles: categoryName, kcal: data['kcal'] ?? '0', sets: 0, 
          reps: '0', isCompleted: false, elapsedSeconds: 0, restTime: '0s', 
          category: categoryName,
        );

        if (activeSession.currentMode == ActiveMode.running) {
          if (!isInNotebook) {
            // ВЫЗЫВАЕМ ТАБЛИЧКУ (ПОДТВЕРЖДЕНИЕ)
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A1A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFFFAB00), width: 0.5),
                ),
                title: const Text("ADD TO SESSION?", 
                  style: TextStyle(color: Color(0xFFFFAB00), fontSize: 16, fontWeight: FontWeight.bold)),
                content: Text("Add $title to your active notebook?", 
                  style: const TextStyle(color: Colors.white70)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context), 
                    child: const Text("CANCEL", style: TextStyle(color: Colors.white24))
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFAB00)),
                    onPressed: () {
                      activeSession.addToRunningWorkout(exerciseObj);
                      activeSession.jumpToBuild();
                      activeSession.refresh();
                      Navigator.pop(context); // Закрыли диалог
                      
                      // Возвращаемся в Блокнот
                      Navigator.of(context).popUntil((route) => 
                        route.settings.name == 'NotebookScreen' || route.isFirst);
                    },
                    child: const Text("ADD", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          } else {
            // Если уже добавлен - при нажатии просто удаляем из списка
            activeSession.addToRunningWorkout(exerciseObj);
          }
        } else if (activeSession.currentMode == ActiveMode.evolution) {
          activeSession.toggleEvolution(exerciseObj);
        } else if (activeSession.currentMode == ActiveMode.protocol) {
          activeSession.toggleProtocol(exerciseObj);
        }
      },
      child: Container(
        width: 40, height: 40, margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: isAdded ? Colors.white.withAlpha(25) : const Color(0xFFFFAB00), 
          shape: BoxShape.circle
        ),
        child: Icon(
          isAdded ? Icons.check : Icons.add, 
          color: isAdded ? Colors.white70 : Colors.black
        ),
      ),
    );
  },
),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class YogaProgramsScreen extends StatelessWidget {
  const YogaProgramsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        title: const Text("YOGA & STRETCH", style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFFFAB00))),
        backgroundColor: const Color(0xFF05100A),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProgramCard(context, title: "ENERGY FLOW", subtitle: "12 exercises • 15 min", icon: Icons.wb_sunny_outlined, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => YogaExerciseListScreen(programName: "ENERGY FLOW", exercises: RelaxData.energyFlow)))),
          const SizedBox(height: 15),
          _buildProgramCard(context, title: "DEEP RECOVERY", subtitle: "12 exercises • 30 min", icon: Icons.self_improvement, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => YogaExerciseListScreen(programName: "DEEP RECOVERY", exercises: RelaxData.deepRecovery)))),
          const SizedBox(height: 15),
          _buildProgramCard(context, title: "ZEN BREATH", subtitle: "7 exercises • 10 min", icon: Icons.air, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => YogaExerciseListScreen(programName: "ZEN BREATH", exercises: RelaxData.zenBreath)))),
          const SizedBox(height: 15),
          _buildProgramCard(context, title: "GOLDEN VERTICAL", subtitle: "11 exercises • 10 min", icon: Icons.workspace_premium, isSpecial: true, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => YogaExerciseListScreen(programName: "GOLDEN VERTICAL", exercises: RelaxData.goldenVertical)))),
        ],
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap, bool isSpecial = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: isSpecial ? [const Color(0xFFB87700), const Color(0xFF000000)] : [const Color(0xFF111111), const Color(0xFF000000)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSpecial ? const Color(0xFFFFAB00) : Colors.white.withAlpha(30), width: isSpecial ? 1.5 : 1),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20), Icon(icon, color: const Color(0xFFFFAB00), size: 40), const SizedBox(width: 20),
            Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)), Text(subtitle, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 13))])),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24), const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class YogaExerciseListScreen extends StatelessWidget {
  final String programName;
  final List<RelaxExercise> exercises;
  const YogaExerciseListScreen({super.key, required this.programName, required this.exercises});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        title: Text(programName, style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFFFFAB00))),
        backgroundColor: const Color(0xFF05100A),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ex = exercises[index];
                return Container(
                  height: 80,
                  decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white.withAlpha(30))),
                  child: Row(
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(color: const Color(0xFF111111), borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)), image: DecorationImage(image: AssetImage(ex.image), fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(ex.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)), Text("${ex.duration} sec", style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 12))])),
                      IconButton(onPressed: () => _showInfoBottomSheet(context, ex.id), icon: const Icon(Icons.info_outline, color: Color(0xFFFFAB00), size: 24)),
                      const SizedBox(width: 5),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(width: double.infinity, height: 55, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFAB00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => YogaTimerPlayerScreen(exercises: exercises, programName: programName))), child: const Text("START SESSION", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))),
          ),
        ],
      ),
    );
  }

  void _showInfoBottomSheet(BuildContext context, String exerciseId) {
    ExerciseDescription? found;
    final allLists = [LibraryData.energyFlow, LibraryData.deepRecovery, LibraryData.zenBreath, LibraryData.goldenVertical, LibraryData.taiChiLibrary];
    for (var list in allLists) {
      try { found = list.firstWhere((element) => element.id == exerciseId); break; } catch (_) { continue; }
    }
    if (found == null) return;
    final libData = found;

    String d = libData.info; String s = libData.build; String t = libData.technique; String sf = libData.safety;
    bool loading = false; String activeLang = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF05100A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Row(
                children: [
                  const SizedBox(width: 40),
                  Expanded(child: Text(libData.title.toUpperCase(), textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic))),
                  loading
                      ? const SizedBox(width: 40, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFAB00))))
                      : IconButton(
                          icon: const Icon(Icons.language, color: Color(0xFFFFAB00), size: 28),
                          onPressed: () async {
                            final lang = await _showLanguagePicker(context);
                            if (lang != null) {
                              setModalState(() { loading = true; activeLang = lang; d = "Translating..."; s = "Translating..."; t = "Translating..."; sf = "Translating..."; });
                              try {
                                final rD = await TranslationService.TranslationService.translateText(libData.info, lang);
                                final rS = await TranslationService.TranslationService.translateText(libData.build, lang);
                                final rT = await TranslationService.TranslationService.translateText(libData.technique, lang);
                                final rSf = await TranslationService.TranslationService.translateText(libData.safety, lang);
                                if (activeLang == lang) { setModalState(() { d = rD; s = rS; t = rT; sf = rSf; loading = false; }); }
                              } catch (e) { if (activeLang == lang) setModalState(() => loading = false); }
                            }
                          },
                        ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: [
                    _buildLibraryRow(Icons.info_outline, "INFO", d), const SizedBox(height: 25),
                    _buildLibraryRow(Icons.auto_awesome, "BUILD", s), const SizedBox(height: 25),
                    _buildLibraryRow(Icons.fitness_center, "TECHNIQUE", t), const SizedBox(height: 25),
                    _buildLibraryRow(Icons.security, "SAFETY", sf),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFFAB00), width: 1.5)),
          child: Icon(icon, color: const Color(0xFFFFAB00), size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 13, fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.4))])),
      ],
    );
  }
}

// --- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ В САМОМ НИЗУ (ГЛОБАЛЬНО) ---
Future<String?> _showLanguagePicker(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF111111),
      title: const Text("CHOOSE LANGUAGE", style: TextStyle(color: Color(0xFFFFAB00))),
      content: Column(mainAxisSize: MainAxisSize.min, children: [_langOption(context, "Українська", "uk"), _langOption(context, "Deutsch", "de"), _langOption(context, "Français", "fr"), _langOption(context, "Español", "es")]),
    ),
  );
}

Widget _langOption(BuildContext context, String name, String code) {
  return ListTile(title: Text(name, style: const TextStyle(color: Colors.white)), onTap: () => Navigator.pop(context, code));
}