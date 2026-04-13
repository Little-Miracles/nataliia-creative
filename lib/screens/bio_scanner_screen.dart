import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// Импорты: если подчеркнуты, проверь пути в VS Code
import 'bio_creator_form.dart'; 
import 'food_category_screen.dart';

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
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (widget.imageFile != null) {
      _image = widget.imageFile;
    }
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // --- ЛОГИКА КАМЕРЫ ---
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
        _isAnalyzing = true;
      });
      _scanController.repeat(reverse: true);

      // Имитируем "Золотой луч" и облачный анализ
      await Future.delayed(const Duration(seconds: 3));
      
      _scanController.stop();
      setState(() => _isAnalyzing = false);

      // Показываем окно РЕЗУЛЬТАТА (где есть переход в Категории)
      _showResultDialogWithData("BIO-PRODUCT", 0);
    }
  }

  // --- ТО САМОЕ ОКНО С ПЕРЕХОДОМ В КАТЕГОРИИ (как в твоем файле) ---
  void _showResultDialogWithData(String label, int kcal) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
          side: const BorderSide(color: Colors.amber, width: 1)
        ),
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.amber),
            SizedBox(width: 10),
            Text('BIO-DETECTION', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'SUCCESS! OBJECT IDENTIFIED.', 
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Text(
              'For precise calculations, please select from your categories or add to Laboratory.',
              style: TextStyle(color: Colors.white70, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          Column(
            children: [
              // КНОПКА №1: В КАТЕГОРИИ (Фуд-категории)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodCategoryScreen(
                          mealName: widget.mealName,
                          imageFile: _image,
                          isFromScanner: true,
                        ),
                      ),
                    );
                  },
                  child: const Text('SELECT FROM CATEGORIES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 8),
              // КНОПКА №2: В ЛАБОРАТОРИЮ (Конструктор блюда)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.amber)),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BioCreatorForm(
                          initialDishName: label,
                          initialCalories: kcal.toDouble(),
                          mealName: widget.mealName,
                          imageFile: _image,
                        ),
                      ),
                    );
                  },
                  child: const Text('ADD TO LABORATORY', style: TextStyle(color: Colors.amber)),
                ),
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
      appBar: AppBar(
        title: const Text('BIO-SCANNER', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (_image != null) Positioned.fill(child: Image.file(_image!, fit: BoxFit.cover)),
                
                // Рамка сканера
                Container(
                  width: 280, height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),

                // ЗОЛОТОЙ ЛУЧ
                if (_isAnalyzing)
                  AnimatedBuilder(
                    animation: _scanController,
                    builder: (context, child) {
                      return Positioned(
                        top: (MediaQuery.of(context).size.height / 3.5) + (_scanController.value * 280),
                        child: Container(
                          width: 260, height: 3,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 15, spreadRadius: 2)],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _takePhoto,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(
                _isAnalyzing ? "ANALYZING..." : "TAKE PHOTO",
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}