import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metrics_provider.dart';

// ЭТО НАШ СКЛАД ДЛЯ БУДУЩЕЙ ВКЛАДКИ "SET" (НАСТРОЙКИ)
class SettingsStorageScreen extends StatelessWidget {
  const SettingsStorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final metrics = Provider.of<MetricsProvider>(context);
    final double unit = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0820),
      appBar: AppBar(
        title: const Text("SYSTEM SETTINGS", style: TextStyle(color: Color(0xFFFFD700))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(unit * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AVATAR CONTROL", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
            SizedBox(height: unit * 4),
            
            // --- КНОПКА СБРОСА АВАТАРА ---
            // Когда мы её нажмем, на главном экране снова появится видео и выбор пола
            ListTile(
              tileColor: Colors.white.withOpacity(0.05),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              leading: const Icon(Icons.refresh, color: Colors.redAccent),
              title: const Text("RESET EVOLUTION", style: TextStyle(color: Colors.white)),
              subtitle: const Text("Clears avatar choice and restarts introduction video", style: TextStyle(color: Colors.white30, fontSize: 10)),
              onTap: () {
                // Сбрасываем пол в провайдере
                metrics.updateGender(null); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Avatar reset. Video will play on next entry.")),
                );
              },
            ),

            const Spacer(),
            // Сюда будем дописывать лицензии на звуки и прочее
            const Center(
              child: Text("Sound Assets: Glass Ding by LoafDV (CC0)", 
                style: TextStyle(color: Colors.white10, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}