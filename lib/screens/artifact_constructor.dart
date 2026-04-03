import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_body_life/utils/storage_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// Наш вороненый металл и фиолетовый неон
const Color gemGraphite = Color(0xFF1A1A1A);
const Color gemViolet = Color(0xFF6A1B9A);

class ArtifactConstructor extends StatefulWidget {
  const ArtifactConstructor({super.key});

  @override
  State<ArtifactConstructor> createState() => _ArtifactConstructorState();
}

class _ArtifactConstructorState extends State<ArtifactConstructor> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController(text: "5.5");
  final TextEditingController _setsController = TextEditingController(text: "3");
  final TextEditingController _repsController = TextEditingController(text: "15");
  final TextEditingController _restController = TextEditingController(text: "30s");
  
  final TextEditingController _buildController = TextEditingController();
  final TextEditingController _techController = TextEditingController();
  final TextEditingController _safetyController = TextEditingController();

  String _selectedCategory = "STRENGTH MACHINES";
  String _selectedMuscle = "CHEST";
  String _selectedLevel = "BEGINNER";

  double unit = 0;
  String? _selectedImagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _kcalController.dispose();
    _setsController.dispose();
    _repsController.dispose();
    _restController.dispose();
    _buildController.dispose();
    _techController.dispose();
    _safetyController.dispose();
    super.dispose();
  }

  // 1. СПИСОК МЫШЦ
  List<String> _getMuscleList() {
    String lang = StorageService.getLanguage();
    if (lang == 'uk') return ["ГРУДИ", "СПИНА", "НОГИ", "РУКИ", "ПЛЕЧІ", "ПРЕС", "ВСЕ ТІЛО"];
    if (lang == 'es') return ["PECHO", "ESPALDA", "PIERNAS", "BRAZOS", "HOMBROS", "ABDOMINALES", "TODO EL CUERPO"];
    if (lang == 'de') return ["BRUST", "RÜCKEN", "BEINE", "ARME", "SCHULTERN", "CORE", "GANZKÖRPER"];
    if (lang == 'fr') return ["POITRINE", "DOS", "JAMBES", "BRAS", "ÉPAULES", "ABDOMINAUX", "CORPS ENTIER"];
    return ["CHEST", "BACK", "LEGS", "ARMS", "SHOULDERS", "CORE", "FULL BODY"];
  }

  // 2. СПИСОК КАТЕГОРИЙ
  List<String> _getCategoryList() {
    String lang = StorageService.getLanguage();
    if (lang == 'uk') return ["СИЛОВІ ТРЕНАЖЕРИ", "КАРДІО ТРЕНАЖЕРИ"];
    if (lang == 'es') return ["MÁQUINAS DE FUERZA", "CARDIO"];
    if (lang == 'de') return ["KRAFTGERÄTE", "CARDIO-GERÄTE"];
    if (lang == 'fr') return ["MACHINES DE FORCE", "CARDIO"];
    return ["STRENGTH MACHINES", "CARDIO MACHINES"];
  }

  // 3. СПИСОК УРОВНЕЙ
  List<String> _getLevelList() {
    String lang = StorageService.getLanguage();
    if (lang == 'uk') return ["ПОЧАТКІВЕЦЬ", "СЕРЕДНІЙ", "ПРОФІ"];
    if (lang == 'es') return ["PRINCIPIANTE", "INTERMEDIO", "PROFESIONAL"];
    if (lang == 'de') return ["ANFÄNGER", "FORTGESCHRITTEN", "PROFI"];
    if (lang == 'fr') return ["DÉBUTANT", "INTERMÉDIAIRE", "PROFESSIONNEL"];
    return ["BEGINNER", "INTERMEDIATE", "PRO"];
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      
      if (image != null) {
        // --- НАЧАЛО БЛОКА ЗАЩИТЫ КАРТИНКИ ---
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'artifact_${DateTime.now().millisecondsSinceEpoch}.png';
        final String permanentPath = '${directory.path}/$fileName';
        
        // Физически копируем файл из временной папки в вечную
        await File(image.path).copy(permanentPath);
        
        setState(() {
          _selectedImagePath = permanentPath; // Сохраняем вечный путь
        });
        // --- КОНЕЦ БЛОКА ЗАЩИТЫ ---
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translate(context, "gallery_error"))));
    }
  }

  @override
  Widget build(BuildContext context) {
    unit = MediaQuery.of(context).size.width / 100;

    // СИНХРОНИЗАЦИЯ (Чтобы не было ошибок при смене языка)
    if (!_getCategoryList().contains(_selectedCategory)) _selectedCategory = _getCategoryList().first;
    if (!_getMuscleList().contains(_selectedMuscle)) _selectedMuscle = _getMuscleList().first;
    if (!_getLevelList().contains(_selectedLevel)) _selectedLevel = _getLevelList().first;

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white54),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("NEW ARTIFACT", style: GoogleFonts.saira(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: gemViolet), 
            onPressed: () => _showLanguageSelector(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(unit * 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(translate(context, "artifact_name")),
            const SizedBox(height: 10),
            _buildTextField(_nameController, "e.g. Aqua Balance"),
            _buildSpacer(),

            _buildLabel(translate(context, "category")),
            const SizedBox(height: 10),
            _buildCategoryDropdown(),
            _buildSpacer(),

            _buildLabel(translate(context, "workout_defaults")),
            SizedBox(height: unit * 2),
            Row(
              children: [
                Expanded(child: _buildTextField(_setsController, "Sets", keyboardType: TextInputType.number)),
                SizedBox(width: unit * 2),
                Expanded(child: _buildTextField(_repsController, "Reps")),
                SizedBox(width: unit * 2),
                Expanded(child: _buildTextField(_restController, "Rest")),
              ],
            ),
            _buildSpacer(),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(translate(context, "muscles")),
                      SizedBox(height: unit * 2),
                      _buildMuscleDropdown(),
                    ],
                  ),
                ),
                SizedBox(width: unit * 5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel(translate(context, "level")),
                      SizedBox(height: unit * 2),
                      _buildLevelDropdown(),
                    ],
                  ),
                ),
              ],
            ),
            _buildSpacer(),

            _buildLabel(translate(context, "estimated_kcal")),
            SizedBox(height: unit * 2),
            _buildTextField(_kcalController, "5.5", keyboardType: TextInputType.number),
            _buildSpacer(),
            const Divider(color: Colors.white10),
            _buildSpacer(),

            _buildLabel(translate(context, "technical")),
            SizedBox(height: unit * 4),
            _buildInfoRow(Icons.build_circle_outlined, translate(context, "build"), _buildController),
            SizedBox(height: unit * 4),
            _buildInfoRow(Icons.fitness_center, translate(context, "technique"), _techController),
            SizedBox(height: unit * 4),
            _buildInfoRow(Icons.security, translate(context, "safety"), _safetyController),

            _buildSpacer(),
            _buildPhotoPicker(),
            SizedBox(height: unit * 10),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveButton(),
    );
  }

  // --- ВИДЖЕТЫ ИНТЕРФЕЙСА ---

  Widget _buildPhotoPicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage, 
        child: Column(
          children: [
            Container(
              width: unit * 25, height: unit * 25,
              decoration: BoxDecoration(
                color: gemGraphite, borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _selectedImagePath != null ? gemViolet : Colors.white10, width: 2),
              ),
              child: _selectedImagePath != null
                  ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(File(_selectedImagePath!), fit: BoxFit.cover))
                  : Icon(Icons.add_a_photo_outlined, color: gemViolet, size: unit * 10),
            ),
            const SizedBox(height: 10),
            Text(_selectedImagePath != null ? "IMAGE ATTACHED" : "ATTACH VISUAL DATA",
              style: GoogleFonts.saira(color: _selectedImagePath != null ? gemViolet : Colors.white24, fontSize: unit * 3.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return _buildDropdownContainer(
      DropdownButton<String>(
        value: _selectedCategory,
        isExpanded: true, dropdownColor: gemGraphite, underline: const SizedBox(),
        items: _getCategoryList().map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 11)))).toList(),
        onChanged: (v) => setState(() => _selectedCategory = v!),
      ),
    );
  }

  Widget _buildMuscleDropdown() {
    return _buildDropdownContainer(
      DropdownButton<String>(
        value: _selectedMuscle,
        isExpanded: true, dropdownColor: gemGraphite, underline: const SizedBox(),
        items: _getMuscleList().map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 12)))).toList(),
        onChanged: (v) => setState(() => _selectedMuscle = v!),
      ),
    );
  }

  Widget _buildLevelDropdown() {
    return _buildDropdownContainer(
      DropdownButton<String>(
        value: _selectedLevel,
        isExpanded: true, dropdownColor: gemGraphite, underline: const SizedBox(),
        items: _getLevelList().map((v) => DropdownMenuItem(value: v, child: Text(v, style: const TextStyle(color: Colors.white, fontSize: 12)))).toList(),
        onChanged: (v) => setState(() => _selectedLevel = v!),
      ),
    );
  }

  Widget _buildDropdownContainer(Widget child) => Container(padding: const EdgeInsets.symmetric(horizontal: 12), height: 55, decoration: BoxDecoration(color: gemGraphite, borderRadius: BorderRadius.circular(10)), child: child);

  Widget _buildLabel(String text) => Text(text, style: GoogleFonts.saira(color: gemViolet, fontWeight: FontWeight.bold, fontSize: unit * 3.8));
  Widget _buildSpacer() => SizedBox(height: unit * 6);

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller, keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true, fillColor: gemGraphite, hintText: hint, hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: unit * 10, height: unit * 10, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: gemViolet)), child: Icon(icon, color: gemViolet, size: 18)),
        SizedBox(width: unit * 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.saira(color: gemViolet, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(controller: controller, maxLines: 2, style: const TextStyle(color: Colors.white70, fontSize: 14), decoration: InputDecoration(filled: true, fillColor: gemGraphite, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.all(unit * 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: gemViolet, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () async {
          // ПРОВЕРКА: Если язык НЕ английский — не даем сохранить
          if (StorageService.getLanguage() != 'en') {
            _showSystemWarning(context);
            return;
          }
          final newArtifact = {
            'machineCode': 'LAB_${DateTime.now().millisecondsSinceEpoch}',
            'title': _nameController.text.isEmpty ? "New Artifact" : _nameController.text,
            'category': _selectedCategory,
            'targetMuscles': _selectedMuscle,
            'sets': int.tryParse(_setsController.text) ?? 3,
            'reps': _repsController.text,
            'restTime': _restController.text,
            'kcal': _kcalController.text,
            'customImage': _selectedImagePath,
            'description': _buildController.text,
            'instructions': _techController.text,
            'safety': _safetyController.text,
            'isCustom': true,
          };
          List<Map<String, dynamic>> currentList = StorageService.getCustomArtifacts();
          currentList.add(newArtifact);
          await StorageService.saveCustomArtifacts(currentList);
          if (mounted) Navigator.pop(context);
        },
        child: Text("INITIALIZE ARTIFACT", style: GoogleFonts.saira(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
      ),
    );
  }

  // --- ЛОГИКА ПЕРЕВОДА ---

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemGraphite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("CHOOSE LANGUAGE", style: GoogleFonts.saira(color: gemViolet, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption("English", "en"), // Теперь можно вернуться назад!
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
        // 1. ЗАПОМИНАЕМ ТЕКУЩИЙ ИНДЕКС ВЫБОРА (например, Кардио был вторым)
        int categoryIndex = _getCategoryList().indexOf(_selectedCategory);
        int muscleIndex = _getMuscleList().indexOf(_selectedMuscle);
        int levelIndex = _getLevelList().indexOf(_selectedLevel);

        // 2. МЕНЯЕМ ЯЗЫК
        StorageService.saveLanguage(code).then((_) {
          setState(() {
            // 3. ПОСЛЕ СМЕНЫ ЯЗЫКА ВОССТАНАВЛИВАЕМ ТЫ ЖЕ ПОЗИЦИИ
            // Теперь второй пункт в английском тоже станет Кардио
            _selectedCategory = _getCategoryList()[categoryIndex >= 0 ? categoryIndex : 0];
            _selectedMuscle = _getMuscleList()[muscleIndex >= 0 ? muscleIndex : 0];
            _selectedLevel = _getLevelList()[levelIndex >= 0 ? levelIndex : 0];
          });
          Navigator.pop(context);
        });
      },
    );
  }

  String translate(BuildContext context, String key) {
    String lang = StorageService.getLanguage();
    Map<String, Map<String, String>> values = {
      'artifact_name': {'en': 'ARTIFACT NAME', 'uk': "ІМ'Я АРТЕФАКТУ", 'es': 'NOMBRE DEL ARTEFACTO', 'de': 'ARTEFAKTNAME', 'fr': "NOM DE L'ARTEFACT"},
      'category': {'en': 'CATEGORY', 'uk': 'КАТЕГОРІЯ', 'es': 'CATEGORÍA', 'de': 'KATEGORIE', 'fr': 'CATÉGORIE'},
      'workout_defaults': {'en': 'WORKOUT DEFAULTS', 'uk': 'ПАРАМЕТРИ ТРЕНУВАННЯ', 'es': 'VALORES PREDETERMINADOS', 'de': 'TRAININGSEINSTELLUNGEN', 'fr': 'PARAMÈTRES D\'ENTRAÎNEMENT'},
      'muscles': {'en': 'TARGET MUSCLES', 'uk': 'ЦІЛЬОВІ М*ЯЗИ', 'es': 'MÚSCULOS OBJETIVO', 'de': 'ZIELMUSKELN', 'fr': 'MUSCLES CIBLÉS'},
      'level': {'en': 'LEVEL', 'uk': 'РІВЕНЬ', 'es': 'NIVEL', 'de': 'LEVEL', 'fr': 'NIVEAU'},
      'estimated_kcal': {'en': 'ESTIMATED KCAL', 'uk': 'ОЦІНКА КАЛОРІЙ', 'es': 'KCAL ESTIMADAS', 'de': 'GESCHÄTZTE KCAL', 'fr': 'KCAL ESTIMÉES'},
      'technical': {'en': 'TECHNICAL DATA', 'uk': 'ТЕХНІЧНІ ДАНІ', 'es': 'DATOS TÉCNICOS', 'de': 'TECHNISCHE DATEN', 'fr': 'DONNÉES TECHNIQUES'},
      'build': {'en': 'BUILD', 'uk': 'ЗБІРКА', 'es': 'CONSTRUCCIÓN', 'de': 'MONTAGE', 'fr': 'CONSTRUCTION'},
      'technique': {'en': 'TECHNIQUE', 'uk': 'ТЕХНІКА', 'es': 'TÉCNICA', 'de': 'TECHNIK', 'fr': 'TECHNIQUE'},
      'safety': {'en': 'SAFETY', 'uk': 'БЕЗПЕКА', 'es': 'SEGURIDAD', 'de': 'SICHERHEIT', 'fr': 'SÉCURITÉ'},
      'gallery_error': {
        'en': 'Gallery access error',
        'uk': 'Помилка доступу до галереї',
        'es': 'Error de acceso a la galería',
        'de': 'Fehler beim Zugriff auf die Galerie',
        'fr': 'Erreur d\'accès à la galerie',
      },
    };
    return values[key]?[lang] ?? values[key]?['en'] ?? key;
  }
  void _showSystemWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemGraphite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.redAccent, width: 1)),
        title: Text("SYSTEM RESTRICTION", style: GoogleFonts.saira(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        content: const Text(
          "To ensure accurate calorie calculation, all technical parameters must be saved in the system language (English). "
          "Please switch the language back to English before initializing.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("UNDERSTOOD", style: TextStyle(color: gemViolet, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}