import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/training_data.dart';
import '../providers/workout_tracker_provider.dart'; 
import '../screens/workout_data_models.dart'; 
import '../providers/metrics_provider.dart';
//import '../widgets/pop_scope.dart';
import 'barbell_calc_screen.dart';
import 'dumbbell_calc_screen.dart';
import 'package:smart_body_life/screens/notebook_screen.dart';
import 'package:smart_body_life/utils/translation_service.dart' as TranslationService;

class WorkoutDetailScreen extends StatefulWidget { 
  final WorkoutPlan plan;
  
  const WorkoutDetailScreen({super.key, required this.plan});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  final Color kBgColor = const Color(0xFF000000); 
  final Color kAccentColor = const Color(0xFFFFAB00); 

  final List<String> timedActivities = [
    'M035', 'M036', 'M037', 'M038', 'M039', 'M040', 'M041'
  ];
  
  @override
  Widget build(BuildContext context) {
    // ИСПОЛЬЗУЕМ ВЕРСИЮ ДЛЯ FLUTTER 3.19
    return PopScope(
      canPop: false, // Блокируем системный назад
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // Логика сброса при выходе
        Provider.of<WorkoutTrackerProvider>(context, listen: false).resetDataAndExit(widget.plan);
        
        // Мануально закрываем экран
        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          title: Text(widget.plan.title, style: TextStyle(color: kAccentColor, fontWeight: FontWeight.bold)), 
          backgroundColor: kBgColor,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLiveStatsHeader(context),
              const SizedBox(height: 15),

              Consumer<WorkoutTrackerProvider>(
                builder: (context, tracker, child) {
                  if (tracker.isResting) return _buildRestTimerDisplay(context, tracker); 
                  return const SizedBox.shrink(); 
                },
              ),

              _buildSectionHeader(context, 'WARM-UP', Icons.accessibility_new),
              _buildExerciseList(context, widget.plan.warmUp), 
              const SizedBox(height: 25),

              _buildSectionHeader(context, 'MAIN WORKOUT', Icons.fitness_center),
              _buildExerciseList(context, widget.plan.mainWorkout),
              const SizedBox(height: 25),
              
              _buildSectionHeader(context, 'COOL-DOWN', Icons.self_improvement),
              _buildExerciseList(context, widget.plan.coolDown),
              const SizedBox(height: 100), 
            ],
          ),
        ),
        bottomNavigationBar: Consumer<WorkoutTrackerProvider>(
          builder: (context, tracker, child) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              color: kBgColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tracker.isManualRest 
                        ? "REST TIME: ${Duration(seconds: tracker.manualRestSeconds).toString().split('.').first}"
                        : "SESSION TIME: ${Duration(seconds: tracker.sessionTotalSeconds).toString().split('.').first}",
                    style: TextStyle(color: tracker.isManualRest ? kAccentColor : Colors.white70, fontSize: 14, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      if (tracker.isSessionActive)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => tracker.toggleManualRest(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tracker.isManualRest ? kAccentColor : Colors.white.withOpacity(0.05),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              minimumSize: const Size(0, 52),
                            ),
                            child: Text(tracker.isManualRest ? 'RESUME' : 'PAUSE'),
                          ),
                        ),
                      if (tracker.isSessionActive) const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (!tracker.isSessionActive) {
                              tracker.startSession(widget.plan);
                            } else {
                              double sessionKcal = tracker.calculateCalories();
                              final metrics = Provider.of<MetricsProvider>(context, listen: false);
                              metrics.updateBurned(metrics.burnedToday + sessionKcal.ceilToDouble());
                              tracker.endSession();
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tracker.isSessionActive ? Colors.red.withOpacity(0.8) : kAccentColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            minimumSize: const Size(0, 52),
                          ),
                          child: Text(tracker.isSessionActive ? 'FINISH' : 'START WORKOUT'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLiveStatsHeader(BuildContext context) {
    return Consumer<WorkoutTrackerProvider>(
      builder: (context, tracker, child) {
        int completedCount = 0;
        int totalExercises = widget.plan.allExercises.length;
        for (var ex in widget.plan.allExercises) {
          if (ex.isCompleted) completedCount++;
        }
        double calculatedCalories = tracker.calculateCalories();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(Icons.check_circle_outline, '$completedCount / $totalExercises', 'Exercises'),
              Container(width: 1, height: 40, color: Colors.white10),
              _buildSummaryItem(Icons.local_fire_department, '${calculatedCalories.toStringAsFixed(0)} kcal', 'Burned'),
            ],
          ),
        );
      }
    );
  }

  Widget _buildExerciseList(BuildContext context, List<Exercise> exercises) {
    return Consumer<WorkoutTrackerProvider>(
      builder: (context, tracker, child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(), 
          shrinkWrap: true,
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            final bool isThisActive = tracker.activeExercise == exercise;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFF111111),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: isThisActive 
                        ? kAccentColor
                        : (exercise.isCompleted ? kAccentColor : Colors.white.withOpacity(0.05)),
                    width: isThisActive ? 2.0 : 1.0
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (exercise.params?['status'] == null && exercise.machineCode == 'M018') 
                      _buildBigChoiceButton(exercise, tracker)
                    else if (exercise.params?['status'] == 'choosing')
                      _buildGearSelectionRows(exercise, tracker)
                    else
                      _buildStandardExerciseContent(context, exercise, tracker, isThisActive),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSetsInput(BuildContext context, Exercise currentExercise, WorkoutTrackerProvider tracker) {
    return _buildInteractableBox(context, 'Sets', '${currentExercise.sets}', () async {
       final double? newValue = await _showNumberInputDialog(context, currentExercise.sets.toDouble(), 'Set Number of Sets');
       if (newValue != null && newValue > 0) {
         currentExercise.sets = newValue.toInt();
         tracker.refreshUI();
       }
    });
  }

  Widget _buildWeightInput(BuildContext context, Exercise currentExercise, WorkoutTrackerProvider tracker) {
    bool isDumbbell = currentExercise.machineCode == 'M026';
    bool isBarbell = currentExercise.machineCode == 'M027';

    String weightDisplay = currentExercise.actualWeight != null 
        ? '${currentExercise.actualWeight!.toStringAsFixed(1)} kg' 
        : '— kg';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weight', style: TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 3),
        Row(
          children: [
            InkWell(
              onTap: () async {
                final double? newWeight = await _showNumberInputDialog(
                  context, currentExercise.actualWeight ?? 0, 'Set Weight (kg)');
                if (newWeight != null && newWeight >= 0) {
                  currentExercise.actualWeight = newWeight;
                  tracker.refreshUI(); 
                }
              },
              child: Container(
                width: 65, height: 30, 
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(5)),
                alignment: Alignment.center,
                child: Text(weightDisplay, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ),
            if (isDumbbell || isBarbell) ...[
              const SizedBox(width: 5),
              InkWell(
                onTap: () async {
                  final double? calcResult = await Navigator.push<double>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => isDumbbell 
                          ? const DumbbellCalcScreen() 
                          : const BarbellCalcScreen(),
                    ),
                  );
                  if (calcResult != null) {
                    currentExercise.actualWeight = calcResult;
                    tracker.refreshUI();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: kAccentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: kAccentColor, width: 0.5),
                  ),
                  child: Icon(Icons.calculate_outlined, color: kAccentColor, size: 18),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildRepsInput(BuildContext context, Exercise currentExercise, WorkoutTrackerProvider tracker) {
    String displayValue = currentExercise.actualReps != null ? '${currentExercise.actualReps} reps' : '— reps';
    return _buildInteractableBox(context, 'Reps', displayValue, () async {
       int initialValue = 15;
       final RegExp regExp = RegExp(r'\d+');
       final match = regExp.firstMatch(currentExercise.reps);
       if (match != null) initialValue = int.parse(match.group(0)!);

       final double? newValue = await _showNumberInputDialog(context, initialValue.toDouble(), 'Set Reps');
       if (newValue != null && newValue >= 0) {
         currentExercise.actualReps = newValue.toInt();
         tracker.refreshUI(); 
       }
    });
  }

  Widget _buildRestSection(BuildContext context, Exercise exercise, WorkoutTrackerProvider tracker) {
    String restDisplay = exercise.actualRestTime != null ? '${exercise.actualRestTime}s' : '—s';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rest', style: TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 3),
        Row(
          children: [
            InkWell(
              onTap: () async {
                final int initialRest = int.tryParse(exercise.restTime.split(' ')[0]) ?? 45;
                final double? newRestDouble = await _showNumberInputDialog(context, initialRest.toDouble(), 'Set Rest (sec)');
                if (newRestDouble != null) {
                  exercise.actualRestTime = newRestDouble.toInt();
                  tracker.refreshUI(); 
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(5)),
                child: Text(restDisplay, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => tracker.triggerRest(exercise),
              child: CircleAvatar(radius: 15, backgroundColor: kAccentColor, child: const Icon(Icons.timer, size: 18, color: Colors.black)),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRestTimerDisplay(BuildContext context, WorkoutTrackerProvider tracker) {
    String time = tracker.restRemaining.toString().padLeft(2, "0");
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: kAccentColor, width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: kAccentColor, size: 24),
                const SizedBox(width: 10),
                Text(
                  tracker.isManualRest ? 'MANUAL REST' : 'REST: 00:$time', 
                  style: TextStyle(color: kAccentColor, fontSize: 20, fontWeight: FontWeight.bold)
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => tracker.toggleManualRest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size(100, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(tracker.isManualRest ? 'RESUME' : 'HOLD'),
                ),
                TextButton(
                  onPressed: () => tracker.skipRest(), 
                  child: const Text('SKIP', style: TextStyle(color: Colors.white70))
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractableBox(BuildContext context, String label, String value, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 3),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 65, height: 30, 
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Future<double?> _showNumberInputDialog(BuildContext context, double initialValue, String title) async {
    TextEditingController controller = TextEditingController(text: initialValue > 0 ? initialValue.toStringAsFixed(0) : '');
    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111111),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller, keyboardType: TextInputType.number, autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFAB00)))),
          ),
          actions: <Widget>[
            TextButton(child: const Text('SAVE', style: TextStyle(color: Color(0xFFFFAB00))), onPressed: () => Navigator.of(context).pop(double.tryParse(controller.text))),
          ],
        );
      },
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: kAccentColor, size: 20),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: kAccentColor, size: 24),
          const SizedBox(width: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  void _showInfoSheet(BuildContext context, Exercise exercise) {
    final fullTemplate = TrainingData.getAllExercises().firstWhere(
      (e) => e.machineCode == exercise.machineCode,
      orElse: () => exercise,
    );

    String currentDesc = fullTemplate.description ?? "No description.";
    bool isTranslating = false;
    String currentActiveLang = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF05100A), 
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(exercise.title.toUpperCase(), 
                          style: TextStyle(color: kAccentColor, fontSize: 20, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
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
                                  currentDesc = "Translating..."; 
                                });
                                try {
                                  final tDesc = await TranslationService.TranslationService.translateText(fullTemplate.description ?? "", lang);
                                  if (currentActiveLang == lang) {
                                    setModalState(() {
                                      currentDesc = tDesc;
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
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(15),
                      child: Image.asset(exercise.image ?? '', fit: BoxFit.contain, 
                        errorBuilder: (c, e, s) => const Icon(Icons.fitness_center, color: Colors.white24, size: 50)),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text("TRAINER'S SECRETS:", 
                    style: TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.1)),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(currentDesc, 
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
                        backgroundColor: kAccentColor, 
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

  Widget _buildBigChoiceButton(Exercise exercise, WorkoutTrackerProvider tracker) {
    return InkWell(
      onTap: () {
        exercise.params ??= {}; 
        exercise.params!['status'] = 'choosing';
        tracker.refreshUI();
      },
      child: Container(
        height: 120,
        width: double.infinity,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: kAccentColor, size: 30),
            const SizedBox(height: 10),
            Text("SELECT EQUIPMENT", 
              style: TextStyle(color: kAccentColor, fontWeight: FontWeight.w900, fontSize: 16)),
            const Text("Tap to see available options", 
              style: TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildGearSelectionRows(Exercise exercise, WorkoutTrackerProvider tracker) {
    final List<String> codes = ["M018", "M026", "M027"]; 
    return Column(
      children: [
        const Text("AVAILABLE EQUIPMENT OPTIONS:", 
          style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...codes.map((code) {
          final template = TrainingData.getAllExercises().firstWhere((e) => e.machineCode == code);
          return InkWell(
            onTap: () {
              exercise.title = template.title;
              exercise.image = template.image;
              exercise.description = template.description;
              exercise.machineCode = template.machineCode;
              exercise.params!['status'] = 'ready'; 
              tracker.refreshUI();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset(template.image ?? '', width: 35, height: 35),
                  const SizedBox(width: 15),
                  Text(template.title, style: const TextStyle(color: Colors.white, fontSize: 14)),
                  const Spacer(),
                  Icon(Icons.arrow_forward_ios, color: kAccentColor, size: 14),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStandardExerciseContent(BuildContext context, Exercise exercise, WorkoutTrackerProvider tracker, bool isThisActive) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                exercise.title.toUpperCase(), 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5)
              )
            ),
            /*IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.edit_note, color: kAccentColor, size: 30),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotebookScreen(),
                  ),
                );
              },
            ),*/
            InkWell(
              onTap: () => _showInfoSheet(context, exercise),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white10, 
                  borderRadius: BorderRadius.circular(20), 
                  border: Border.all(color: kAccentColor)
                ),
                child: Text('INFO', style: TextStyle(color: kAccentColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        const Divider(color: Colors.white10, height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSetsInput(context, exercise, tracker), 
            _buildRepsInput(context, exercise, tracker), 
            _buildWeightInput(context, exercise, tracker), 
            _buildRestSection(context, exercise, tracker), 
          ],
        ),
        const SizedBox(height: 20),
        if (tracker.isSessionActive)
          ElevatedButton(
            onPressed: () => isThisActive ? tracker.stopExercise(exercise) : tracker.startExercise(exercise),
            style: ElevatedButton.styleFrom(
              backgroundColor: isThisActive ? Colors.red.withOpacity(0.8) : kAccentColor,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              isThisActive ? 'FINISH EXERCISE' : 'START EXERCISE', 
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w900)
            ),
          ),
      ],
    );
  }

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
}