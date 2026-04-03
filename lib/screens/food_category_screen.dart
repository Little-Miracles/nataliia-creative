import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_body_life/screens/basics_screen.dart';
import 'package:smart_body_life/screens/bio_creator_form.dart';
import 'package:smart_body_life/screens/drinks_screen.dart';
import 'package:smart_body_life/screens/functional_screen.dart';
import 'package:smart_body_life/screens/main_dishes_screen.dart';
import 'package:smart_body_life/screens/salads_screen.dart';
import 'package:smart_body_life/screens/snacks_screen.dart';
import 'package:smart_body_life/screens/soups_screen.dart';
import 'package:smart_body_life/screens/vitamins_screen.dart';

class FoodCategoryScreen extends StatelessWidget {
  final String mealName;
  final File? imageFile;
  final bool isFromScanner; // <--- 1. ДОБАВИЛИ ФЛАГ

  const FoodCategoryScreen({
    super.key, 
    required this.mealName, 
    this.imageFile,
    this.isFromScanner = false, // <--- 2. ПО УМОЛЧАНИЮ FALSE
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // 3. СОЗДАЕМ СПИСОК ВСЕХ КНОПОК
    final List<Map<String, dynamic>> allCards = [
      {'title': 'BASICS', 'icon': Icons.bakery_dining_outlined, 'type': 'gold', 'page': BasicsScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'FIRST COURSES', 'icon': Icons.soup_kitchen_outlined, 'type': 'gold', 'page': SoupsScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'MAIN DISHES', 'icon': Icons.dinner_dining, 'type': 'amber', 'page': MainDishesScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'SALADS', 'icon': Icons.eco, 'type': 'emerald', 'page': SaladsScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'DRINKS', 'icon': Icons.local_cafe_outlined, 'type': 'sapphire', 'page': DrinksScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'SNACKS', 'icon': Icons.lunch_dining, 'type': 'gold', 'page': SnacksScreen(mealName: mealName, imageFile: imageFile)},
      // ЭТИ ДВЕ БУДУТ СКРЫТЫ ПРИ СКАНЕРЕ
      {'title': 'VITAMINS', 'icon': Icons.stars, 'type': 'amber', 'page': VitaminsScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'MY AUTHORS DISHES', 'icon': Icons.collections_bookmark_outlined, 'type': 'emerald', 'page': FunctionalScreen(mealName: mealName, imageFile: imageFile)},
      {'title': 'BIO-FOOD DESIGNER', 'icon': Icons.blur_on_outlined, 'type': 'amethyst', 'page': BioCreatorForm(mealName: mealName, imageFile: imageFile)},
      {'title': 'COMING SOON', 'icon': Icons.lock_outline, 'type': 'teal', 'page': null},
    ];

    // 4. ФИЛЬТРУЕМ: если со сканера - убираем Vitamins (индекс 6) и Coming Soon (индекс 9)
    // Или просто берем первые 8, если тебе так удобнее
    final displayCards = isFromScanner 
        ? allCards.where((card) => card['title'] != 'VITAMINS' && card['title'] != 'COMING SOON').toList()
        : allCards;

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          mealName.toUpperCase(),
          style: const TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.w900, letterSpacing: 4, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder( // Используем builder для красоты
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: screenWidth * 0.03,
            crossAxisSpacing: screenWidth * 0.03,
            childAspectRatio: 1.25,
          ),
          itemCount: displayCards.length,
          itemBuilder: (context, index) {
            final card = displayCards[index];
            return _buildCard(
              context, 
              card['title'], 
              card['icon'], 
              card['type'], 
              () {
                if (card['page'] != null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => card['page']));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This section is under development!')),
                  );
                }
              }, 
              screenWidth
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String type, VoidCallback onTap, double screenWidth) {
    // ... Твой код метода _buildCard остается без изменений ...
    // (Градиенты, тени, Stack с бликом — всё как у тебя в оригинале)
    final Map<String, List<Color>> gradients = {
      'gold':     [const Color(0xFFC9A817), const Color(0xFF3D2D05)],
      'amber':    [const Color(0xFF7B4A2B), const Color(0xFF1A110A)],
      'emerald':  [const Color(0xFF2E8B57), const Color(0xFF011F0F)],
      'sapphire': [const Color(0xFF2B55CC), const Color(0xFF040A2A)],
      'amethyst': [const Color(0xFF6B3A8A), const Color(0xFF0E041A)],
      'teal':     [const Color(0xFF2AADA8), const Color(0xFF021F20)],
    };

    final Map<String, Color> shadowColors = {
      'gold':     const Color(0x40B48C00),
      'amber':    const Color(0x40783C1E),
      'emerald':  const Color(0x402E8B57),
      'sapphire': [const Color(0xFF2B55CC), const Color(0xFF040A2A)][0], // для краткости
      'amethyst': const Color(0x406B3A8A),
      'teal':     const Color(0x402AADA8),
    };

    final colors = gradients[type]!;
    final shadowColor = shadowColors[type] ?? Colors.black45;
    const contentColor = Color(0xFFEDE6D6);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.07), width: 1),
          // --- ВОТ ТУТ МЫ ВКЛЮЧАЕМ ПОДСВЕТКУ НА ПОЛНУЮ ---
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.6), // Увеличил яркость с 0.4 до 0.6
              blurRadius: 25,                      // Сделал свечение шире (было 15)
              spreadRadius: 2,                     // Немного растянул свет
              offset: const Offset(0, 0),          // Центрируем, чтобы сияло во все стороны
            ),
            // Внутренняя тень для объема самой кнопки
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0, left: 0,
              child: Container(
                width: screenWidth * 0.3, height: screenWidth * 0.2,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(16)),
                  gradient: RadialGradient(center: const Alignment(-0.6, -0.6), radius: 1.0, colors: [Colors.white.withOpacity(0.1), Colors.transparent]),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: contentColor, size: screenWidth * 0.085, shadows: [Shadow(color: Colors.black.withOpacity(0.5), blurRadius: 6)]),
                    SizedBox(height: screenWidth * 0.02),
                    Text(title, textAlign: TextAlign.center,
                      style: TextStyle(color: contentColor, fontSize: screenWidth * 0.024, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}