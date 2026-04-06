import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/evolution_manager.dart';
import '../providers/metrics_provider.dart';

class ArtifactsScreen extends StatefulWidget {
  final String vaultName; 

  const ArtifactsScreen({Key? key, required this.vaultName}) : super(key: key);

  @override
  _ArtifactsScreenState createState() => _ArtifactsScreenState();
}

class _ArtifactsScreenState extends State<ArtifactsScreen> {
  

  @override
  Widget build(BuildContext context) {
    final metrics = Provider.of<MetricsProvider>(context);
    final evo = Provider.of<EvolutionProvider>(context);
    final double unit = MediaQuery.of(context).size.width / 100;

    int currentScore = 0; 
    int totalGoal = 3;    
    int startIndex = 0;   
    Color themeColor;     
    IconData crystalIcon; 

    if (widget.vaultName == "NEURO-LINK") {
      currentScore = evo.calculateNutritionScore(metrics);
      totalGoal = 20; 
      startIndex = 0;
      themeColor = const Color(0xFF00FFC2);
      crystalIcon = Icons.diamond_outlined;
    } else if (widget.vaultName == "CORE-STRENGTH") {
      currentScore = evo.calculateActivityScore(metrics);
      totalGoal = 25;
      startIndex = 8;
      themeColor = const Color(0xFF00C2FF);
      crystalIcon = Icons.diamond;
    } else {
      currentScore = evo.calculateWorkoutScore(metrics);
      totalGoal = 15;
      startIndex = 16;
      themeColor = const Color(0xFFFFD700);
      crystalIcon = Icons.bolt; 
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F0820),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(unit, crystalIcon, themeColor, currentScore, totalGoal),
            Expanded(
              child: _buildArtifactsGrid(unit, metrics, currentScore, totalGoal, themeColor, evo, startIndex),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(double unit, IconData icon, Color color, int score, int total) {
    return Container(
      padding: EdgeInsets.all(unit * 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: color, size: unit * 6),
            onPressed: () => Navigator.pop(context),
          ),
          Text(widget.vaultName, style: TextStyle(color: color, fontSize: unit * 4.5, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          _buildCrystalIndicator(unit, icon, color, score, total),
        ],
      ),
    );
  }

  Widget _buildCrystalIndicator(double unit, IconData icon, Color color, int score, int total) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: unit * 3, vertical: unit * 1.5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(unit * 3),
        border: Border.all(color: color.withOpacity(0.3))
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: unit * 4),
          SizedBox(width: unit),
          Text("$score / $total", style: TextStyle(color: Colors.white, fontSize: unit * 3.5, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildArtifactsGrid(double unit, MetricsProvider metrics, int score, int total, Color color, EvolutionProvider evo, int startIdx) {
    return GridView.builder(
      padding: EdgeInsets.all(unit * 5),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 20, crossAxisSpacing: 20, childAspectRatio: 0.72
      ),
      itemCount: 8, 
      itemBuilder: (context, index) {
        final art = evo.artifacts[startIdx + index];
        final int requiredLevel = (index + 1) * 2;
        final bool isUnlockedByLevel = metrics.userLevel >= requiredLevel;

        return _buildArtifactCard(unit, art, isUnlockedByLevel, score, total, color, metrics, index);
      }
    );
  }

  
Widget _buildArtifactCard(double unit, Artifact art, bool isUnlocked, int score, int total, Color color, MetricsProvider metrics, int index) {
    String folder = (metrics.isMale == true) ? "item_male" : "item_female";
    String fileName = art.nameFemale; 

    // --- ЛОГИКА ПОСЛЕДОВАТЕЛЬНОГО ОТКРЫТИЯ (Твоя формула!) ---
    double stepStart = index * total.toDouble(); 
    double currentProgress;

    if (score <= stepStart) {
      currentProgress = 0.0; 
    } else if (score >= stepStart + total) {
      currentProgress = 1.0; 
    } else {
      currentProgress = (score - stepStart) / total; 
    }

    bool isFullyOpen = currentProgress >= 1.0; // Артефакт полностью открыт
    bool isEquipped = art.isEquipped; // Артефакт надет

// --- ДИЗАЙН СИЯНИЯ (Glow) ---
    // Мы создаем сияние, если артефакт полностью открыт. 
    // Если надет — сияние золотое, если просто открыт — сияние цвета сейфа.
    List<BoxShadow> glowShadows = [];
    if (isFullyOpen) {
      glowShadows = [
        BoxShadow(
          // Рассеянное сияние вокруг карточки
          // МЫ ЗАМЕНИЛИ ЦВЕТ НА БОЛЕЕ ТЕМНЫЙ И ГЛУБОКИЙ
          color: isEquipped ? const Color(0xFFA68045).withOpacity(0.5) : color.withOpacity(0.4),
          blurRadius: unit * 4,
          spreadRadius: unit * 0.5,
        ),
        BoxShadow(
          // Четкий контур сияния
          // МЫ ЗАМЕНИЛИ ЦВЕТ НА ПАТИНИРОВАННЫЙ ЗОЛОТОЙ
          color: isEquipped ? const Color(0xFFC5A059).withOpacity(0.3) : color.withOpacity(0.2),
          blurRadius: unit * 1,
          spreadRadius: unit * 0.1,
        ),
      ];
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600), // Плавное появление сияния
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(unit * 3),
        boxShadow: glowShadows, // ПРИМЕНЯЕМ СИЯНИЕ
        border: Border.all(
          // Рамка золотая, только когда 100% открыто
          color: isFullyOpen ? const Color(0xFFFFD700) : Colors.white10,
          width: isFullyOpen ? 2 : 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(unit * 3),
        child: Column(
          children: [
            // --- ВЕРХНЯЯ ЧАСТЬ (КАРТИНКА + ШТОРКА) ---
            Expanded(
              flex: 3, 
              child: Container(
                //color: Colors.white.withOpacity(0.01),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      alignment: Alignment.topCenter, 
                      children: [
                        // 1. КАРТИНКА (Четкая)
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Center(
                            child: Image.asset(
                              '$folder/icons/$fileName.png', 
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => 
                                Icon(art.icon, color: Colors.white10, size: unit * 10),
                            ),
                          ),
                        ),

                        // 2. ДИНАМИЧЕСКАЯ ЗОЛОТАЯ ШТОРКА (Только над картинкой!)
                        // Она показывается, пока прогресс меньше 100% (1.0)
                        if (currentProgress < 1.0)
                          Positioned(
                            top: 0, left: 0, right: 0,
                            // Высота шторки = (Вся зона Expanded) умножить на (Остаток closedFactor)
                            height: constraints.maxHeight * (1.0 - currentProgress), 
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCubic,
                              decoration: BoxDecoration(
                                // Используем твой любимый цвет состаренного золота. 
// Opacity 0.95 оставит легкую загадочность, но не даст фону исказить цвет.

  color: const Color(0xFFB8860B).withOpacity(0.7),


                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.lock_open_rounded, color: Colors.black54, size: 30),
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                ),
              ),
            ),
            
            // --- НИЖНЯЯ ЧАСТЬ (ТЕКСТ - ВСЕГДА ОТКРЫТ) ---
            Expanded(
              flex: 2, 
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: unit * 2),
                //color: Colors.white.withOpacity(0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        art.displayName.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // Текст названия становится состаренной бронзой
                          color: isFullyOpen ? const Color(0xFFC5A059) : const Color(0xFF8C6F3F).withOpacity(0.8),
                          fontSize: unit * 2.8, 
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      art.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        // Текст описания становится темным, читаемым серебром
                        color: isFullyOpen ? const Color(0xFFB0B0B0) : const Color(0xFF5A5A5A).withOpacity(0.8), 
                        // МЫ СДЕЛАЛИ ТЕКСТ КРУПНЕЕ! (unit * 2.2 вместо 1.8)
                        fontSize: unit * 2.5,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
