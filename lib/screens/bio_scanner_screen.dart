import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path; // Добавила для правильных путей
import 'package:smart_body_life/screens/food_category_screen.dart';
import 'package:smart_body_life/screens/bio_creator_form.dart';

enum FrameSize { snack, meal, large }

class BioScannerScreen extends StatefulWidget {
  final File? imageFile;
  final String mealName; // Добавила обратно аргумент, чтобы не было ошибок

  const BioScannerScreen({super.key, this.imageFile, required this.mealName});

  @override
  _BioScannerScreenState createState() => _BioScannerScreenState();
}

class _BioScannerScreenState extends State<BioScannerScreen> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  int _dailyScanLimit = 5;
  int _currentScans = 0;
  FrameSize _currentFrameSize = FrameSize.meal;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    if (widget.imageFile != null) {
      _image = widget.imageFile;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _processBioDetection(_image!);
      });
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // --- ЛОГИКА BIO-DETECTION ---
  Future<void> _processBioDetection(File imageFile) async {
    if (_currentScans >= _dailyScanLimit) {
      _showSimpleError("SCANNER ENERGY DEPLETED. RESTORES TOMORROW.");
      return;
    }

    setState(() => _isAnalyzing = true);
    _scanController.repeat(reverse: true);

    // 1. ПРОВЕРКА СВЯЗИ
    bool isOnline = await _checkConnectivity();
    if (!isOnline) {
      await _backupImageLocally(imageFile);
      _stopAnalysis();
      _showStatusDialog(
        title: "OFFLINE MODE",
        message: "Network unstable. Image saved to SmartBodyScan. You can process it later.",
        isError: true
      );
      return;
    }

    try {
      // 2. ОБЛАЧНАЯ ИДЕНТИФИКАЦИЯ (GEMINI)
      const String apiKey = "YOUR_API_KEY_HERE"; // Вставь свой ключ!
      final String cloudUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
      
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse(cloudUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [
              {"text": "Identify only the main food item in this image. Return one word or a short phrase in English."},
              {"inline_data": {"mime_type": "image/jpeg", "data": base64Image}}
            ]
          }]
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        String detectedLabel = result['candidates'][0]['content']['parts'][0]['text']?.trim() ?? "Unknown Food";
        
        _stopAnalysis();
        if (mounted) setState(() => _currentScans++);
        _handleIdentificationResult(detectedLabel);
      } else {
        throw Exception("Cloud error");
      }
    } catch (e) {
      _stopAnalysis();
      _showStatusDialog(
        title: "SENSORS FAILURE",
        message: "Cloud identification failed. Using local sensors.",
        isError: true
      );
    }
  }

  void _handleIdentificationResult(String label) {
    _showResultDialog(label: label, inLibrary: false);
  }

  // --- UI ДИАЛОГИ ---
  void _showResultDialog({required String label, required bool inLibrary}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.amber)),
        title: Text(label.toUpperCase(), style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        content: const Text(
          "NOT FOUND IN YOUR LOCAL DATABASE. USE GLOBAL DATA OR SELECT CATEGORY?",
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _fetchGlobalNutrition(label);
            },
            child: const Text("GLOBAL DATA", style: TextStyle(color: Colors.blueAccent)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            onPressed: () {
              Navigator.pop(context);
              _navigateToCategories(label);
            },
            child: const Text("CATEGORIES", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchGlobalNutrition(String label) async {
    final url = Uri.parse("https://world.openfoodfacts.org/cgi/search.pl?search_terms=$label&json=1");
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      double kcal = 0.0;
      if (data['products'] != null && data['products'].isNotEmpty) {
        kcal = (data['products'][0]['nutriments']?['energy-kcal_100g'] ?? 0.0).toDouble();
      }
      _navigateToCreator(label, kcal);
    } catch (_) {
      _navigateToCreator(label, 0.0);
    }
  }

  // --- НАВИГАЦИЯ ---
  void _navigateToCategories(String label) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FoodCategoryScreen(
      mealName: widget.mealName, // Используем mealName из виджета
      imageFile: _image,
      isFromScanner: true,
    )));
  }

  void _navigateToCreator(String name, double kcal) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => BioCreatorForm(
      initialDishName: name,
      initialCalories: kcal,
      mealName: widget.mealName,
      imageFile: _image,
    )));
  }

  // --- УТИЛИТЫ (Исправлено для iOS) ---
  Future<bool> _checkConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://google.com')).timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) { return false; }
  }

  Future<void> _backupImageLocally(File file) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      // Используем path.join для надежности путей на iOS
      final String fileName = "pending_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final String savedPath = path.join(dir.path, fileName);
      await file.copy(savedPath);
    } catch (e) {
      debugPrint("Save error: $e");
    }
  }

  void _stopAnalysis() {
    _scanController.stop();
    if (mounted) setState(() => _isAnalyzing = false);
  }

  void _showStatusDialog({required String title, required String message, bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F0505),
        title: Text(title, style: TextStyle(color: isError ? Colors.redAccent : Colors.amber)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      ),
    );
  }

  void _showSimpleError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: Colors.redAccent));
  }

  // --- КНОПКИ ---
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
    if (photo != null) {
      setState(() => _image = File(photo.path));
      _processBioDetection(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1080);
    if (photo != null) {
      setState(() => _image = File(photo.path));
      _processBioDetection(File(photo.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    double frameSize = _currentFrameSize == FrameSize.snack ? 180.0 : _currentFrameSize == FrameSize.meal ? 270.0 : 350.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BIO-SCANNER', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black, centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_image != null) ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(_image!)),
                    // Рамка
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: frameSize, height: frameSize,
                      decoration: BoxDecoration(border: Border.all(color: Colors.amber, width: 2), borderRadius: BorderRadius.circular(20)),
                    ),
                    // Луч
                    if (_isAnalyzing)
                      AnimatedBuilder(
                        animation: _scanController,
                        builder: (context, child) {
                          return Positioned(
                            top: (MediaQuery.of(context).size.height / 4.5) + (_scanController.value * frameSize),
                            child: Container(width: frameSize, height: 2, decoration: const BoxDecoration(color: Colors.amber, boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 10)])),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            _buildControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sizeOption(FrameSize.snack, Icons.icecream_outlined, "SNACK"),
              _sizeOption(FrameSize.meal, Icons.restaurant, "MEAL"),
              _sizeOption(FrameSize.large, Icons.layers, "LARGE"),
            ],
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity, height: 60,
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : (_image == null ? _takePhoto : () => _processBioDetection(_image!)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
              child: Text(
                _isAnalyzing ? 'ANALYZING...' : (_image == null ? 'START SCAN' : 'RE-SCAN'),
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TextButton(onPressed: _pickFromGallery, child: const Text("IMPORT FROM GALLERY", style: TextStyle(color: Colors.white38, fontSize: 10))),
        ],
      ),
    );
  }

  Widget _sizeOption(FrameSize size, IconData icon, String label) {
    bool sel = _currentFrameSize == size;
    return GestureDetector(
      onTap: () => setState(() => _currentFrameSize = size),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: sel ? Colors.amber : Colors.grey[900], radius: 25, child: Icon(icon, color: sel ? Colors.black : Colors.amber)),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: sel ? Colors.amber : Colors.white38, fontSize: 10)),
        ],
      ),
    );
  }
}