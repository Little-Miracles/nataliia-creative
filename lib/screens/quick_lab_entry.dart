import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';

class QuickLabEntry extends StatefulWidget {
  final File? initialImage; // Добавляем возможность принять фото
  const QuickLabEntry({super.key, this.initialImage});

  @override
  State<QuickLabEntry> createState() => _QuickLabEntryState();
}

class _QuickLabEntryState extends State<QuickLabEntry> {

  @override
void initState() {
  super.initState();
  _selectedImage = widget.initialImage; // Если фото передали — оно сразу появится
}

  final Color deepPurpleBg = const Color(0xFF090511);
  final Color gold = const Color(0xFFC0A060);
  final Color accentPurple = const Color(0xFF7E4AAF);
  
  File? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _kcalController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepPurpleBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('QUICK LAB', style: TextStyle(color: gold, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close, color: gold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Твой любимый "Листик" для фото
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: _selectedImage == null ? 2 : 160,
                decoration: BoxDecoration(
                  color: gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: gold.withOpacity(0.3)),
                ),
                child: _selectedImage != null 
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    )
                  : const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Минимальные поля ввода
            _simpleInput("What are we analyzing?", _nameController),
            const SizedBox(height: 15),
            _simpleInput("Approx. Calories", _kcalController, isNum: true),
            
            const SizedBox(height: 40),
            
            // Золотая кнопка "В ЛАБОРАТОРИЮ"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: gold,
                foregroundColor: deepPurpleBg,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
  if (_nameController.text.isEmpty) return;

  final metrics = Provider.of<MetricsProvider>(context, listen: false);
  
  // Отправляем данные на "8 кнопок"
  metrics.addMealData(
    mealName: "QUICK LAB", // Или передавай нужную категорию
    foodName: _nameController.text,
    kcal: double.tryParse(_kcalController.text) ?? 0,
    p: 0, f: 0, c: 0, // В быстрой записи можем оставить нули или добавить поля
    imagePath: _selectedImage?.path,
  );

  Navigator.pop(context); // Возвращаемся к монитору
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Analysis sent to Monitor!")),
  );
}, 
              child: const Text("SEND TO MONITOR", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _simpleInput(String label, TextEditingController controller, {bool isNum = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: gold.withOpacity(0.7)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold.withOpacity(0.3))),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold)),
      ),
    );
  }
}