import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget { // <--- Теперь он Stateful
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // --- НАША ПАМЯТЬ ДЛЯ КНОПОК ---
  bool _notifsEnabled = true;
  bool _soundsEnabled = false;

  final Color gold = const Color(0xFFD4AF37);
  final Color deepEmerald = const Color(0xFF001A10);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('SYSTEM SETTINGS', 
          style: TextStyle(color: gold, letterSpacing: 3, fontWeight: FontWeight.bold, fontSize: 16)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: gold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, deepEmerald.withOpacity(0.3)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- 1. VIP / SUBSCRIPTION CARD (На перспективу) ---
            _buildVipCard(),
            const SizedBox(height: 30),

            // --- 2. CONTROL SECTION ---
            _sectionHeader("SYSTEM CONTROL"),
            // Для уведомлений
_buildToggleItem(
  Icons.notifications_active, 
  "Artifact Notifications", 
  _notifsEnabled, 
  (bool newValue) {
    setState(() => _notifsEnabled = newValue);
  }
),

// Для звука
_buildToggleItem(
  Icons.volume_up, 
  "System Sounds", 
  _soundsEnabled, 
  (bool newValue) {
    setState(() => _soundsEnabled = newValue);
  }
),
            
            const SizedBox(height: 25),

            // --- 3. LEGAL & LICENSES ---
            _sectionHeader("LEGAL ARCHIVE"),
            
            // 1. НОВАЯ КНОПКА ДЛЯ APPLE (Guideline 1.4.1)
            _buildLinkItem(Icons.menu_book_outlined, "Sources & Medical Compliance", () {
              _launchURL("https://docs.google.com/document/d/1LmneGc114rQR377FYS_9ZMcW7QKNVPC5ie5z9CTzhck/edit?usp=sharing");
            }),

            // 2. Для DISCLAIMER (твоя старая кнопка)
            _buildLinkItem(Icons.info_outline, "Medical Disclaimer", () {
              _launchURL("https://docs.google.com/document/d/13SpfXwEeclOg03Am-zhLI30-Jd8h9Y4_Rh_dqURuySM/edit?usp=sharing");
            }),

            // 3. Для PRIVACY POLICY
            _buildLinkItem(Icons.verified_user, "Privacy Policy", () {
              _launchURL("https://docs.google.com/document/d/1UpywYt9ir7gwUdrHVNyZvusF8WIawe4_sT2XyeL8Jjs/edit?usp=sharing");
            }),

            // 4. Для EULA (Terms of Service)
            _buildLinkItem(Icons.gavel, "Terms of Service (EULA)", () {
              _launchURL("https://docs.google.com/document/d/19bF_TbqJheMKHpsu0jRHWB18zAJOdnHFN-kSVFrXsHc/edit?usp=sharing");
            }),

            const SizedBox(height: 40),

            // --- 4. VERSION INFO ---
            Center(
              child: Column(
                children: [
                  Text("BIO-SYSTEM VERSION 1.0.1", 
                    style: TextStyle(color: gold.withOpacity(0.5), fontSize: 10, letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text("Device: Neural-Linked Model 2017", // Твоя "пасхалка" про ноутбук
                    style: TextStyle(color: Colors.white24, fontSize: 9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVipCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gold.withOpacity(0.5)),
        gradient: LinearGradient(colors: [gold.withOpacity(0.1), Colors.transparent]),
      ),
      child: Row(
        children: [
          Icon(Icons.stars, color: gold, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("ACCESS LEVEL: BASIC", style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
              const Text("Upgrade to PRO for extra artifacts", 
                style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(title, style: TextStyle(color: gold, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
    );
  }

Widget _buildToggleItem(IconData icon, String title, bool value, ValueChanged<bool> onChanged) {
  return ListTile(
    leading: Icon(icon, color: gold, size: 20),
    title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
    trailing: Switch(
      value: value,
      onChanged: onChanged, // <--- Теперь она слушает твоё нажатие!
      activeColor: gold,
      activeTrackColor: gold.withOpacity(0.3),
    ),
  );
}

  Widget _buildLinkItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: gold.withOpacity(0.7), size: 20),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
    );
  }
  void _showLegalDialog(BuildContext context, String title, String text) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      title: Text(title, style: TextStyle(color: gold)),
      content: SingleChildScrollView(
        child: Text(text, style: const TextStyle(color: Colors.white70)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("CLOSE", style: TextStyle(color: gold)),
        ),
      ],
    ),
  );
}
Future<void> _launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  // Мы используем встроенный механизм Flutter для открытия ссылок
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}
}