import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_body_life/screens/artifact_constructor.dart';
import 'package:smart_body_life/utils/storage_service.dart';

class LaboratoryScreen extends StatefulWidget {
  const LaboratoryScreen({super.key});

  @override
  State<LaboratoryScreen> createState() => _LaboratoryScreenState();
}

class _LaboratoryScreenState extends State<LaboratoryScreen> {
  double unit = 0;
  List<Map<String, dynamic>> myArtifacts = []; 

  @override
  void initState() {
    super.initState();
    _loadMyArtifacts();
  }

  void _loadMyArtifacts() {
    setState(() {
      myArtifacts = StorageService.getCustomArtifacts();
    });
  }


  Widget _buildInfoRow(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6A1B9A), size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 5),
              Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    unit = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF6A1B9A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("LABORATORY", 
          style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontWeight: FontWeight.bold, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Color(0xFF6A1B9A)),
            onPressed: () {
              // В будущем тут будет вызов смены языка
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(backgroundColor: Color(0xFF6A1B9A), content: Text("LANGUAGE SYNC ACTIVE")),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          _buildScannerZone(),
          Expanded(
            child: myArtifacts.isEmpty 
              ? _buildEmptyState() 
              : _buildArtifactsList(), 
          ),
          _buildCreateButton(),
          SizedBox(height: unit * 8),
        ],
      ),
    );
  }

  Widget _buildArtifactsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: unit * 5),
      itemCount: myArtifacts.length,
      itemBuilder: (context, index) {
        final item = myArtifacts[index];
        return Container(
          margin: EdgeInsets.only(bottom: unit * 4),
          padding: EdgeInsets.all(unit * 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(unit * 3),
            border: Border.all(color: const Color(0xFF6A1B9A).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              // КАРТИНКА ТРЕНАЖЕРА
              Container(
                width: unit * 12, height: unit * 12,
                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(unit * 2)),
                child: (item['customImage'] != null)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(unit * 2),
                        child: Image.file(
                          File(item['customImage']), 
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Icon(Icons.broken_image, color: Colors.white10, size: unit * 6),
                        ),
                      )
                    : Icon(Icons.settings_input_component, color: const Color(0xFF6A1B9A), size: unit * 8),
              ),
              
              SizedBox(width: unit * 4),
              
              // НАЗВАНИЕ И КАТЕГОРИЯ
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] ?? "Unnamed", 
                      style: GoogleFonts.saira(color: Colors.white, fontWeight: FontWeight.bold, fontSize: unit * 4.5)),
                    Text(item['category'] ?? "General", 
                      style: GoogleFonts.saira(color: Colors.white38, fontSize: unit * 3)),
                  ],
                ),
              ),
              
              // КНОПКА ИНФОРМАЦИИ "i"
              IconButton(
                icon: Icon(Icons.info_outline, color: const Color(0xFF6A1B9A).withOpacity(0.6), size: 20),
                onPressed: () => _showArtifactInfo(context, item),
              ),

              // КНОПКА КОРЗИНЫ
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.white10, size: 20),
                onPressed: () => _confirmDeletion(context, item),
              ),
            ],
          ),
        );
      },
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.biotech, color: const Color(0xFF6A1B9A).withOpacity(0.2), size: unit * 40),
          const SizedBox(height: 20),
          Text("NO ARTIFACTS DETECTED", style: GoogleFonts.saira(color: Colors.white24, fontSize: unit * 4)),
        ],
      ),
    );
  }

  Widget _buildScannerZone() {
    return Container(
      margin: EdgeInsets.all(unit * 5),
      padding: EdgeInsets.all(unit * 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6A1B9A).withOpacity(0.05),
        borderRadius: BorderRadius.circular(unit * 4),
        border: Border.all(color: const Color(0xFF6A1B9A).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.radar, color: Color(0xFF6A1B9A)),
          SizedBox(width: unit * 3),
          Expanded(child: Text("SCANNING FOR NEW EQUIPMENT DESIGNS...", style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontSize: unit * 3))),
        ],
      ),
    );
  }

  Widget _buildCreateButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ArtifactConstructor()))
            .then((_) => _loadMyArtifacts());
      },
      child: Container(
        width: unit * 80,
        padding: EdgeInsets.symmetric(vertical: unit * 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFF4A148C)]),
          borderRadius: BorderRadius.circular(unit * 10),
          boxShadow: [BoxShadow(color: const Color(0xFF6A1B9A).withOpacity(0.4), blurRadius: 15, spreadRadius: 2)],
        ),
        child: Center(child: Text("BUILD NEW ARTIFACT", style: GoogleFonts.saira(color: Colors.white, fontWeight: FontWeight.bold, fontSize: unit * 4.5))),
      ),
    );
  }
  // ЛОГИКА УДАЛЕНИЯ
  void _confirmDeletion(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text("DELETE DESIGN?", style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontWeight: FontWeight.bold)),
        content: Text("Remove '${data['title']}' from laboratory?", style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL", style: TextStyle(color: Colors.white38))),
          TextButton(
            onPressed: () {
              StorageService.deleteCustomArtifact(data['machineCode']);
              _loadMyArtifacts(); 
              Navigator.pop(context);
            }, 
            child: const Text("DELETE", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ЛОГИКА ШТОРКИ ИНФО
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
              style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontWeight: FontWeight.bold, fontSize: 22)),
            const SizedBox(height: 20),
            _buildInfoSection(Icons.build_circle_outlined, "BUILD", data['description'] ?? "No data"),
            const SizedBox(height: 20),
            _buildInfoSection(Icons.fitness_center, "TECHNIQUE", data['instructions'] ?? "No data"),
            const SizedBox(height: 20),
            _buildInfoSection(Icons.security, "SAFETY", data['safety'] ?? "No data"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6A1B9A), size: 22),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.saira(color: const Color(0xFF6A1B9A), fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 5),
              Text(content, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }
}