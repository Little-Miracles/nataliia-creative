import 'package:flutter/material.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:smart_body_life/screens/workout_plan_screen.dart';
import 'workout_detail_screen.dart'; 
import 'package:smart_body_life/data/gentle_sculpt_data.dart';  
import '../data/sculpting_upper_data.dart'; 
import 'package:smart_body_life/data/silhouette_sculpt_data.dart';
import 'package:smart_body_life/data/toned_arms_data.dart';
import 'package:smart_body_life/data/slim_legs_data.dart';
import 'package:smart_body_life/data/lower_body_tonus_data.dart';
// Добавляем сервис перевода
import 'package:smart_body_life/utils/translation_service.dart' as TranslationService;

class WeightLossPlansScreen extends StatelessWidget {
  const WeightLossPlansScreen({super.key});

  // Вспомогательные методы для выбора языка
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
    // Состояние для текста внутри шторки
    String currentDescription = planObj.description;
    bool isTranslating = false;
    String currentActiveLang = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF05100A), // Твой изумрудный стиль
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(25.0),
              height: MediaQuery.of(context).size.height * 0.70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок + Золотая кнопка
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
      {'title': gentleSculptPlan.title, 'level': gentleSculptPlan.level, 'data': gentleSculptPlan},
      {'title': sculptingUpperPlan.title, 'level': sculptingUpperPlan.level, 'data': sculptingUpperPlan},
      {'title': waistSculptPlan.title, 'level': waistSculptPlan.level, 'data': waistSculptPlan},
      {'title': lowerBodyGracePlan.title, 'level': lowerBodyGracePlan.level, 'data': lowerBodyGracePlan},
      {'title': tonedArmsPlan.title, 'level': tonedArmsPlan.level, 'data': tonedArmsPlan},
      {'title': slimLegsPlan.title, 'level': slimLegsPlan.level, 'data': slimLegsPlan},
      {'title': lowerBodyTonusPlan.title, 'level': lowerBodyTonusPlan.level, 'data': lowerBodyTonusPlan},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF05100A),
        elevation: 0,
        title: const Text("WEIGHT LOSS", style: TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
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
          final planData = plans[index];
          final WorkoutPlan? planObj = planData['data'];

          return WorkoutSquareTile(
            title: planData['title']!,
            level: planData['level']!,
            accentColor: const Color(0xFFFFAB00),
            icon: planData['level'] == 'GAIN' ? Icons.fitness_center : Icons.local_fire_department_rounded,
            onTap: () {
              if (planObj != null) {
                Navigator.push(context, MaterialPageRoute(builder: (c) => WorkoutDetailScreen(plan: planObj)));
              }
            },
            onInfoTap: () {
              if (planObj != null) _showProgramInfo(context, planObj);
            },
          );
        },
      ),
    );
  }
}