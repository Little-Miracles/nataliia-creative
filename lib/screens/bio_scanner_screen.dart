import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// Импорты (проверь, чтобы не были желтыми)
import 'bio_creator_form.dart'; 
import 'food_category_screen.dart';

enum FrameSize { snack, meal, large }

class BioScannerScreen extends StatefulWidget {
  final File? imageFile;
  final String mealName;

  const BioScannerScreen({super.key, this.imageFile, required this.mealName});

  @override
  _BioScannerScreenState createState() => _BioScannerScreenState();
}

class _BioScannerScreenState extends State<BioScannerScreen> with SingleTickerProviderStateMixin {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isAnalyzing = false;
  FrameSize _currentFrameSize = FrameSize.meal; 
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    
    // Если пришли из галереи (или с готовым фото)
    if (widget.imageFile != null) {
      _image = widget.imageFile;
      // Включаем луч СРАЗУ, как вчера!
      _startAutoAnalysis(widget.imageFile!);
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  double _getFrameSize() {
    switch (_currentFrameSize) {
      case FrameSize.snack: return 180.0;
      case FrameSize.meal: return 270.0;
      case FrameSize.large: return 350.0;
    }
  }

  // --- ТОТ САМЫЙ ЗАПУСК АНАЛИЗА (как вчера) ---
  Future<void> _startAutoAnalysis(File file) async {
    setState(() {
      _image = file;
      _isAnalyzing = true;
    });
    _scanController.repeat(reverse: true); // Золотой луч погнал!

    await Future.delayed(const Duration(seconds: 3)); // Время на "магию"
    
    _scanController.stop();
    setState(() => _isAnalyzing = false);
    _showResultDialogWithData("IDENTIFIED PRODUCT", 0);
  }

  // --- КАМЕРА ---
  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
      if (photo != null) {
        _startAutoAnalysis(File(photo.path));
      }
    } catch (e) {
      // Если симулятор ругается на камеру, даем шанс выбрать из галереи
      _showSimpleError("Camera not available. Try Gallery below.");
    }
  }

  // --- ГАЛЕРЕЯ (нажатие на размер) ---
  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1080);
    if (photo != null) {
      _startAutoAnalysis(File(photo.path));
    }
  }

  void _showSimpleError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // --- ОКНО РЕЗУЛЬТАТА (связь с Категориями и Лабораторией) ---
  void _showResultDialogWithData(String label, int kcal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.amber)),
        title: const Text('BIO-DETECTION', style: TextStyle(color: Colors.amber)),
        content: const Text('Object Identified! Choose your next step:', style: TextStyle(color: Colors.white70)),
        actions: [
          Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 45)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FoodCategoryScreen(
                    mealName: widget.mealName, imageFile: _image, isFromScanner: true,
                  )));
                },
                child: const Text('SELECT CATEGORY', style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.amber), minimumSize: const Size(double.infinity, 45)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BioCreatorForm(
                    initialDishName: label, initialCalories: kcal.toDouble(), mealName: widget.mealName, imageFile: _image,
                  )));
                },
                child: const Text('ADD TO LAB', style: TextStyle(color: Colors.amber)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('BIO-SCANNER', style: TextStyle(color: Colors.amber)), backgroundColor: Colors.black),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_image != null) Positioned.fill(child: Image.file(_image!, fit: BoxFit.cover)),
                
                // Рамка
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _getFrameSize(), height: _getFrameSize(),
                  decoration: BoxDecoration(border: Border.all(color: Colors.amber, width: 2), borderRadius: BorderRadius.circular(20)),
                ),

                // ЛУЧ
                if (_isAnalyzing)
                  AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return Positioned(
                        top: (MediaQuery.of(context).size.height / 3.8) + (_scanController.value * _getFrameSize()),
                        child: Container(width: _getFrameSize(), height: 3, decoration: const BoxDecoration(color: Colors.amber, boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 10)])),
                      );
                    },
                  ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSizeBtn(FrameSize.snack, Icons.icecream_outlined, "SNACK"),
                    _buildSizeBtn(FrameSize.meal, Icons.restaurant, "MEAL"),
                    _buildSizeBtn(FrameSize.large, Icons.layers, "LARGE"),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isAnalyzing ? null : _takePhoto,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 60)),
                  child: Text(_isAnalyzing ? "ANALYZING..." : "TAKE PHOTO", style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeBtn(FrameSize size, IconData icon, String label) {
    bool sel = _currentFrameSize == size;
    return GestureDetector(
      onTap: () {
        setState(() => _currentFrameSize = size);
        _pickFromGallery();
      },
      child: Column(
        children: [
          CircleAvatar(backgroundColor: sel ? Colors.amber : Colors.grey[900], child: Icon(icon, color: sel ? Colors.black : Colors.amber)),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: sel ? Colors.amber : Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}