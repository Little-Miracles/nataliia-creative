import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/providers/evolution_manager.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/artifacts_screen.dart';
import 'package:video_player/video_player.dart';

class EvolutionSessionScreen extends StatefulWidget {
  const EvolutionSessionScreen({super.key});

  @override
  State<EvolutionSessionScreen> createState() => _EvolutionSessionScreenState();
}

class _EvolutionSessionScreenState extends State<EvolutionSessionScreen> {
  bool _isSelectingGender = false;
  int? _openedVaultIndex;
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;
  String? heartMessage;

  void _showConfirmGender(bool selectedMale) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1235),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("CONFIRMATION", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900)),
        content: Text(
          "Set ${selectedMale ? 'MALE' : 'FEMALE'} avatar as your primary profile?",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL", style: TextStyle(color: Colors.white30)),
          ),
          TextButton(
            onPressed: () {
              Provider.of<MetricsProvider>(context, listen: false).updateGender(selectedMale);
              setState(() => _isSelectingGender = false);
              Navigator.pop(context);
            },
            child: const Text("SAVE", style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchHealthData() async {
    // Вместо HealthFactory теперь просто Health()
    HealthFactory health = HealthFactory();
    final metrics = Provider.of<MetricsProvider>(context, listen: false);
    
    // Типы данных теперь пишутся через HealthDataType.STEPS (тут почти так же)
    final types = [HealthDataType.STEPS];
    
    // ВНИМАНИЕ: Здесь небольшое изменение в названии доступа
    final permissions = [HealthDataAccess.READ];

    try {
      bool requested = await health.requestAuthorization(types, permissions: permissions);
      if (requested) {
        DateTime now = DateTime.now();
        DateTime startOfDay = DateTime(now.year, now.month, now.day);
        int? steps = await health.getTotalStepsInInterval(startOfDay, now);
        if (steps != null) {
          metrics.stepsToday = steps;
          int activeMins = (steps / 100).toInt();
          await metrics.updateActiveMinutes(activeMins);
        }
        setState(() {
          heartMessage = "VITAL STATS UPDATED"; // Текст успеха
        });
      }
    } catch (e) {
      setState(() {
        // Твое вежливое наставление вместо системной ошибки
        heartMessage = "CONNECT TO HEALTH HUB TO SYNC DATA"; 
      });
    }

// Автоматически убираем сообщение через 3-4 секунды
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => heartMessage = null);
    });
  }

  @override
  void initState() {
    super.initState();
    ///_audioPlayer.play(AssetSource('sounds/crystal_drop.mp3'));
    _videoController = VideoPlayerController.asset('videos/avatar.mov');
    _videoController.initialize().then((_) {
      if (mounted) {
        setState(() => _isVideoInitialized = true);
        _videoController.setLooping(true);
        _videoController.play();
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    ///_audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = Provider.of<MetricsProvider>(context);
    final evo = Provider.of<EvolutionProvider>(context);
    final customWorkouts = Provider.of<CustomWorkoutProvider>(context);

// --- ПОДКЛЮЧАЕМ СКВОЗНЯК ИЗ ПРОВАЙДЕРА ---
    final int nutritionScore = evo.calculateNutritionScore(metrics);
    final int activityScore = evo.calculateActivityScore(metrics);
    final int workoutScore = evo.calculateWorkoutScore(metrics);
    final double dailyXP = evo.calculateDailyXP(nutritionScore, activityScore, workoutScore);

    // Синхронизация данных
    if (dailyXP > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        evo.syncDailyCrystals(nutritionScore, activityScore, workoutScore);
      });
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double unit = screenWidth / 100;
    const Color gold = Color(0xFFFFD700);

    return GestureDetector(
      onTap: () { if (_openedVaultIndex != null) setState(() => _openedVaultIndex = null); },
      child: Scaffold(
        backgroundColor: const Color(0xFF0F0820),
        body: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: unit * 1,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.all(unit * 3),
                  child: Icon(Icons.arrow_back_ios_new, color: gold.withOpacity(0.5), size: unit * 5.5),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(height: unit * 2),
                  Text("VITAL ENERGY", style: TextStyle(color: gold, fontSize: unit * 3, fontWeight: FontWeight.w900, letterSpacing: unit * 1.5)),
                  SizedBox(height: unit * 2),
                  _buildTopPanel(gold, unit, metrics.dailyCaloriesLimit > 0 ? metrics.dailyCaloriesLimit : 2100, metrics.eatenToday.toInt(), metrics),
                  SizedBox(height: unit * 3),
                  
                  // --- КРИСТАЛЛЫ ---
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: unit * 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInstrumentGroup("NUTRITION", Colors.greenAccent, nutritionScore, unit, [
                          _miniLine(Icons.opacity, "${metrics.waterToday.toStringAsFixed(1)} // ${metrics.targetWater.toStringAsFixed(1)} L", Colors.greenAccent, unit),
                          _miniLine(Icons.restaurant, "${metrics.proteinToday.toInt()} // ${metrics.targetProtein.toInt()} P", Colors.greenAccent, unit),
                          _miniLine(Icons.tune, "${metrics.fatsToday.toInt()}/${metrics.targetFats.toInt()} F // ${metrics.carbsToday.toInt()}/${metrics.targetCarbs.toInt()} C", Colors.greenAccent, unit),
                        ]),
                        _buildInstrumentGroup("ACTIVITY", Colors.lightBlueAccent, activityScore, unit, [
                          _miniLine(Icons.directions_run, "${metrics.stepsToday} // 10000 steps", Colors.lightBlueAccent, unit),
                          _miniLine(Icons.whatshot, "${metrics.burnedToday.toInt()} // 500 kcal", Colors.lightBlueAccent, unit),
                          _miniLine(Icons.bolt, "${metrics.activeMinutesToday} // 45 min", Colors.lightBlueAccent, unit),
                        ]),
                        _buildInstrumentGroup("WORKOUT", gold, workoutScore, unit, [
                          _miniLine(Icons.workspace_premium, metrics.userLevel < 5 ? "NOVICE" : "ELITE", gold, unit),
                          _miniLine(Icons.auto_awesome, "XP : ${metrics.totalXP}", gold, unit),
                          _miniLine(Icons.military_tech, "LEVEL : ${metrics.userLevel}", gold, unit),
                        ]),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (evo.hasNewArtifactsToEquip) _buildNewArtifactsLabel(gold, unit),
                  _buildAvatarSpace(gold, unit, screenHeight, metrics, evo, nutritionScore, activityScore, workoutScore),
                  const Spacer(),
                ],
              ),
            ),
            _buildBottomControls(unit, gold, metrics),

       /// --- ЗОЛОТОЕ УВЕДОМЛЕНИЕ ---
          if (heartMessage != null)
            Positioned(
              bottom: 125, // Чуть приподнял, чтобы не мешало кнопкам
              left: 60, right: 60, // Увеличил отступы по бокам, чтобы рамка стала уже
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Уменьшил внутренние отступы
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(10), // Сделал углы чуть острее
                  border: Border.all(color: const Color(0xFFC5A059), width: 1.0), // Тоньше рамка
                ),
                child: Text(
                  heartMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFFF6B6B), // Сделал текст чуть мягче (не чисто белый)
                    fontSize: 10, // УМЕНЬШИЛИ В ДВА РАЗА (было около 18-20)
                    fontWeight: FontWeight.w500, // Сделал шрифт тоньше
                    letterSpacing: 0.8, // Добавил немного расстояния между буквами для стиля
                  ),
                ),
              ),
            )
          ]
    )
    )
    );
  }

  // Вспомогательные методы
  Widget _buildNewArtifactsLabel(Color gold, double unit) {
    return Padding(
      padding: EdgeInsets.only(bottom: unit * 2.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: unit * 4, vertical: unit * 1),
          decoration: BoxDecoration(color: gold.withOpacity(0.1), borderRadius: BorderRadius.circular(unit * 2), border: Border.all(color: gold.withOpacity(0.3))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.auto_awesome, color: gold, size: unit * 4),
            SizedBox(width: unit * 2),
            Text("NEW ARTIFACTS READY!", style: TextStyle(color: gold, fontSize: unit * 3, fontWeight: FontWeight.w900, shadows: const [Shadow(color: Colors.orange, blurRadius: 10)])),
            SizedBox(width: unit * 2),
            Icon(Icons.auto_awesome, color: gold, size: unit * 4),
          ]),
        ),
      ),
    );
  }

  Widget _buildAvatarSpace(Color gold, double unit, double screenH, MetricsProvider metrics, EvolutionProvider evo, int nutritionScore, int activityScore, int workoutScore) {
    final bool isMaleSelected = metrics.isMale ?? false;
    final Color glowColor = isMaleSelected ? const Color(0xFF4A90E2) : gold;
    final String folder = isMaleSelected ? 'item_male' : 'item_female';
    final String baseAvatar = isMaleSelected ? 'images/avatar_male.png' : 'images/avatar_female.png';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: unit * 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Реактор
          _buildReactor(unit, glowColor, nutritionScore, activityScore, workoutScore),
          // Аватар
          Column(
            children: [
              Container(
                width: unit * 56, height: unit * 75,
                decoration: BoxDecoration(border: Border.all(color: glowColor.withOpacity(0.1)), borderRadius: BorderRadius.circular(unit * 4)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isVideoInitialized && metrics.isMale == null)
                      SizedBox.expand(child: FittedBox(fit: BoxFit.contain, child: SizedBox(width: _videoController.value.size.width, height: _videoController.value.size.height, child: VideoPlayer(_videoController))))
                    else
                      Image.asset(baseAvatar, fit: BoxFit.contain),

                    ...evo.artifacts.where((art) => art.isEquipped).map((art) {
                      String fileName = (metrics.isMale == true ? art.nameMale : art.nameFemale);
                      return Positioned.fill(child: Image.asset('$folder/layers/$fileName.png', fit: BoxFit.contain, errorBuilder: (c, e, s) => const SizedBox.shrink()));
                    }),
                  ],
                ),
              ),
            ],
          ),
          // Сейфы
// Внутри Row, где Сейфы:
_buildVaults(unit, glowColor, metrics, folder, nutritionScore, activityScore, workoutScore),
        ],
      ),
    );
  }

Widget _buildReactor(double unit, Color glowColor, int n, int a, int w) {
    // Считаем общую сумму кристаллов
    int totalInColumn = n + a + w;
    //int totalVisualCrystals = n + a + w;
    // Рассчитываем уровень закраски (допустим, 20 кристаллов — это полный бак)
    //double fillLevel = totalVisualCrystals / 20;
   // Если кристаллов 0, то и уровень 0.
    double fillLevel = totalInColumn > 0 ? (totalInColumn + 0.8) / 12 : 0.0; 
    if (fillLevel > 1.0) fillLevel = 1.0;

    return Container(
      width: unit * 10, height: unit * 60,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2), 
        borderRadius: BorderRadius.circular(unit * 5), 
        border: Border.all(color: glowColor.withOpacity(0.3), width: 1.5)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(unit * 5),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: double.infinity, 
              height: (unit * 60) * fillLevel, // Теперь жидкость зависит от реальных кристаллов
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, 
                  end: Alignment.topCenter, 
                  colors: [glowColor.withOpacity(0.7), glowColor.withOpacity(0.2)]
                ), 
                border: Border(top: BorderSide(color: glowColor, width: 2))
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ...List.generate(w, (i) => Icon(Icons.diamond, color: const Color(0xFFFFD700), size: unit * 3.5)),
                ...List.generate(a, (i) => Icon(Icons.diamond, color: Colors.lightBlueAccent, size: unit * 3.5)),
                ...List.generate(n, (i) => Icon(Icons.diamond, color: Colors.greenAccent, size: unit * 3.5)),
                SizedBox(height: unit * 2),
              ],
            ),
// 3. ТЕКСТ (Вертикальный)
                Center(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: Text("REACTOR", style: TextStyle(
                      color: Colors.white.withOpacity(0.5), 
                      fontSize: unit * 2, 
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold
                    )
                    )
                  )
                )
          ],
        ),
      ),
    );
}

  Widget _buildBottomControls(double unit, Color gold, MetricsProvider metrics) {
    return Positioned(
      bottom: MediaQuery.of(context).padding.bottom + unit * 5,
      left: 0, right: 0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_isSelectingGender ? "CONFIRM YOUR CHOICE" : (metrics.isMale == null ? "SELECT GENDER" : "EVOLUTION ACTIVE"), style: TextStyle(color: gold.withOpacity(0.5), fontSize: unit * 2.5, fontWeight: FontWeight.w900)),
            SizedBox(height: unit * 2),
            Row(mainAxisSize: MainAxisSize.min, children: [
              //Ниже написана молния для тестировани
             /* _testBtn(unit),
              SizedBox(width: unit * 4),*/
              _isSelectingGender ? _buildGenderSelector(unit, metrics) : _mainActionBtn(unit, gold, metrics),
              SizedBox(width: unit * 4),
              _heartBtn(unit),
            ]),
          ],
        ),
      ),
    );
  }
//это кнопка для тестирования - молния
  /*Widget _testBtn(double unit) => GestureDetector(onTap: () {
    final m = Provider.of<MetricsProvider>(context, listen: false);
    final e = Provider.of<EvolutionProvider>(context, listen: false);
    int nextLvl = m.userLevel >= 8 ? 1 : m.userLevel + 1;
    m.updateLevel(nextLvl);
    e.toggleEquip('L$nextLvl');
    setState(() => _openedVaultIndex = null);
  }, child: Container(padding: EdgeInsets.all(unit * 2), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), child: Icon(Icons.bolt, color: Colors.white, size: unit * 5)));*/

  // =========================================================================
  // --- БЛОК НИЖНИХ КНОПОК ДЕЙСТВИЯ ---
  // =========================================================================

  // 1. ГЛАВНАЯ КНОПКА (START EVOLUTION / AVATAR READY)
  // Мы увеличили horizontal padding до unit * 8, чтобы кнопка стала шире и солиднее
  Widget _mainActionBtn(double unit, Color gold, MetricsProvider metrics) => GestureDetector(
    onTap: () => setState(() => _isSelectingGender = true),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: unit * 8, vertical: unit * 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(unit * 5),
        border: Border.all(
          color: metrics.isMale == null ? gold : Colors.greenAccent.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Кнопка облегает текст
        children: [
          Icon(
            metrics.isMale == null ? Icons.edit_note : Icons.check_circle,
            color: metrics.isMale == null ? gold : Colors.greenAccent,
            size: unit * 6,
          ),
          SizedBox(width: unit * 0.01), // Больше места между иконкой и текстом
          Flexible( // Защита текста от переполнения
            child: Text(
              metrics.isMale == null ? "START EVOLUTION" : "AVATAR READY",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: unit * 2.5, // Чуть больше размер для читаемости
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );

  // 2. КНОПКА ЗДОРОВЬЯ (СЕРДЕЧКО)
  // Мы сделали отступы аккуратнее (unit * 2), чтобы оно не было огромным и не толкало главную кнопку
  Widget _heartBtn(double unit) => GestureDetector(
    onTap: _fetchHealthData,
    child: Container(
      padding: EdgeInsets.all(unit * 0.5), // Уменьшили с 2.5 до 2
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.redAccent.withOpacity(0.3), width: 1.0),
      ),
      child: Icon(Icons.favorite, color: Colors.redAccent, size: unit * 6), // Иконка осталась прежней
    ),
  );

  Widget _buildGenderSelector(double unit, MetricsProvider metrics) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: unit * 3, vertical: unit * 2),
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(unit * 10)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _miniBtn(onTap: () => _showConfirmGender(true), label: "MALE", color: Colors.blueAccent, unit: unit),
        SizedBox(width: unit * 3),
        _miniBtn(onTap: () => _showConfirmGender(false), label: "FEMALE", color: const Color(0xFFFFD700), unit: unit),
      ]),
    );
  }

  Widget _miniBtn({required VoidCallback onTap, required String label, required Color color, required double unit}) => GestureDetector(onTap: onTap, child: Container(padding: EdgeInsets.symmetric(horizontal: unit * 6, vertical: unit * 2.5), decoration: BoxDecoration(borderRadius: BorderRadius.circular(unit * 5), border: Border.all(color: color.withOpacity(0.5))), child: Text(label, style: TextStyle(color: color, fontSize: unit * 2.5, fontWeight: FontWeight.bold))));

  Widget _buildInstrumentGroup(String label, Color color, int score, double unit, List<Widget> stats) {
    return Column(children: [
      Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: unit * 2.5, fontWeight: FontWeight.w900)),
      SizedBox(height: unit * 1),
      Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) => Icon(Icons.diamond, size: unit * 2.8, color: color, shadows: i < score ? [Shadow(color: color, blurRadius: 10)] : []))),
      SizedBox(height: unit * 1.5),
      ...stats,
    ]);
  }

  // 1. Исправленный miniLine (теперь текст будет нормального размера)
  Widget _miniLine(IconData icon, String text, Color color, double unit) => Row(
    mainAxisSize: MainAxisSize.min, 
    children: [
      Icon(icon, color: color.withOpacity(0.4), size: unit * 2.5), 
      SizedBox(width: unit * 1), 
      Text(text, style: TextStyle(color: Colors.white70, fontSize: unit * 2.2)) // Заменил 10 на unit
    ]
  );

  // 2. buildTopPanel (оставляем, он хорош)
  Widget _buildTopPanel(Color gold, double unit, int total, int consumed, MetricsProvider metrics) => Container(
    width: unit * 90, 
    padding: EdgeInsets.all(unit * 3), 
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.03), 
      borderRadius: BorderRadius.circular(unit * 5), 
      border: Border.all(color: gold.withOpacity(0.4))
    ), 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, 
      children: [
        Text("$total", style: TextStyle(color: gold, fontSize: unit * 7, fontWeight: FontWeight.w100)), 
        Column(children: [
          Text("IN: $consumed", style: TextStyle(color: gold, fontSize: unit * 2.5)), 
          Text("LEFT: ${total - consumed}", style: TextStyle(color: gold.withOpacity(0.5), fontSize: unit * 2.5))
        ])
      ]
    )
  );

  
// =========================================================================
// --- БЛОК СЕЙФОВ (VAULTS) ---
// Удали старые _buildVaults и _buildVaultContent и вставь эти:
// =========================================================================

Widget _buildVaults(double unit, Color glowColor, MetricsProvider metrics, String folder, int n, int a, int w) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      // ПРАВИЛЬНЫЕ НАЗВАНИЯ ДЛЯ ВСЕХ ТРЕХ
      List<String> names = ["NEURO-LINK", "CORE-STRENGTH", "WILL-POWER"];
      bool isOpen = _openedVaultIndex == index;
      
      // Рисуем сейф ВСЕГДА (убрали блокировку по уровню)
      return GestureDetector(
        onTap: () => setState(() => _openedVaultIndex = isOpen ? null : index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: EdgeInsets.only(bottom: unit * 2),
          width: isOpen ? unit * 25 : unit * 16, 
          height: unit * 18,
          decoration: BoxDecoration(
            color: isOpen ? Colors.black87 : Colors.white.withOpacity(0.05), 
            borderRadius: BorderRadius.circular(unit * 2), 
            border: Border.all(
              // Если это WILL-POWER, подсвечиваем золотым, иначе glowColor
              color: index == 2 ? const Color(0xFFFFD700).withOpacity(0.8) : glowColor.withOpacity(0.8), 
              width: 2
            )
          ),
          child: isOpen 
            ? _buildVaultContent(index, folder, metrics, unit, context, n, a, w) 
            : Center(
                child: RotatedBox(
                  quarterTurns: 3, 
                  child: Text(
                    names[index], 
                    style: TextStyle(
                      color: Color(0xFFFFD700).withOpacity(0.8),
                      fontSize: unit * 1.5, 
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5
                    )
                  )
                )
              ),
        ),
      );
    }),
  );
}

Widget _buildVaultContent(int index, String folder, MetricsProvider metrics, double unit, BuildContext context, int n, int a, int w) {
  // Список имен, совпадающий с ArtifactsScreen
  List<String> vaultNames = ["NEURO-LINK", "CORE-STRENGTH", "WILL-POWER"];
  String currentVaultName = vaultNames[index];

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtifactsScreen(vaultName: currentVaultName),
        ),
      );
    },
    child: Container(
      color: Colors.transparent, // Чтобы вся область была кликабельной
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            index == 2 ? Icons.bolt : Icons.diamond, 
            color: index == 2 ? const Color(0xFFFFD700) : Colors.white, 
            size: unit * 6
          ),
          SizedBox(height: unit),
          Text(
            "ENTER", 
            style: TextStyle(color: Colors.white, fontSize: unit * 2, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    ),
  );
}
}
