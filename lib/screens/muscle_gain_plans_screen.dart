import 'package:flutter/material.dart';
import 'package:smart_body_life/data/foundation_strength_data.dart';
import 'package:smart_body_life/data/hypertrophy_lower_data.dart';
import 'package:smart_body_life/data/hypertrophy_upper_data.dart';
import 'package:smart_body_life/data/mass_max_volume_data.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/utils/translation_service.dart' as TranslationService;
import 'workout_detail_screen.dart'; 

class MuscleGainPlansScreen extends StatelessWidget {
  const MuscleGainPlansScreen({super.key});

  // Логика выбора языка (такая же, как в GymScreen)
  Future<String?> _showLanguagePicker(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text("CHOOSE LANGUAGE", style: TextStyle(color: Color(0xFFFFAB00))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption(context, "Українська", "uk"),
            _langOption(context, "Deutsch", "de"),
            _langOption(context, "Français", "fr"),
            _langOption(context, "Español", "es"),
          ],
        ),
      ),
    );
  }

  Widget _langOption(BuildContext context, String name, String code) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pop(context, code),
    );
  }

  void _showProgramInfo(BuildContext context, WorkoutPlan planObj) {
    // Локальные переменные для управления текстом внутри шторки
    String currentDescription = planObj.description;
    bool isTranslating = false;
    String currentActiveLang = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF05100A), // Твой темно-изумрудный
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(25.0),
              height: MediaQuery.of(context).size.height * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Шапка шторки: Заголовок + Золотая кнопка перевода
                  Row(
                    children: [
                      Expanded(
                        child: Text(planObj.title.toUpperCase(), 
                          style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                      ),
                      isTranslating 
                        ? const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFAB00)))
                        : IconButton(
                            icon: const Icon(Icons.language, color: Color(0xFFFFAB00), size: 28),
                            onPressed: () async {
                              final lang = await _showLanguagePicker(context);
                              if (lang != null) {
                                setModalState(() {
                                  isTranslating = true;
                                  currentActiveLang = lang;
                                  currentDescription = "Translating..."; 
                                });

                                try {
                                  // Переводим оригинал
                                  final translatedText = await TranslationService.TranslationService.translateText(planObj.description, lang);
                                  
                                  if (currentActiveLang == lang) {
                                    setModalState(() {
                                      currentDescription = translatedText;
                                      isTranslating = false;
                                    });
                                  }
                                } catch (e) {
                                  if (currentActiveLang == lang) setModalState(() => isTranslating = false);
                                }
                              }
                            },
                          ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text("PROGRAM DETAILS:", 
                    style: TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.1)),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(currentDescription, 
                        style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAB00), 
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      child: const Text("CLOSE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> plans = [
      {'title': foundationStrengthPlan.title, 'level': foundationStrengthPlan.level, 'data': foundationStrengthPlan},
      {'title': upperHypertrophyPlan.title, 'level': upperHypertrophyPlan.level, 'data': upperHypertrophyPlan},
      {'title': lowerHypertrophyPlan.title, 'level': lowerHypertrophyPlan.level, 'data': lowerHypertrophyPlan},
      {'title': maxMassVolumePlan.title, 'level': maxMassVolumePlan.level, 'data': maxMassVolumePlan},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05100A),
        elevation: 0,
        centerTitle: true,
        title: const Text("MUSCLE GAIN", style: TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final planObj = plans[index]['data'] as WorkoutPlan;
          
          return WorkoutSquareTile(
            title: plans[index]['title']!,
            level: plans[index]['level']!,
            accentColor: const Color(0xFFFFAB00),
            icon: Icons.fitness_center,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => WorkoutDetailScreen(plan: planObj))),
            onInfoTap: () => _showProgramInfo(context, planObj), 
          );
        },
      ),
    );
  }
}

class WorkoutSquareTile extends StatelessWidget {
  final String title;
  final String level;
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onInfoTap;
  final Color accentColor;

  const WorkoutSquareTile({
    super.key, required this.title, required this.level, required this.icon, 
    required this.onTap, required this.onInfoTap, required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF000000)],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: accentColor, size: 22),
                GestureDetector(
                  onTap: onInfoTap,
                  child: Icon(Icons.info_outline, color: accentColor.withOpacity(0.5), size: 18),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8)),
              child: Text(level, style: TextStyle(color: accentColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}