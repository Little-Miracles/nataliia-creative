import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_body_life/screens/bio_creator_form.dart';
import 'dart:io';
import 'dart:convert'; // Для обработки ответа от базы
import 'package:http/http.dart' as http; // Для связи с интернетом
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

// Измени эту строку:
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart' as mlkit;
import 'package:smart_body_life/screens/food_category_screen.dart';

enum FrameSize { snack, meal, large }

class BioScannerScreen extends StatefulWidget {
  final File? imageFile; // <--- Добавляем лоток для фото
  const BioScannerScreen({super.key, this.imageFile, required String mealName}); // <--- Разрешаем его принимать

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

    // ЕСЛИ НАМ ПРИСЛАЛИ ФОТО ИЗ ГАЛЕРЕИ — СРАЗУ ЕГО В РАБОТУ!
    if (widget.imageFile != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _image = widget.imageFile;
        });
        _analyzeImage(widget.imageFile!); // Запуск ИИ
      });
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

  // --- ЛОГИКА СКАНИРОВАНИЯ КОДА ЧЕРЕЗ ФОТО ---
  Future<void> _scanCodeByPhoto() async {
  final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
  
  if (photo != null) {
    setState(() {
      _image = File(photo.path);
      _isAnalyzing = true;
    });

    _scanController.repeat(reverse: true);

    // --- НАСТОЯЩЕЕ РАСПОЗНАВАНИЕ ШТРИХ-КОДА С ФОТО ---
    final inputImage = InputImage.fromFile(File(photo.path));
    final barcodeScanner = mlkit.BarcodeScanner();
    
    try {
      final List<mlkit.Barcode> barcodes = await barcodeScanner.processImage(inputImage);
      
      _scanController.stop();
      setState(() { _isAnalyzing = false; });

      if (barcodes.isNotEmpty) {
        // Если нашли код на фото — берем его значение
        final String code = barcodes.first.displayValue ?? "";
        _fetchProductData(code);
      } else {
        // Если на фото нет штрих-кода
        _showAnalysisError("NO BARCODE DETECTED. Please make sure the code is clear and fits inside the frame.");
      }
    } catch (e) {
      _scanController.stop();
      setState(() { _isAnalyzing = false; });
      _showSimpleError("Scanner error: $e");
    } finally {
      barcodeScanner.close();
    }
  }
}

  // --- ПРЯМОЙ ЗАПРОС К МИРОВОЙ БАЗЕ (Open Food Facts) ---
  Future<void> _fetchProductData(String barcode) async {
  // Показываем индикатор загрузки
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(child: CircularProgressIndicator(color: Colors.amber)),
  );

  try {
    // Запрос к мировой бесплатной базе Open Food Facts
    final url = Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json');
    final response = await http.get(url);

    if (mounted) Navigator.pop(context); // Убираем загрузку

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 1) {
        // ТОВАР НАЙДЕН
        final product = data['product'];
        String name = product['product_name'] ?? "BIO-PRODUCT";
        var nutriments = product['nutriments'];
        double kcal = (nutriments['energy-kcal_100g'] ?? 0).toDouble();

        _showConfirmationSheet(context, name, kcal);
      } else {
        // ТОВАР НЕ НАЙДЕН (Твоя новая заглушка)
        _showAnalysisError(
          "REGIONAL PRODUCT. This identifier was not found in the global free database. "
          "Access to full regional databases and premium identification will be available in the next paid version."
        );
      }
    } else {
      _showSimpleError("Server error. Please try again later.");
    }
  } catch (e) {
    if (mounted) Navigator.pop(context);
    _showSimpleError("Network error: Check your internet connection.");
  }
}

  void _showSimpleError(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text), backgroundColor: Colors.redAccent));
  }

  // --- ОБНОВЛЕННЫЙ ФОТО-АНАЛИЗ (ТЕПЕРЬ С РЕАЛЬНЫМ ИИ) ---
  Future<void> _takePhoto() async {
    // 1. Делаем снимок (или выбираем из галереи)
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1080);
    
    if (photo != null) {
      final File imageFile = File(photo.path);
      
      setState(() {
        _image = imageFile;
        _isAnalyzing = true; // Включаем режим анализа
      });

      // 2. Запускаем твой золотой луч (пусть бегает, пока ИИ думает)
      _scanController.repeat(reverse: true);

      // 3. ЗАПУСКАЕМ РЕАЛЬНЫЙ АНАЛИЗ (вместо простого ожидания)
      // Мы даем лучу пробежать хотя бы 2 секунды для красоты
      await Future.delayed(const Duration(seconds: 2)); 
      
      // Вызываем наш новый метод с Google ML Kit
      await _analyzeImage(imageFile); 

      // 4. Выключаем анимацию после завершения
      _scanController.stop();
      setState(() { 
        _isAnalyzing = false; 
      });
    }
  }

// --- НОВАЯ ФУНКЦИЯ: ВЫБОР ИЗ ГАЛЕРЕИ + АНАЛИЗ ИИ ---
  Future<void> _pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1080);
    
    if (photo != null) {
      final File imageFile = File(photo.path);
      
      setState(() {
        _image = imageFile;
        _isAnalyzing = true;
      });

      // 1. Запускаем золотой луч для красоты
      _scanController.repeat(reverse: true);

      // 2. Имитируем время сканирования молекул (2 секунды)
      await Future.delayed(const Duration(seconds: 2)); 
      
      // 3. ОТПРАВЛЯЕМ ФОТО САЛАТА В НАШ ИИ
      await _analyzeImage(imageFile); 

      // 4. Останавливаем анимацию
      _scanController.stop();
      setState(() { 
        _isAnalyzing = false; 
      });
    }
  }

// --- НОВЫЙ МЕТОД: РЕАЛЬНЫЙ ИИ-АНАЛИЗ ---
Future<void> _analyzeImage(File imageFile) async {
  final inputImage = InputImage.fromFile(imageFile);
  final options = ObjectDetectorOptions(
    mode: DetectionMode.single,
    classifyObjects: true,
    multipleObjects: false,
  );
  final objectDetector = ObjectDetector(options: options);

  try {
    final List<DetectedObject> objects = await objectDetector.processImage(inputImage);

    if (objects.isEmpty) {
      _showAnalysisError("OBJECT NOT FOUND. TRY AGAIN.");
    } else {
      final firstObject = objects.first;
      if (firstObject.labels.isNotEmpty) {
        // Мы просто берем метку от ИИ (например, "Food")
        String label = firstObject.labels.first.text;
        
        // И сразу вызываем наше новое честное окно с кнопкой категорий
        // Мы больше не передаем kcal, потому что в демо-версии мы их не гадаем!
        _showResultDialogWithData(label, 0); 
      } else {
        _showAnalysisError("COULD NOT IDENTIFY. IS THIS FOOD?");
      }
    }
  } catch (e) {
    _showAnalysisError("SENSORS ERROR: $e");
  } finally {
    objectDetector.close();
  }
}

void _showAnalysisError(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF0F0505),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), 
        side: const BorderSide(color: Colors.redAccent)
      ),
      title: const Text('SCAN ERROR', style: TextStyle(color: Colors.redAccent)),
      content: Text(message, style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // 1. Закрываем само окно ошибки
            
            // --- ВОТ ОН, НАШ ТОЛЧОК НАЗАД ---
            // Если мы на симуляторе и камера выдала Error, 
            // мы возвращаем пользователя на шаг назад к выбору фото.
            if (message.contains("ERROR")) {
               setState(() {
                 _image = null;
                 _isAnalyzing = false;
               });
            }
          }, 
          child: const Text('OK', style: TextStyle(color: Colors.white))
        )
      ],
    ),
  );
}
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
            'SUCCESS! OBJECT IDENTIFIED AS FOOD.', 
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          Text(
            'This is a Demo version. The scanner identifies if it\'s food. '
            'For precise calculations, please select from your categories.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
  onPressed: () {
  Navigator.pop(context); // Закрываем диалоговое окно
  
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => FoodCategoryScreen(
        mealName: 'BIO-SCAN', // Говорим, что пришли из сканера
        imageFile: _image,    // Передаем нашу фотографию
        isFromScanner: true,  // <--- ДОБАВЛЯЕМ ЭТОТ ФЛАГ!
      ),
    ),
  );
},
  child: const Text('SELECT FROM CATEGORIES', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
),
            ),
            /*TextButton(
  onPressed: () {
    Navigator.pop(context); // Закрываем диалог
    _takePhoto();           // СРАЗУ открываем камеру снова!
  }, 
  child: const Text('RETAKE PHOTO', style: TextStyle(color: Colors.white54),
),
            )*/
          ],
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('BIO-SCANNER', style: TextStyle(color: Colors.amber, letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                children: [
                  const Text("SCANNING GUIDE", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(
                    "Fit the product inside the frame to scan. \nOr tap the [ ] icon to scan Barcode / QR-code.",
                    textAlign: TextAlign.center, 
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)
                  ),
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_image != null) Image.file(_image!),
                    
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _getFrameSize(),
                      height: _getFrameSize(),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.amber, width: 2.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    // КНОПКА SCAN CODE (ТЕПЕРЬ ЖИВАЯ)
                    Positioned(
                      top: 15,
                      right: 15,
                      child: GestureDetector(
                        onTap: _scanCodeByPhoto,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withOpacity(0.5)),
                          ),
                          child: const Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.qr_code_scanner, color: Colors.amber, size: 28),
                              SizedBox(height: 4),
                              Text("SCAN CODE", style: TextStyle(color: Colors.amber, fontSize: 8, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (_isAnalyzing)
                      AnimatedBuilder(
                        animation: _scanController,
                        builder: (context, child) {
                          return Positioned(
                            top: (MediaQuery.of(context).size.height / 2 - _getFrameSize() / 2) + (_scanController.value * _getFrameSize()),
                            child: Container(
                              width: _getFrameSize(),
                              height: 3,
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                boxShadow: [BoxShadow(color: Colors.amber, blurRadius: 10, spreadRadius: 2)],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSizeBtn(FrameSize.snack, Icons.icecream_outlined, "SNACK", "Berry/Treat"),
                      _buildSizeBtn(FrameSize.meal, Icons.restaurant, "MEAL", "Plate/Bread"),
                      _buildSizeBtn(FrameSize.large, Icons.layers, "LARGE", "Melon/Large"),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton(
    // ЕСЛИ ФОТО НЕТ — открываем камеру. ЕСЛИ ЕСТЬ — запускаем анализ (желтое окно).
    onPressed: _isAnalyzing 
      ? null 
      : (_image == null ? _takePhoto : () => _showResultDialogWithData("Food", 0)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.amber,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    child: Text(
      _isAnalyzing 
        ? 'ANALYZING...' 
        : (_image == null ? 'TAKE PHOTO' : 'IDENTIFY FOOD'), // <--- Текст меняется сам!
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)
    ),
  ),
),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildSizeBtn(FrameSize size, IconData icon, String label, String sub) {
    bool sel = _currentFrameSize == size;
    return GestureDetector(
      onTap: () {
        setState(() => _currentFrameSize = size);
        _pickFromGallery(); // <--- ТЕПЕРЬ ПРИ ВЫБОРЕ РАЗМЕРА ОТКРОЕТСЯ ГАЛЕРЕЯ!
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: sel ? Colors.amber : Colors.grey[900],
              border: Border.all(color: Colors.amber, width: 1.5),
            ),
            child: Icon(icon, color: sel ? Colors.black : Colors.amber, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(color: sel ? Colors.amber : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 9)),
        ],
      ),
    );
  }

  void _showConfirmationSheet(BuildContext context, String productName, double kcal) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF090511),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Icon(Icons.check_circle_outline, color: Colors.amber, size: 50),
              const SizedBox(height: 15),
              const Text("PRODUCT IDENTIFIED!", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              const SizedBox(height: 10),
              Text(productName.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              Text("$kcal kcal per 100g", style: const TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text("RETAKE", style: TextStyle(color: Colors.white54)))),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () {
                        Navigator.pop(context); 
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BioCreatorForm(
                              initialDishName: productName,
                              initialCalories: kcal, mealName: '',
                            ),
                          ),
                        );
                      },
                      child: const Text("ADD TO LAB", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}