import 'package:flutter/material.dart';
import 'package:smart_body_life/screens/active_workout_screen.dart';
import 'package:smart_body_life/screens/global_archive_screen.dart';
//import 'package:smart_body_life/screens/notebook_screen.dart';
// Путь к провайдеру
// Путь к моделям

class ProtocolSessionScreen extends StatelessWidget {
  const ProtocolSessionScreen({super.key});

  final Color kGoldColor = const Color(0xFFFFAB00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // ТА САМАЯ СТРЕЛОЧКА ВЫХОДА
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFFFAB00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("BUILD STATION", 
          style: TextStyle(color: Color(0xFFFFAB00), fontSize: 18, fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // ПЕРВАЯ ПАПКА: АКТИВНЫЕ ШАБЛОНЫ
              _buildMainTile(
                title: "ACTIVE ROUTINES",
                subtitle: "EDIT AND MANAGE YOUR SAVED PLANS",
                icon: Icons.folder_copy_rounded,
                color: const Color(0xFF111111),
                textColor: const Color(0xFFE0E0E0), // Серебряный
                isBordered: true,
                onTap: () {
                  // Ведем на экран со списком папок (Бицепс, Спина)
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ActiveWorkoutScreen()),
                  );
                },
              ),
              const SizedBox(height: 20),
              // ВТОРАЯ ПАПКА: ГЛОБАЛЬНЫЙ АРХИВ
              _buildMainTile(
                title: "GLOBAL ARCHIVE",
                subtitle: "TOTAL WORKOUT HISTORY & CALENDAR",
                icon: Icons.analytics_outlined,
                color: const Color(0xFF111111),
                textColor: const Color(0xFFC0C0C0), // Более тусклое серебро
                isBordered: true,
                onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const GlobalArchiveScreen()),
  );
},
              ),
              const Spacer(),
              const Text("BUILD YOUR BODY AS A MASTERPIECE", 
                style: TextStyle(color: Colors.white10, fontSize: 10, letterSpacing: 2)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainTile({
    required String title, 
    required String subtitle, 
    required IconData icon, 
    required Color color, 
    required Color textColor,
    required VoidCallback onTap,
    bool isBordered = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          border: isBordered ? Border.all(color: Colors.white12) : null,
          boxShadow: !isBordered ? [
            BoxShadow(color: color.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
          ] : [],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(subtitle, style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: textColor.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
}