import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/utils/storage_service.dart';
import 'package:smart_body_life/screens/workout_data_models.dart';
import 'package:image_picker/image_picker.dart';

const Color gemGraphite = Color(0xFF1A1A1A);
const Color gemViolet = Color(0xFF6A1B9A);

class MyArtifactsScreen extends StatefulWidget {
  final bool isSelectionMode;
  const MyArtifactsScreen({super.key, this.isSelectionMode = false});

  @override
  State<MyArtifactsScreen> createState() => _MyArtifactsScreenState();
}

class _MyArtifactsScreenState extends State<MyArtifactsScreen> {
  List<Map<String, dynamic>> artifacts = [];

  @override
  void initState() {
    super.initState();
    _loadArtifacts();
  }

  void _loadArtifacts() {
    setState(() {
      artifacts = StorageService.getCustomArtifacts();
    });
  }

  Future<void> _pickImageForArtifact(Map<String, dynamic> data) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        data['customImage'] = image.path;
      });
      // Обновляем в памяти, чтобы фото не пропало
      StorageService.updateArtifactImage(data['machineCode'], image.path);
    }
  }

  Widget _buildArtifactCard(Map<String, dynamic> data, double unit) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: gemViolet.withOpacity(0.5), width: 1),
      ),
      child: Row(
        children: [
          // 1. ФОТО ТРЕНАЖЕРА
          GestureDetector(
            onTap: () => _pickImageForArtifact(data),
            child: Container(
              width: 80, height: 90,
              decoration: const BoxDecoration(
                color: gemGraphite,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
              ),
              child: data['customImage'] != null 
                ? ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                    child: Image.file(File(data['customImage']), fit: BoxFit.cover),
                  )
                : const Icon(Icons.add_a_photo, color: gemViolet, size: 30),
            ),
          ),
          
          const SizedBox(width: 15),

          // 2. ИНФОРМАЦИЯ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data['title']?.toUpperCase() ?? "UNKNOWN", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("${data['category']}", 
                  style: const TextStyle(color: gemViolet, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // 3. ИНФОРМАЦИОННАЯ КНОПКА "i"
          IconButton(
            icon: Icon(Icons.info_outline, color: gemViolet.withOpacity(0.7), size: 24),
            onPressed: () => _showArtifactInfo(context, data),
          ),

          // 4. КОРЗИНА
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white24, size: 22),
            onPressed: () => _confirmDeletion(context, data),
          ),

          const SizedBox(width: 5),

          // 5. ПЛЮСИК
          widget.isSelectionMode 
            ? Consumer<ActiveSessionProvider>(
                builder: (context, activeSession, child) {
                  return GestureDetector(
                    onTap: () => _showAddDialog(context, data, activeSession),
                    child: Container(
                      width: 36, height: 36,
                      margin: const EdgeInsets.only(right: 15),
                      decoration: const BoxDecoration(color: gemViolet, shape: BoxShape.circle),
                      child: const Icon(Icons.add, color: Colors.white, size: 22),
                    ),
                  );
                },
              )
            : IconButton(
                padding: const EdgeInsets.only(right: 15),
                icon: const Icon(Icons.add_circle_outline, color: gemViolet, size: 30),
                onPressed: () {
                  // ПРЯМОЙ ПУТЬ В БЛОКНОТ ТРЕНИРОВКИ
                  // Открываем диалог ввода данных (Sets/Reps/Weight)
                  _showAddDialog(
                    context, 
                    data, 
                    Provider.of<ActiveSessionProvider>(context, listen: false)
                  );
                },
              ),
        ],
      ),
    );
  }

  void _showArtifactInfo(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF05100A), 
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)))),
            const SizedBox(height: 20),
            Text(data['title']?.toUpperCase() ?? "INFO", 
              style: GoogleFonts.saira(color: gemViolet, fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.build_circle_outlined, "BUILD", data['description'] ?? "No data available"),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.fitness_center, "TECHNIQUE", data['instructions'] ?? "No data available"),
            const SizedBox(height: 20),
            _buildInfoRow(Icons.security, "SAFETY", data['safety'] ?? "No data available"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: gemViolet, size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.saira(color: gemViolet, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 5),
              Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  void _confirmDeletion(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemGraphite,
        title: const Text("DELETE?", style: TextStyle(color: Colors.white)),
        content: Text("Remove ${data['title']} from your arsenal?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          TextButton(
            onPressed: () {
              StorageService.deleteCustomArtifact(data['machineCode']);
              _loadArtifacts();
              Navigator.pop(context);
            }, 
            child: const Text("DELETE", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, Map<String, dynamic> data, ActiveSessionProvider activeSession) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemGraphite,
        title: const Text("ADD TO SESSION?", style: TextStyle(color: gemViolet, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              final exerciseObj = Exercise(
                id: data['machineCode'] ?? 'custom_${DateTime.now().millisecondsSinceEpoch}',
                title: data['title'] ?? "NEW ARTIFACT",
                category: data['category'] ?? "CUSTOM",
                machineCode: data['machineCode'] ?? "000",
                kcal: data['kcal']?.toString() ?? "0",
                image: data['customImage'] ?? "res_gym/M001.png", 
                sets: 3, reps: "12", restTime: "60s", targetMuscles: "Custom",
              );
              activeSession.addToRunningWorkout(exerciseObj);
              activeSession.refreshLaboratory(); 
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 3);
            },
            child: const Text("ADD", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double unit = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: gemViolet),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("MY ARSENAL", style: GoogleFonts.saira(color: gemViolet, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: gemViolet),
            onPressed: () {
  _showLanguageDialog(context); // Вызываем твоё фирменное окно
},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: artifacts.isEmpty
          ? _buildEmptyState(unit)
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: artifacts.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 15),
              itemBuilder: (context, index) => _buildArtifactCard(artifacts[index], unit),
            ),
    );
  }

  Widget _buildEmptyState(double unit) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.biotech, color: Colors.white10, size: unit * 30),
          const SizedBox(height: 20),
          Text("ARSENAL IS EMPTY", style: GoogleFonts.saira(color: Colors.white24, fontSize: unit * 4)),
        ],
      ),
    );
  }
  void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("CHOOSE LANGUAGE", 
        style: GoogleFonts.saira(color: const Color(0xFFFFA000), fontWeight: FontWeight.bold)),
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
}

Widget _langOption(String name, String code) {
  return ListTile(
    title: Text(name, style: const TextStyle(color: Colors.white)),
    onTap: () {
      StorageService.saveLanguage(code).then((_) {
        setState(() {}); // Обновляем экран конструктора
        Navigator.pop(context);
      });
    },
  );
}
}