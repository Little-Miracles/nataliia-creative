import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/global_data.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/full_screen_image.dart';
import 'package:smart_body_life/screens/functional_screen.dart';

// 1. Модель данных (обязательно вне класса)
class FoodItem {
  final String name;
  final String desc;
  final String category;
  final double kcal100g;
  final double proteins;
  final double fats;
  final double carbs;
  final String? imageUrl; // Добавили вот это (со знаком вопроса)

  FoodItem({
    required this.name,
    required this.desc,
    required this.category,
    required this.kcal100g,
    required this.proteins,
    required this.fats,
    required this.carbs,
    this.imageUrl, // И вот это в конструктор
  });
}

// 2. Цвета выносим сюда, чтобы они не ругались на const
const Color mustardGold = Color(0xFFC0A060);
const Color brightGold = Color(0xFFE3C818);
const Color goldShadow = Color(0xFF574509);
const Color darkEmerald = Color(0xFF003D26);

class SoupsScreen extends StatefulWidget {
  final String mealName;
  final File? imageFile; // <--- ДОБАВЛЯЕМ ЭТУ СРОЧКУ (не забудь импорт dart:io в самом верху!)
  const SoupsScreen({super.key, required this.mealName, this.imageFile}); // <--- ОБНОВЛЯЕМ КОНСТРУКТОР

  @override
  State<SoupsScreen> createState() => _SoupsScreenState();
}

class _SoupsScreenState extends State<SoupsScreen> {
  final List<String> categories = ['ALL', 'MEAT', 'POULTRY', 'FISH', 'VEGETABLE', 'CREAM'];
  String selectedCat = 'ALL';

  // База данных
  final List<FoodItem> soupDatabase = [
    FoodItem(
    name: 'Classic Borscht',
    desc: 'beef, beets, cabbage, potatoes, carrots, onion, tomato paste',
    category: 'MEAT',
    kcal100g: 65,
    proteins: 3.5,
    fats: 4.2,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/1.png'), // Прописали путь!

  FoodItem(
    name: 'Beef Solyanka',
    desc: 'beef, sausages, pickles, olives, onion, tomato paste',
    category: 'MEAT',
    kcal100g: 95,
    proteins: 6.5,
    fats: 7.5,
    carbs: 3.0,
    imageUrl: 'assets/images/soups/2.png'), // Прописали путь!


  FoodItem(
    name: 'Beef Kharcho',
    desc: 'beef, rice, tomato, garlic, herbs, spices',
    category: 'MEAT',
    kcal100g: 75,
    proteins: 5.5,
    fats: 4.5,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/3.png'), // Прописали путь!


  FoodItem(
    name: 'Shurpa',
    desc: 'lamb, potatoes, carrots, onion, herbs, spices',
    category: 'MEAT',
    kcal100g: 85,
    proteins: 6.0,
    fats: 5.5,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/4.png'), // Прописали путь!


  FoodItem(
    name: 'Meatball Soup',
    desc: 'beef meatballs, potatoes, carrots, onion, herbs, broth',
    category: 'MEAT',
    kcal100g: 70,
    proteins: 5.0,
    fats: 4.0,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/5.png'), // Прописали путь!


  FoodItem(
    name: 'Chicken Noodle',
    desc: 'chicken, noodles, carrots, onion, celery, broth',
    category: 'POULTRY',
    kcal100g: 50,
    proteins: 4.0,
    fats: 2.5,
    carbs: 5.0,
    imageUrl: 'assets/images/soups/6.png'), // Прописали путь!


  FoodItem(
    name: 'Turkey Soup',
    desc: 'turkey, rice, carrots, celery, onion, broth',
    category: 'POULTRY',
    kcal100g: 48,
    proteins: 4.5,
    fats: 1.8,
    carbs: 4.0,
    imageUrl: 'assets/images/soups/7.png'), // Прописали путь! 


  FoodItem(
    name: 'Chicken Rice Soup',
    desc: 'chicken, rice, carrots, onion, celery, broth',
    category: 'POULTRY',
    kcal100g: 52,
    proteins: 4.2,
    fats: 2.2,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/8.png'), // Прописали путь!

  FoodItem(
    name: 'Duck Soup',
    desc: 'duck, noodles, onion, garlic, herbs, broth',
    category: 'POULTRY',
    kcal100g: 80,
    proteins: 6.5,
    fats: 5.0,
    carbs: 4.5,
    imageUrl: 'assets/images/soups/9.png'), // Прописали путь!
  

  FoodItem(
    name: 'Fish Ukha',
    desc: 'salmon, potatoes, onion, carrots, herbs, broth',
    category: 'FISH',
    kcal100g: 55,
    proteins: 5.5,
    fats: 3.0,
    carbs: 4.2,
    imageUrl: 'assets/images/soups/10.png'), // Прописали путь!
  

  FoodItem(
    name: 'Salmon Soup',
    desc: 'salmon, potatoes, carrots, onion, cream, broth',
    category: 'FISH',
    kcal100g: 78,
    proteins: 6.0,
    fats: 5.0,
    carbs: 4.0,
    imageUrl: 'assets/images/soups/11.png'
  ),

  FoodItem(
    name: 'Bouillabaisse',
    desc: 'fish, seafood, tomato, garlic, herbs, broth',
    category: 'SEAFOOD',
    kcal100g: 70,
    proteins: 6.5,
    fats: 3.5,
    carbs: 4.5,
    imageUrl: 'assets/images/soups/12.png'
  ),

  FoodItem(
    name: 'Tom Yum',
    desc: 'shrimp, mushrooms, lemongrass, lime, chili, broth',
    category: 'SEAFOOD',
    kcal100g: 50,
    proteins: 5.0,
    fats: 2.0,
    carbs: 4.0,
    imageUrl: 'assets/images/soups/13.png'
  ),
  FoodItem(
    name: 'Mushroom Cream',
    desc: 'mushrooms, cream, onion, garlic, butter, broth',
    category: 'CREAM',
    kcal100g: 85,
    proteins: 2.5,
    fats: 7.0,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/14.png'
  ),

  FoodItem(
    name: 'Pumpkin Soup',
    desc: 'pumpkin, coconut milk, onion, garlic, ginger, spices',
    category: 'CREAM',
    kcal100g: 40,
    proteins: 1.2,
    fats: 2.5,
    carbs: 6.5,
    imageUrl: 'assets/images/soups/15.png'
  ),

  FoodItem(
    name: 'Broccoli Cream',
    desc: 'broccoli, cream, onion, garlic, butter, broth',
    category: 'CREAM',
    kcal100g: 65,
    proteins: 2.5,
    fats: 4.5,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/16.png'
  ),

  FoodItem(
    name: 'Cheese Soup',
    desc: 'cheese, potatoes, carrots, onion, cream, broth',
    category: 'CREAM',
    kcal100g: 90,
    proteins: 3.5,
    fats: 6.5,
    carbs: 6.5,
    imageUrl: 'assets/images/soups/17.png'
  ),

  FoodItem(
    name: 'Gazpacho',
    desc: 'tomatoes, cucumber, bell pepper, garlic, olive oil, vinegar',
    category: 'COLD',
    kcal100g: 30,
    proteins: 1.0,
    fats: 0.2,
    carbs: 5.0,
    imageUrl: 'assets/images/soups/18.png'
  ),

  FoodItem(
    name: 'Okroshka',
    desc: 'kefir, cucumber, eggs, potatoes, herbs, sausage',
    category: 'COLD',
    kcal100g: 55,
    proteins: 3.0,
    fats: 3.5,
    carbs: 4.5,
    imageUrl: 'assets/images/soups/19.png'
  ),

  FoodItem(
    name: 'Beetroot Cold Soup',
    desc: 'beetroot, kefir, cucumber, eggs, herbs',
    category: 'COLD',
    kcal100g: 45,
    proteins: 2.5,
    fats: 2.5,
    carbs: 4.0,
    imageUrl: 'assets/images/soups/20.png'
  ),

  FoodItem(
    name: 'Lentil Soup',
    desc: 'lentils, carrots, onion, garlic, spices, broth',
    category: 'VEGETABLE',
    kcal100g: 45,
    proteins: 4.0,
    fats: 0.5,
    carbs: 8.5,
    imageUrl: 'assets/images/soups/21.png'
  ),

  FoodItem(
    name: 'Minestrone',
    desc: 'beans, pasta, tomatoes, carrots, celery, herbs',
    category: 'VEGETABLE',
    kcal100g: 55,
    proteins: 2.5,
    fats: 1.5,
    carbs: 9.0,
    imageUrl: 'assets/images/soups/22.png'
  ),

  FoodItem(
    name: 'Pea Soup',
    desc: 'peas, carrots, onion, potatoes, herbs, broth',
    category: 'VEGETABLE',
    kcal100g: 60,
    proteins: 4.5,
    fats: 1.0,
    carbs: 10.0,
    imageUrl: 'assets/images/soups/23.png'
  ),

  FoodItem(
    name: 'Miso Soup',
    desc: 'miso paste, tofu, seaweed, onion, broth',
    category: 'VEGETABLE',
    kcal100g: 35,
    proteins: 2.5,
    fats: 1.5,
    carbs: 3.5,
    imageUrl: 'assets/images/soups/24.png'
  ),
  FoodItem(
    name: 'Beef Goulash Soup',
    desc: 'beef, potatoes, paprika, onion, garlic, tomato',
    category: 'MEAT',
    kcal100g: 80,
    proteins: 5.5,
    fats: 5.0,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/25.png'
  ),

  FoodItem(
    name: 'Lamb Piti',
    desc: 'lamb, chickpeas, potatoes, onion, spices, broth',
    category: 'MEAT',
    kcal100g: 90,
    proteins: 6.5,
    fats: 6.0,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/26.png'
  ),

  FoodItem(
    name: 'Beef Broth Soup',
    desc: 'beef, carrots, onion, celery, herbs, broth',
    category: 'MEAT',
    kcal100g: 45,
    proteins: 4.5,
    fats: 2.5,
    carbs: 2.5,
    imageUrl: 'assets/images/soups/27.png'
  ),

  FoodItem(
    name: 'Chicken Corn Soup',
    desc: 'chicken, corn, eggs, onion, broth, spices',
    category: 'POULTRY',
    kcal100g: 55,
    proteins: 4.5,
    fats: 2.5,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/28.png'
  ),

  FoodItem(
    name: 'Chicken Cream Soup',
    desc: 'chicken, cream, potatoes, onion, garlic, broth',
    category: 'CREAM',
    kcal100g: 75,
    proteins: 4.5,
    fats: 5.5,
    carbs: 5.0,
    imageUrl: 'assets/images/soups/29.png'
  ),

  FoodItem(
    name: 'Duck Pho',
    desc: 'duck, rice noodles, herbs, onion, spices, broth',
    category: 'POULTRY',
    kcal100g: 70,
    proteins: 6.0,
    fats: 4.0,
    carbs: 5.0,
    imageUrl: 'assets/images/soups/30.png'
  ),

  FoodItem(
    name: 'Tuna Soup',
    desc: 'tuna, potatoes, carrots, onion, herbs, broth',
    category: 'FISH',
    kcal100g: 60,
    proteins: 6.0,
    fats: 3.0,
    carbs: 4.5,
    imageUrl: 'assets/images/soups/31.png'
  ),

  FoodItem(
    name: 'Cod Soup',
    desc: 'cod, potatoes, onion, carrots, herbs, broth',
    category: 'FISH',
    kcal100g: 50,
    proteins: 5.5,
    fats: 2.0,
    carbs: 4.0,
    imageUrl: 'assets/images/soups/32.png'
  ),

  FoodItem(
    name: 'Seafood Laksa',
    desc: 'shrimp, noodles, coconut milk, chili, spices, broth',
    category: 'SEAFOOD',
    kcal100g: 85,
    proteins: 5.5,
    fats: 6.0,
    carbs: 6.5,
    imageUrl: 'assets/images/soups/33.png'
  ),

  FoodItem(
    name: 'Shrimp Bisque',
    desc: 'shrimp, cream, butter, garlic, onion, broth',
    category: 'CREAM',
    kcal100g: 95,
    proteins: 5.0,
    fats: 7.5,
    carbs: 4.5,
    imageUrl: 'assets/images/soups/34.png'
  ),

  FoodItem(
    name: 'Vegetable Soup',
    desc: 'potatoes, carrots, onion, cabbage, herbs, broth',
    category: 'VEGETABLE',
    kcal100g: 35,
    proteins: 1.5,
    fats: 0.5,
    carbs: 6.0,
    imageUrl: 'assets/images/soups/35.png'
  ),

  FoodItem(
    name: 'Spinach Soup',
    desc: 'spinach, potatoes, onion, garlic, cream, broth',
    category: 'CREAM',
    kcal100g: 50,
    proteins: 2.5,
    fats: 3.0,
    carbs: 5.5,
    imageUrl: 'assets/images/soups/36.png'
  ),

  FoodItem(
    name: 'Tomato Soup',
    desc: 'tomatoes, onion, garlic, olive oil, herbs, broth',
    category: 'VEGETABLE',
    kcal100g: 40,
    proteins: 1.5,
    fats: 1.5,
    carbs: 6.5,
    imageUrl: 'assets/images/soups/37.png'
  ),

  FoodItem(
    name: 'Cabbage Soup',
    desc: 'cabbage, carrots, onion, potatoes, herbs, broth',
    category: 'VEGETABLE',
    kcal100g: 30,
    proteins: 1.5,
    fats: 0.3,
    carbs: 5.0,
    imageUrl: 'assets/images/soups/38.png'
  ),

  FoodItem(
    name: 'Bean Soup',
    desc: 'beans, carrots, onion, garlic, herbs, broth',
    category: 'VEGETABLE',
    kcal100g: 65,
    proteins: 4.5,
    fats: 1.5,
    carbs: 9.5,
    imageUrl: 'assets/images/soups/39.png'
  ),

  FoodItem(
    name: 'Cold Cucumber Soup',
    desc: 'cucumber, yogurt, garlic, herbs, olive oil',
    category: 'COLD',
    kcal100g: 35,
    proteins: 2.0,
    fats: 2.0,
    carbs: 3.5,
    imageUrl: 'assets/images/soups/40.png'
  ),

  FoodItem(
    name: 'Cold Yogurt Soup',
    desc: 'yogurt, cucumber, herbs, garlic, olive oil',
    category: 'COLD',
    kcal100g: 40,
    proteins: 2.5,
    fats: 2.5,
    carbs: 3.5,
    imageUrl: 'assets/images/soups/41.png'
  ),

  FoodItem(
    name: 'Potato Cream Soup',
    desc: 'potatoes, cream, butter, onion, garlic, broth',
    category: 'CREAM',
    kcal100g: 80,
    proteins: 2.0,
    fats: 5.5,
    carbs: 7.5,
    imageUrl: 'assets/images/soups/42.png'
  ),

  FoodItem(
    name: 'Carrot Cream Soup',
    desc: 'carrots, cream, onion, garlic, butter, broth',
    category: 'CREAM',
    kcal100g: 60,
    proteins: 1.5,
    fats: 4.0,
    carbs: 6.5,
    imageUrl: 'assets/images/soups/43.png'
  ),

];



  @override
  Widget build(BuildContext context) {
    // Добавь эту строчку первой:
  double screenWidth = MediaQuery.of(context).size.width;
    // Безопасная фильтрация
    final List<FoodItem> filteredSoups = selectedCat == 'ALL' 
        ? soupDatabase 
        : soupDatabase.where((s) => s.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: mustardGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('FIRST COURSES', 
          style: TextStyle(color: mustardGold, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSubCategoryFilter(screenWidth),
          Expanded(
            child: filteredSoups.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredSoups.length,
                  itemBuilder: (context, index) => _buildSoupCard(screenWidth, filteredSoups[index]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryFilter(screenWidth) {
    return Container(
      height: screenWidth * 0.1, // 10% от ширины экрана для высоты
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isActive = selectedCat == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCat = categories[index]),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isActive ? mustardGold.withOpacity(0.8) : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: mustardGold.withOpacity(0.5), width: 0.8),
              ),
              alignment: Alignment.center,
              child: Text(categories[index],
                style: TextStyle(color: isActive ? Colors.black : mustardGold, fontWeight: FontWeight.w900, fontSize: screenWidth * 0.025)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSoupCard(double screenWidth, FoodItem soup) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [brightGold, goldShadow], 
        begin: Alignment.topLeft, 
        end: Alignment.bottomRight
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        )
      ],
    ),
    child: InkWell(
      onTap: () => _showPortionDialog(soup),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // 1. КАРТИНКА (С Hero-анимацией)
            GestureDetector(
              onTap: () {
                if (soup.imageUrl != null) {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FullScreenImage(imagePath: soup.imageUrl!),
                  ));
                }
              },
              child: Hero(
                tag: soup.imageUrl ?? soup.name,
                child: Container(
                  width: screenWidth * 0.14,
                  height: screenWidth * 0.14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: darkEmerald.withOpacity(0.2)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: soup.imageUrl != null 
                        ? Image.asset(soup.imageUrl!, fit: BoxFit.cover) 
                        : Icon(Icons.restaurant, color: darkEmerald.withOpacity(0.5)),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),

            // 2. ЦЕНТРАЛЬНАЯ ЧАСТЬ (РЕЗИНОВАЯ)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    soup.name.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkEmerald, 
                      fontWeight: FontWeight.w900, 
                      fontSize: screenWidth * 0.032, 
                      letterSpacing: 0.5
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    soup.desc,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkEmerald.withOpacity(0.7), 
                      fontSize: screenWidth * 0.026
                    ),
                  ),
                  const SizedBox(height: 4),
                  // БЖУ в один ряд с FittedBox для защиты от вылетов
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text('P: ${soup.proteins.toStringAsFixed(0)} ', style: TextStyle(color: darkEmerald, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                        Text('F: ${soup.fats.toStringAsFixed(0)} ', style: TextStyle(color: darkEmerald, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                        Text('C: ${soup.carbs.toStringAsFixed(0)} ', style: TextStyle(color: darkEmerald, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 3. ПРАВАЯ ПАНЕЛЬ (Калории + Кнопка)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${soup.kcal100g.toInt()} kcal', 
                      style: TextStyle(color: darkEmerald, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.033)),
                    Text('per 100g', 
                      style: TextStyle(color: darkEmerald.withOpacity(0.7), fontSize: screenWidth * 0.022)),
                  ],
                ),
                const SizedBox(width: 8),
                
                // Умная кнопка
                widget.imageFile == null 
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.add_circle_outline, color: darkEmerald, size: screenWidth * 0.075),
                      onPressed: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showPortionDialog(soup);
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showLibrarySaveDialog(soup);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: darkEmerald, width: 1.5),
                        ),
                        child: Icon(Icons.biotech, color: darkEmerald, size: screenWidth * 0.05),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void _showArchiveInfo(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("To add to Diary, please start from Breakfast/Lunch"),
      backgroundColor: Color(0xFF033E40),
      duration: Duration(seconds: 2),
    ),
  );
}

  void _showPortionDialog(FoodItem soup) {
    final TextEditingController weightController = TextEditingController(text: '300');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: brightGold), borderRadius: BorderRadius.circular(15)),
        title: Text(soup.name.toUpperCase(), style: const TextStyle(color: brightGold, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter weight (grams):', style: TextStyle(color: Colors.white70, fontSize: 12)),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: brightGold, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: mustardGold))),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54))
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: brightGold),
            onPressed: () {
              double weight = double.tryParse(weightController.text) ?? 100;
              double ratio = weight / 100;
              final metrics = context.read<MetricsProvider>();

              // Считаем цифры
              double tKcal = soup.kcal100g * ratio;
              double tP = soup.proteins * ratio;
              double tF = soup.fats * ratio;
              double tC = soup.carbs * ratio;

              if (widget.mealName == 'BIO-SCAN') {
                // МИР №1: СКАНЕР
                metrics.addMealData(
                  mealName: widget.mealName,
                  foodName: soup.name,
                  kcal: tKcal, p: tP, f: tF, c: tC,
                  imagePath: widget.imageFile?.path, 
                );
                Navigator.pop(context); // 1. Граммы
  Navigator.pop(context); // 2. Список супов
  Navigator.pop(context); // 3. Категории
  Navigator.pop(context); // 4. Сканер
  
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Sent to Laboratory!'), 
      backgroundColor: Colors.amber,
      duration: Duration(seconds: 2),
    ),
  );

              } else {
                // МИР №2: ОБЫЧНЫЙ ОБЕД
                metrics.addMealData(
                  mealName: widget.mealName,
                  foodName: soup.name,
                  kcal: tKcal, p: tP, f: tF, c: tC,
                  imagePath: soup.imageUrl, 
                );
                Navigator.pop(context); // Граммы
                Navigator.pop(context); // Список супов
                Navigator.pop(context); // 8 кнопок
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${soup.name} added!'), backgroundColor: mustardGold),
              );
            },
            // ОБЯЗАТЕЛЬНО ДОБАВЬ ЭТУ СТРОЧКУ (была потеряна):
            child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ), // Конец ElevatedButton
        ], // Конец actions
      ), // Конец AlertDialog
    );
  }
void _showLibrarySaveDialog(FoodItem soup) {
  // Мы не будем мучить пользователя вводом веса, 
  // так как в библиотеку мы сохраняем эталон (на 100г)
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF05100A),
      shape: RoundedRectangleBorder(side: const BorderSide(color: brightGold), borderRadius: BorderRadius.circular(15)),
      title: Text("SAVE TO LIBRARY?", style: const TextStyle(color: brightGold, fontSize: 14)),
      content: Text("Do you want to save ${soup.name} with your photo to your personal library?", 
        style: const TextStyle(color: Colors.white70, fontSize: 12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          child: const Text('CANCEL', style: TextStyle(color: Colors.white54))
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: mustardGold),
          onPressed: () {
  // 1. САМОЕ ГЛАВНОЕ: Кладём продукт в общую библиотеку
  globalLibrary.add(
    LibraryProduct(
      name: soup.name,
      calories: soup.kcal100g.toInt().toString(), // Сохраняем как эталон (на 100г)
      proteins: soup.proteins.toString(),
      fats: soup.fats.toString(),
      carbs: soup.carbs.toString(),
      imagePath: widget.imageFile?.path, // Твое фото из галереи!
      desc: soup.desc, // Состав: beef, beets...
    ),
  );

  // 2. Закрываем диалог
  Navigator.pop(context);

  // 3. ПЕРЕПРЫГИВАЕМ в саму Библиотеку, чтобы увидеть результат
  /*Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const FunctionalScreen(mealName: 'MY LIBRARY'),
    ),
  );*/
  // 3. ПЕРЕПРЫГИВАЕМ в саму Библиотеку, заменяя экран категорий
  Navigator.pushReplacement( // Используем Replacement, чтобы не копить окна
    context,
    MaterialPageRoute(
      builder: (context) => FunctionalScreen(mealName: widget.mealName),
    ),
  );

  // 4. Показываем радостное сообщение (зеленое снизу)
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${soup.name} saved to My Library!'),
      backgroundColor: Colors.green[800],
    ),
  );
},
          child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}
}