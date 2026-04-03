import 'package:flutter/material.dart';
import 'workout_detail_screen.dart'; 
import 'workout_data_models.dart';   
import 'package:smart_body_life/data/gentle_sculpt_data.dart';  
import '../data/sculpting_upper_data.dart'; 

// --- НОВЫЕ ИМПОРТЫ (Наши новые пластинки) ---
import 'package:smart_body_life/data/silhouette_sculpt_data.dart';
import 'package:smart_body_life/data/toned_arms_data.dart';
import 'package:smart_body_life/data/slim_legs_data.dart';
import 'package:smart_body_life/data/lower_body_tonus_data.dart';

import 'package:smart_body_life/data/foundation_strength_data.dart';
import 'package:smart_body_life/data/hypertrophy_upper_data.dart';
import 'package:smart_body_life/data/hypertrophy_lower_data.dart';
import 'package:smart_body_life/data/mass_max_volume_data.dart';

class WorkoutPlansScreen extends StatefulWidget {
  const WorkoutPlansScreen({super.key});

  @override
  State<WorkoutPlansScreen> createState() => _WorkoutPlansScreenState();
}

class _WorkoutPlansScreenState extends State<WorkoutPlansScreen> with SingleTickerProviderStateMixin {
  late TabController _innerTabController;

  final Color kAccentColor = const Color(0xFFFFAB00); 
  final Color kCardColorStart = const Color(0xFF111111); 
  final Color kCardColorEnd = const Color(0xFF000000);   

  @override
  void initState() {
    super.initState();
    _innerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _innerTabController.dispose();
    super.dispose();
  }


  void _showProgramInfo(BuildContext context, WorkoutPlan plan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plan.title.toUpperCase(), style: TextStyle(color: kAccentColor, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text("PROGRAM DETAILS & INSTRUCTIONS:", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.1)),
              const SizedBox(height: 15),
              Text(plan.description, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.6)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: kAccentColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: const Text("CLOSE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlanList(bool isGain) {
    // 1. ПЛАНЫ ДЛЯ НАБОРА МЫШЕЧНОЙ МАССЫ (Наши новые "Пластинки")
    final List<Map<String, dynamic>> muscleGainPlans = [
  {
    'title': foundationStrengthPlan.title, 
    'level': foundationStrengthPlan.level, 
    'frequency': foundationStrengthPlan.frequency, 
    'data': foundationStrengthPlan
  },
  {
    'title': upperHypertrophyPlan.title, 
    'level': upperHypertrophyPlan.level, 
    'frequency': upperHypertrophyPlan.frequency, 
    'data': upperHypertrophyPlan
  },
  {
    'title': lowerHypertrophyPlan.title, 
    'level': lowerHypertrophyPlan.level, 
    'frequency': lowerHypertrophyPlan.frequency, 
    'data': lowerHypertrophyPlan
  },
  {
    'title': maxMassVolumePlan.title, 
    'level': maxMassVolumePlan.level, 
    'frequency': maxMassVolumePlan.frequency, 
    'data': maxMassVolumePlan
  },
];

    // 2. ПЛАНЫ ДЛЯ ПОХУДЕНИЯ И ТОНУСА (Наши новые "Пластинки")
    final List<Map<String, dynamic>> weightLossPlans = [
      {'title': gentleSculptPlan.title, 'level': gentleSculptPlan.level, 'frequency': gentleSculptPlan.frequency, 'data': gentleSculptPlan},
      {'title': sculptingUpperPlan.title, 'level': sculptingUpperPlan.level, 'frequency': sculptingUpperPlan.frequency, 'data': sculptingUpperPlan},
      {'title': waistSculptPlan.title, 'level': waistSculptPlan.level, 'frequency': waistSculptPlan.frequency, 'data': waistSculptPlan},
      {'title': lowerBodyGracePlan.title, 'level': lowerBodyGracePlan.level, 'frequency': lowerBodyGracePlan.frequency, 'data': lowerBodyGracePlan},
      {'title': tonedArmsPlan.title, 'level': tonedArmsPlan.level, 'frequency': tonedArmsPlan.frequency, 'data': tonedArmsPlan},
      {'title': slimLegsPlan.title, 'level': slimLegsPlan.level, 'frequency': slimLegsPlan.frequency, 'data': slimLegsPlan},
      {'title': lowerBodyTonusPlan.title, 'level': lowerBodyTonusPlan.level, 'frequency': lowerBodyTonusPlan.frequency, 'data': lowerBodyTonusPlan},
    ];

    final List<Map<String, dynamic>> plans = isGain ? muscleGainPlans : weightLossPlans;

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: plans.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final planData = plans[index];
        final WorkoutPlan? planObj = planData['data'];

        return WorkoutSquareTile(
          title: planData['title']!,
          level: planData['level']!,
          accentColor: kAccentColor,
          icon: isGain ? Icons.fitness_center : Icons.local_fire_department_rounded,
          onTap: () {
            if (planObj != null) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WorkoutDetailScreen(plan: planObj)));
            }
          },
          onInfoTap: () {
            if (planObj != null) _showProgramInfo(context, planObj);
          },
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, 
      child: Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          height: 40,
          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(25)),
          child: TabBar(
            controller: _innerTabController,
            indicator: BoxDecoration(color: const Color(0xFFFFAB00), borderRadius: BorderRadius.circular(25)),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            tabs: const [
              Tab(text: 'MUSCLE GAIN'),
              Tab(text: 'WEIGHT LOSS'),
            ],
          ),
          ),
        Expanded(
          child: TabBarView(
            controller: _innerTabController,
            children: [
              _buildPlanList(true),
              _buildPlanList(false),
            ],
          ),
        ),
      ],
    ));
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