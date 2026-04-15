import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_body_life/screens/functional_screen.dart';
import 'package:smart_body_life/data/global_data.dart'; 
import 'dart:io'; // <--- ОБЯЗАТЕЛЬНО добавь этот импорт в самый верх

class BioCreatorForm extends StatefulWidget {
  final String? initialDishName;
  final double? initialCalories;
  final File? imageFile; // Оставь одну эту строчку
  final double? initialProtein;
  final double? initialFat;
  final double? initialCarbs;
  final String mealName;

  // Обнови конструктор, чтобы он выглядел аккуратно:
  const BioCreatorForm({
    super.key,
    this.initialDishName,
    this.initialCalories,
    this.imageFile,
    this.initialProtein,
    this.initialFat,
    this.initialCarbs,
    required this.mealName,
  });
  
  @override
  State<BioCreatorForm> createState() => _BioCreatorFormState();
}

class _BioCreatorFormState extends State<BioCreatorForm> {
  late TextEditingController _nameController;
  late TextEditingController _caloriesController;
  
  // Контроллеры для всех полей
  late TextEditingController _proteinsController;
  late TextEditingController _fatsController;
  late TextEditingController _carbsController;
  late TextEditingController _sugarController;
  late TextEditingController _potassiumController;
  late TextEditingController _magnesiumController;
  late TextEditingController _calciumController;
  late TextEditingController _zincController;
  late TextEditingController _vitCController;
  late TextEditingController _vitDController;
  late TextEditingController _vitB12Controller;

  File? _selectedImage;

  final Color deepPurpleBg = const Color(0xFF090511);
  final Color gold = const Color(0xFFC0A060);
  final Color accentPurple = const Color(0xFF7E4AAF);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialDishName ?? '');
    _caloriesController = TextEditingController(text: widget.initialCalories?.toInt().toString() ?? '');
// Теперь подставляем данные из Сканера в твои контроллеры:
  _proteinsController = TextEditingController(text: widget.initialProtein?.toString() ?? '');
  _fatsController = TextEditingController(text: widget.initialFat?.toString() ?? '');
  _carbsController = TextEditingController(text: widget.initialCarbs?.toString() ?? '');


    //_proteinsController = TextEditingController();
    // _fatsController = TextEditingController();
    // _carbsController = TextEditingController();
    _sugarController = TextEditingController();
    _potassiumController = TextEditingController();
    _magnesiumController = TextEditingController();
    _calciumController = TextEditingController();
    _zincController = TextEditingController();
    _vitCController = TextEditingController();
    _vitDController = TextEditingController();
    _vitB12Controller = TextEditingController();
    // Если сканер прислал фото, сразу кладем его в нашу "коробочку" для отображения
    if (widget.imageFile != null) {
      _selectedImage = widget.imageFile;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _proteinsController.dispose();
    _fatsController.dispose();
    _carbsController.dispose();
    _sugarController.dispose();
    _potassiumController.dispose();
    _magnesiumController.dispose();
    _calciumController.dispose();
    _zincController.dispose();
    _vitCController.dispose();
    _vitDController.dispose();
    _vitB12Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: deepPurpleBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('BIO-FOOD DESIGNER', 
          style: TextStyle(color: gold, letterSpacing: 2, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.close, color: gold), 
          onPressed: () => Navigator.pop(context),
        ),

        // ДОБАВЛЯЕМ ВОТ ЭТО:
  actions: [
  IconButton(
    icon: Icon(Icons.add_photo_alternate_outlined, color: gold, size: 28),
    onPressed: _pickImage, // То же самое имя
  ),
],
      ),
      
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [accentPurple.withAlpha(25), deepPurpleBg],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- НАЧАЛО НАШЕГО "ЛИСТИКА" ---
              GestureDetector(
                onTap: _pickImage, // Короткое и ясное имя для функции, которая открывает галерею
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  // Если фото нет, это просто тонкая нить (2 пикселя), если есть — окно 160
                  height: _selectedImage == null ? 2 : 160, 
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: gold.withOpacity(0.3), width: 1),
                  ),
                  child: _selectedImage != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.file(_selectedImage!, fit: BoxFit.cover),
                      )
                    : const SizedBox.shrink(),
                ),
              ),
              // --- КОНЕЦ ЛИСТИКА ---

              _sectionTitle("MAIN INFO"),
              _buildInput("Dish Name", "Name", Icons.edit_note, isFullWidth: true, controller: _nameController),
              _buildInput("Total Calories (kcal)", "0", Icons.bolt, isFullWidth: true, controller: _caloriesController),
              
              const SizedBox(height: 20),
              // ... дальше твой код без изменений ...
              _sectionTitle("MACROS (BJU)"),
              _buildTripleRow(["Proteins", "Fats", "Carbs"], ["0g", "0g", "0g"], [_proteinsController, _fatsController, _carbsController]),
              _buildInput("Sugar Content", "0g", Icons.icecream_outlined, isFullWidth: true, controller: _sugarController),

              const SizedBox(height: 20),
              _sectionTitle("MINERALS"),
              _buildTripleRow(["Potassium", "Magnesium", "Calcium"], ["mg", "mg", "mg"], [_potassiumController, _magnesiumController, _calciumController]),
              _buildInput("Zinc (Zn)", "mg", Icons.verified_user_outlined, isFullWidth: true, controller: _zincController),

              const SizedBox(height: 20),
              _sectionTitle("VITAMINS"),
              _buildTripleRow(["Vit C", "Vit D", "Vit B12"], ["mg", "mcg", "mcg"], [_vitCController, _vitDController, _vitB12Controller]),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: gold, width: 1.5),
                    ),
                  ),
                  onPressed: () {
                    if (_nameController.text.isEmpty) return;

                    globalLibrary.add(
                      LibraryProduct(
                        name: _nameController.text,
                        calories: _caloriesController.text.isEmpty ? "0" : _caloriesController.text,
                        imagePath: _selectedImage?.path, // Теперь путь к супу попадет в базу
                         desc: "Handmade Dish",
                        proteins: _proteinsController.text.isEmpty ? "0" : _proteinsController.text,
                        fats: _fatsController.text.isEmpty ? "0" : _fatsController.text,
                        carbs: _carbsController.text.isEmpty ? "0" : _carbsController.text,
                        sugar: _sugarController.text.isEmpty ? "0" : _sugarController.text,
                        potassium: _potassiumController.text.isEmpty ? "0" : _potassiumController.text,
                        magnesium: _magnesiumController.text.isEmpty ? "0" : _magnesiumController.text,
                        calcium: _calciumController.text.isEmpty ? "0" : _calciumController.text,
                        zinc: _zincController.text.isEmpty ? "0" : _zincController.text,
                        vitC: _vitCController.text.isEmpty ? "0" : _vitCController.text,
                        vitD: _vitDController.text.isEmpty ? "0" : _vitDController.text,
                        vitB12: _vitB12Controller.text.isEmpty ? "0" : _vitB12Controller.text,
                      ),
                    );

                    // Возвращаемся в меню и открываем Библиотеку
                    Navigator.pop(context); 
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => FunctionalScreen(mealName: _nameController.text)),
                    );
                  },
                  child: Text("SAVE TO LIBRARY", 
                    style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    )
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 10),
      child: Text(title, style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.5)),
    );
  }

  // ОБНОВЛЕННЫЙ МЕТОД: теперь принимает список контроллеров
  Widget _buildTripleRow(List<String> labels, List<String> hints, List<TextEditingController> controllers) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: _buildInput(labels[0], hints[0], null, isFullWidth: false, controller: controllers[0])),
          const SizedBox(width: 8),
          Expanded(child: _buildInput(labels[1], hints[1], null, isFullWidth: false, controller: controllers[1])),
          const SizedBox(width: 8),
          Expanded(child: _buildInput(labels[2], hints[2], null, isFullWidth: false, controller: controllers[2])),
        ],
      ),
    );
  }

  Widget _buildInput(String label, String hint, IconData? icon, {required bool isFullWidth, TextEditingController? controller}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isFullWidth ? 12 : 0),
      child: TextField(
        controller: controller,
        keyboardType: label == "Dish Name" ? TextInputType.text : TextInputType.number,
        style: const TextStyle(color: Colors.white, fontSize: 13),
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: gold, size: 18) : null,
          labelText: label,
          labelStyle: TextStyle(color: gold.withAlpha(153), fontSize: 12),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white10),
          filled: true,
          fillColor: Colors.transparent,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: gold.withAlpha(77), width: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: gold, width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
        ),
      ),
    );
  }
  // Функция для выбора картинки из галереи
/*Future<void> _pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  // Открываем галерею
  final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      // Это ВАЖНО: мы обновляем экран, и теперь widget.imageFile 
      // (или твоя локальная переменная) получает это фото!
      // Но так как widget.imageFile менять нельзя, нам нужна локальная переменная.
    });
  }
}*/
// ВСТАВЬ ЭТУ ФУНКЦИЮ В КОНЕЦ КЛАССА:
Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    setState(() {
      _selectedImage = File(image.path); // Наполняем нашу "коробочку"
    });
  }
}
}