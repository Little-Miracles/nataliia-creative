import 'dart:async';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:smart_body_life/data/relax_data.dart';
import 'package:smart_body_life/data/exercise_library_data.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/utils/translation_service.dart' as TranslationService;
import '../providers/metrics_provider.dart';

class YogaTimerPlayerScreen extends StatefulWidget {
  final List<RelaxExercise> exercises;
  final String programName;

  const YogaTimerPlayerScreen({super.key, required this.exercises, required this.programName});

  @override
  State<YogaTimerPlayerScreen> createState() => _YogaTimerPlayerScreenState();
}

class _YogaTimerPlayerScreenState extends State<YogaTimerPlayerScreen> {
  int _currentIndex = 0;
  int _secondsLeft = 0;
  Timer? _timer;
  bool _isPaused = false;
  bool _isResting = true; 
  double _totalCaloriesBurned = 0; 

  ExerciseDescription? _getLibraryDescription(String id) {
    final allLists = [
      LibraryData.energyFlow,
      LibraryData.deepRecovery,
      LibraryData.zenBreath,
      LibraryData.goldenVertical,
      LibraryData.taiChiLibrary 
    ];
    for (var list in allLists) {
      try {
        return list.firstWhere((element) => element.id == id);
      } catch (_) { continue; }
    }
    return null;
  }

  void _addToCalendar() {
    final Event event = Event(
      title: 'Smart Body: ${widget.programName}',
      description: 'Burned ${_totalCaloriesBurned.toStringAsFixed(1)} kcal',
      location: 'Home Workout',
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(minutes: 30)),
    );
    Add2Calendar.addEvent2Cal(event);
  }

  Widget _buildLibraryRow(IconData icon, String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFFFAB00), width: 1.5),
          ),
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

  void _showInfoBottomSheet(BuildContext context, String exerciseId) async {
    final libData = _getLibraryDescription(exerciseId);
    if (libData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF05100A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: MediaQuery.of(context).size.height * 0.75,
        child: ExerciseInfoContent(
          libData: libData, 
          buildRow: _buildLibraryRow, 
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _prepareExercise(0); 
  }

  void _prepareExercise(int index) {
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
      _isResting = true;
      _secondsLeft = 10; 
      _isPaused = false;
    });
    _startTimer();
  }

  void _startExercise() {
    if (!mounted) return;
    setState(() {
      _isResting = false;
      _secondsLeft = widget.exercises[_currentIndex].duration;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    final metrics = Provider.of<MetricsProvider>(context, listen: false);
    final double weight = metrics.currentWeight > 0 ? metrics.currentWeight : 70.0;
    final double kcalPerSecond = (3.0 * 3.5 * weight) / 12000;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        if (_secondsLeft > 0) {
          setState(() {
            _secondsLeft--;
            if (!_isResting) {
              _totalCaloriesBurned += kcalPerSecond;
              metrics.addBurnedCalories(kcalPerSecond);
            }
          });
        } else {
          if (_isResting) {
            _startExercise(); 
          } else {
            _nextExercise();
          }
        }
      }
    });
  }

  void _nextExercise() {
    if (_currentIndex < widget.exercises.length - 1) {
      _prepareExercise(_currentIndex + 1);
    } else {
      _timer?.cancel();
      _showFinishDialog();
    }
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text("EXIT?", style: TextStyle(color: Color(0xFFFFAB00))),
        content: const Text("Do you want to stop the workout?", style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CONTINUE", style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("EXIT", style: TextStyle(color: Color(0xFFFFAB00))),
          ),
        ],
      ),
    );
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("GREAT JOB!", style: TextStyle(color: Color(0xFFFFAB00), fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 60),
            const SizedBox(height: 20),
            Text("Total Calories: ${_totalCaloriesBurned.toStringAsFixed(1)} kcal", 
              style: const TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _addToCalendar,
            child: const Text("ADD TO CALENDAR", style: TextStyle(color: Color(0xFFFFAB00))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("FINISH", style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentEx = widget.exercises[_currentIndex];
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => _showExitConfirmation(context),
        ),
        title: Text(widget.programName, 
          style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (_currentIndex + 1) / widget.exercises.length,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFAB00)),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isPaused ? "PAUSED" : (_isResting ? "GET READY" : "PERFORM"), 
                        style: TextStyle(
                          color: _isPaused ? Colors.redAccent : (_isResting ? Colors.blue : Colors.white54), 
                          letterSpacing: 2, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                        )
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "$_secondsLeft", 
                        style: TextStyle(
                          color: _isResting ? Colors.blue : const Color(0xFFFFAB00),
                          fontSize: 32,
                          fontWeight: FontWeight.w900
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    height: screenHeight * 0.45, 
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage(currentEx.image), 
                        fit: BoxFit.cover, 
                        alignment: Alignment.topCenter, 
                        opacity: (_isResting || _isPaused) ? 0.3 : 1.0,
                      ),
                    ),
                    child: (_isResting && !_isPaused) 
                        ? const Center(child: Icon(Icons.accessibility_new, size: 60, color: Colors.white10)) 
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Text(currentEx.title.toUpperCase(), 
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 10),
                        Text(
                          currentEx.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white38, fontSize: 13),
                        ),
                        const SizedBox(height: 15),
                        Text("Burned: ${_totalCaloriesBurned.toStringAsFixed(1)} kcal", 
                          style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () => _showInfoBottomSheet(context, currentEx.id),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFFFAB00).withOpacity(0.5)),
                          ),
                          child: const Icon(Icons.info_outline, color: Color(0xFFFFAB00), size: 24),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => _isPaused = !_isPaused),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: _isPaused ? const Color(0xFFFFAB00) : Colors.white12,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, 
                            color: _isPaused ? Colors.black : Colors.white, 
                            size: 40
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, color: Colors.white24, size: 35),
                        onPressed: _nextExercise,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExerciseInfoContent extends StatefulWidget {
  final ExerciseDescription libData;
  final Widget Function(IconData, String, String) buildRow;

  const ExerciseInfoContent({super.key, required this.libData, required this.buildRow});

  @override
  State<ExerciseInfoContent> createState() => _ExerciseInfoContentState();
}

class _ExerciseInfoContentState extends State<ExerciseInfoContent> {
  String? translatedInfo;
  String? translatedBuild;
  String? translatedTechnique;
  String? translatedSafety;
  bool isTranslating = false;
  String currentActiveLang = ''; 

  Future<void> _translateAll() async {
    final String? selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111111),
        title: const Text("CHOOSE LANGUAGE", style: TextStyle(color: Color(0xFFFFAB00))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption("Українська", "uk"),
            _langOption("Deutsch", "de"),
            _langOption("Français", "fr"),
            _langOption("Español", "es"),
          ],
        ),
      ),
    );

    if (selectedLanguage == null) return;

    setState(() {
      isTranslating = true;
      currentActiveLang = selectedLanguage;
      translatedInfo = "Translating...";
      translatedBuild = "Translating...";
      translatedTechnique = "Translating...";
      translatedSafety = "Translating...";
    });
    
    try {
      final newInfo = await TranslationService.TranslationService.translateText(widget.libData.info, selectedLanguage);
      final newBuild = await TranslationService.TranslationService.translateText(widget.libData.build, selectedLanguage);
      final newTechnique = await TranslationService.TranslationService.translateText(widget.libData.technique, selectedLanguage);
      final newSafety = await TranslationService.TranslationService.translateText(widget.libData.safety, selectedLanguage);

      if (mounted && currentActiveLang == selectedLanguage) {
        setState(() {
          translatedInfo = newInfo;
          translatedBuild = newBuild;
          translatedTechnique = newTechnique;
          translatedSafety = newSafety;
          isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isTranslating = false);
      }
    }
  }

  Widget _langOption(String name, String code) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      onTap: () => Navigator.pop(context, code),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 40, height: 4, 
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40),
            Expanded(
              child: Text(
                widget.libData.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic),
              ),
            ),
            isTranslating 
              ? const SizedBox(width: 40, height: 20, child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFFAB00))))
              : IconButton(
                  icon: const Icon(Icons.language, color: Color(0xFFFFAB00), size: 28),
                  onPressed: _translateAll,
                ),
          ],
        ),
        const SizedBox(height: 30),
        Expanded(
          child: ListView(
            children: [
              widget.buildRow(Icons.info_outline, "INFO", translatedInfo ?? widget.libData.info),
              const SizedBox(height: 25),
              widget.buildRow(Icons.auto_awesome, "BUILD", translatedBuild ?? widget.libData.build),
              const SizedBox(height: 25),
              widget.buildRow(Icons.fitness_center, "TECHNIQUE", translatedTechnique ?? widget.libData.technique),
              const SizedBox(height: 25),
              widget.buildRow(Icons.security, "SAFETY", translatedSafety ?? widget.libData.safety),
            ],
          ),
        ),
      ],
    );
  }
}