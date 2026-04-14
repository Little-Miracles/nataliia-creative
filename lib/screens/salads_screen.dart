import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/global_data.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/full_screen_image.dart';
import 'package:smart_body_life/screens/functional_screen.dart';

// Модель данных
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

// ТВОИ ЛЮБИМЫЕ ЦВЕТА
const Color jewelColor = Color(0xFF50C878); 
const Color deepShadow = Color(0xFF013620); 
const Color contentColor = Color(0xFFEDE6D6);

class SaladsScreen extends StatefulWidget {
  final String mealName; // <--- Добавь это
  final File? imageFile; // 1. ДОБАВЬ ЭТУ СТРОКУ
  
  const SaladsScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<SaladsScreen> createState() => _SaladsScreenState();
}

class _SaladsScreenState extends State<SaladsScreen> {
  final List<String> categories = ['ALL', 'MEAT', 'POULTRY', 'FISH', 'VEGETABLE', 'MIXED'];
  String selectedCat = 'ALL';

  // НАПОЛНЯЕМ ИЗУМРУДНУЮ БАЗУ (теперь все категории заполнены)
  final List<FoodItem> saladDatabase = [

  // --- MEAT ---
  FoodItem(name: 'Moroccan Beef Salad', desc: 'Boiled beef, radish, onions, olive oil, cumin, coriander', category: 'MEAT', kcal100g: 165, proteins: 15.0, fats: 9.0, carbs: 3.5,imageUrl: 'assets/images/salads/1.jpeg'),
  FoodItem(name: 'Warm Steak Salad', desc: 'Grilled beef, arugula, cherry tomatoes, balsamic glaze, sea salt', category: 'MEAT', kcal100g: 210, proteins: 18.5, fats: 12.0, carbs: 4.5,imageUrl: 'assets/images/salads/2.jpeg'),
  FoodItem(name: 'Thai Beef Salad', desc: 'Sliced beef, mint, lime juice, chili, fish sauce, lemongrass', category: 'MEAT', kcal100g: 175, proteins: 16.0, fats: 8.5, carbs: 5.0,imageUrl: 'assets/images/salads/3.jpeg'),
  FoodItem(name: 'Argentine Churrasco Salad', desc: 'Grilled beef strips, peppers, chimichurri sauce, garlic', category: 'MEAT', kcal100g: 225, proteins: 19.0, fats: 13.5, carbs: 4.0,imageUrl: 'assets/images/salads/4.jpeg'),
  FoodItem(name: 'Korean Bulgogi Salad', desc: 'Marinated beef, sesame, soy sauce, ginger, green onion', category: 'MEAT', kcal100g: 195, proteins: 17.5, fats: 10.0, carbs: 7.5,imageUrl: 'assets/images/salads/5.jpeg'),
  FoodItem(name: 'Egyptian Kofta Salad', desc: 'Spiced beef, tomatoes, parsley, tahini dressing, sumac', category: 'MEAT', kcal100g: 185, proteins: 16.0, fats: 11.0, carbs: 4.5,imageUrl: 'assets/images/salads/6.jpeg'),
  FoodItem(name: 'French Bistro Beef Salad', desc: 'Roast beef, Dijon mustard, cornichons, capers, olive oil', category: 'MEAT', kcal100g: 200, proteins: 17.0, fats: 12.5, carbs: 3.0,imageUrl: 'assets/images/salads/7.jpeg'),
  FoodItem(name: 'Vietnamese Bo Luc Lac', desc: 'Shaken beef, watercress, lime, black pepper, soy dressing', category: 'MEAT', kcal100g: 180, proteins: 16.5, fats: 9.5, carbs: 4.0,imageUrl: 'assets/images/salads/8.jpeg'),
  FoodItem(name: 'Georgian Beef Salad', desc: 'Beef, walnuts, pomegranate, coriander, garlic, tkemali sauce', category: 'MEAT', kcal100g: 215, proteins: 15.5, fats: 14.0, carbs: 6.0,imageUrl: 'assets/images/salads/9.jpeg'),
  FoodItem(name: 'Mexican Carne Asada Salad', desc: 'Grilled beef, black beans, corn, jalapeño, lime dressing', category: 'MEAT', kcal100g: 205, proteins: 18.0, fats: 10.5, carbs: 9.0,imageUrl: 'assets/images/salads/10.jpeg'),

  // --- POULTRY ---
  FoodItem(name: 'Classic Caesar Salad', desc: 'Chicken, parmesan, croutons, Caesar dressing, garlic', category: 'POULTRY', kcal100g: 180, proteins: 14.0, fats: 11.0, carbs: 8.0,imageUrl: 'assets/images/salads/11.jpeg'),
  FoodItem(name: 'Turkish Chicken Salad', desc: 'Turkey breast, spinach, cranberries, honey mustard dressing', category: 'POULTRY', kcal100g: 145, proteins: 16.0, fats: 5.5, carbs: 7.0,imageUrl: 'assets/images/salads/12.jpeg'),
  FoodItem(name: 'Thai Larb Gai', desc: 'Minced chicken, mint, lime juice, chili flakes, fish sauce', category: 'POULTRY', kcal100g: 155, proteins: 18.0, fats: 6.0, carbs: 4.5,imageUrl: 'assets/images/salads/13.jpeg'),
  FoodItem(name: 'Moroccan Chicken Salad', desc: 'Roasted chicken, chickpeas, preserved lemon, harissa, cumin', category: 'POULTRY', kcal100g: 170, proteins: 17.5, fats: 7.0, carbs: 8.5,imageUrl: 'assets/images/salads/14.jpeg'),
  FoodItem(name: 'Japanese Chicken Salad', desc: 'Grilled chicken, edamame, sesame dressing, nori, ginger', category: 'POULTRY', kcal100g: 160, proteins: 16.5, fats: 7.5, carbs: 6.0,imageUrl: 'assets/images/salads/15.jpeg'),
  FoodItem(name: 'Mexican Chicken Salad', desc: 'Chicken, avocado, black beans, corn, cilantro, lime', category: 'POULTRY', kcal100g: 175, proteins: 15.5, fats: 9.0, carbs: 9.5,imageUrl: 'assets/images/salads/16.jpeg'),
  FoodItem(name: 'Georgian Satsivi Salad', desc: 'Poached chicken, walnut sauce, garlic, fenugreek, coriander', category: 'POULTRY', kcal100g: 190, proteins: 16.0, fats: 12.0, carbs: 4.0,imageUrl: 'assets/images/salads/17.jpeg'),
  FoodItem(name: 'Indian Tandoori Chicken Salad', desc: 'Tandoori chicken, cucumber, mint yogurt dressing, pomegranate', category: 'POULTRY', kcal100g: 165, proteins: 19.0, fats: 6.5, carbs: 5.5,imageUrl: 'assets/images/salads/18.jpeg'),
  FoodItem(name: 'French Poulet Salad', desc: 'Roast chicken, tarragon, Dijon mustard, green beans, walnuts', category: 'POULTRY', kcal100g: 185, proteins: 17.0, fats: 10.5, carbs: 4.5,imageUrl: 'assets/images/salads/19.jpeg'),
  FoodItem(name: 'Lebanese Chicken Fattoush', desc: 'Grilled chicken, pita chips, sumac, pomegranate molasses', category: 'POULTRY', kcal100g: 170, proteins: 15.0, fats: 7.0, carbs: 11.0,imageUrl: 'assets/images/salads/20.jpeg'),

  // --- FISH ---
  FoodItem(name: 'Classic Tuna Fresh', desc: 'Tuna, eggs, greens, beans, lemon juice, olive oil', category: 'FISH', kcal100g: 135, proteins: 17.0, fats: 6.5, carbs: 1.5,imageUrl: 'assets/images/salads/21.jpeg'),
  FoodItem(name: 'Norwegian Salmon Avocado', desc: 'Smoked salmon, avocado, mix salad, cream cheese dressing', category: 'FISH', kcal100g: 195, proteins: 12.0, fats: 15.0, carbs: 3.0,imageUrl: 'assets/images/salads/22.jpeg'),
  FoodItem(name: 'Japanese Tuna Poke', desc: 'Raw tuna, rice, edamame, sesame oil, soy sauce, nori', category: 'FISH', kcal100g: 170, proteins: 15.5, fats: 6.0, carbs: 12.0,imageUrl: 'assets/images/salads/23.jpeg'),
  FoodItem(name: 'Greek Octopus Salad', desc: 'Grilled octopus, olives, capers, lemon, oregano, olive oil', category: 'FISH', kcal100g: 115, proteins: 14.0, fats: 5.5, carbs: 2.5,imageUrl: 'assets/images/salads/24.jpeg'),
  FoodItem(name: 'Thai Prawn Salad', desc: 'Tiger prawns, mango, chili, lime juice, fish sauce, mint', category: 'FISH', kcal100g: 125, proteins: 13.5, fats: 3.5, carbs: 8.0,imageUrl: 'assets/images/salads/25.jpeg'),
  FoodItem(name: 'Peruvian Ceviche Salad', desc: 'Sea bass, lime juice, red onion, chili, coriander, sweet potato', category: 'FISH', kcal100g: 105, proteins: 14.5, fats: 2.5, carbs: 6.0,imageUrl: 'assets/images/salads/26.jpeg'),
  FoodItem(name: 'Moroccan Sardine Salad', desc: 'Grilled sardines, roasted peppers, harissa, preserved lemon', category: 'FISH', kcal100g: 145, proteins: 13.0, fats: 8.5, carbs: 3.0,imageUrl: 'assets/images/salads/27.jpeg'),
  FoodItem(name: 'Swedish Herring Salad', desc: 'Pickled herring, beets, apple, sour cream, dill', category: 'FISH', kcal100g: 130, proteins: 11.0, fats: 7.0, carbs: 7.5,imageUrl: 'assets/images/salads/28.jpeg'),
  FoodItem(name: 'Vietnamese Shrimp Salad', desc: 'Shrimps, rice noodles, herbs, peanuts, sweet chili dressing', category: 'FISH', kcal100g: 140, proteins: 12.5, fats: 4.5, carbs: 11.0,imageUrl: 'assets/images/salads/29.jpeg'),
  FoodItem(name: 'Italian Calamari Salad', desc: 'Grilled calamari, cherry tomatoes, rocket, lemon, basil oil', category: 'FISH', kcal100g: 110, proteins: 13.0, fats: 4.5, carbs: 3.5,imageUrl: 'assets/images/salads/30.jpeg'),

  // --- VEGETABLE ---
  FoodItem(name: 'Greek Village Salad', desc: 'Feta, olives, cucumbers, olive oil, oregano', category: 'VEGETABLE', kcal100g: 90, proteins: 2.5, fats: 7.2, carbs: 4.0,imageUrl: 'assets/images/salads/31.jpeg'),
  FoodItem(name: 'Vitamin Mix', desc: 'Cabbage, carrots, apple, lemon juice, honey', category: 'VEGETABLE', kcal100g: 55, proteins: 1.2, fats: 0.2, carbs: 12.0,imageUrl: 'assets/images/salads/32.jpeg'),
  FoodItem(name: 'Lebanese Tabbouleh', desc: 'Bulgur, parsley, mint, tomatoes, lemon juice, olive oil', category: 'VEGETABLE', kcal100g: 75, proteins: 2.0, fats: 3.5, carbs: 10.0,imageUrl: 'assets/images/salads/33.jpeg'),
  FoodItem(name: 'Indian Kachumber Salad', desc: 'Cucumber, tomato, onion, chaat masala, lemon, coriander', category: 'VEGETABLE', kcal100g: 40, proteins: 1.5, fats: 0.5, carbs: 7.5,imageUrl: 'assets/images/salads/34.jpeg'),
  FoodItem(name: 'Mexican Guacamole Salad', desc: 'Avocado, tomato, red onion, jalapeño, lime, coriander', category: 'VEGETABLE', kcal100g: 110, proteins: 1.5, fats: 9.0, carbs: 6.0,imageUrl: 'assets/images/salads/35.jpeg'),
  FoodItem(name: 'Moroccan Carrot Salad', desc: 'Roasted carrots, cumin, harissa, lemon, fresh herbs, olive oil', category: 'VEGETABLE', kcal100g: 65, proteins: 1.0, fats: 3.5, carbs: 8.0,imageUrl: 'assets/images/salads/36.jpeg'),
  FoodItem(name: 'Italian Caprese Salad', desc: 'Mozzarella, tomatoes, fresh basil, extra virgin olive oil', category: 'VEGETABLE', kcal100g: 120, proteins: 6.5, fats: 9.0, carbs: 3.0,imageUrl: 'assets/images/salads/37.jpeg'),
  FoodItem(name: 'Turkish Shepherd Salad', desc: 'Tomatoes, cucumber, peppers, parsley, sumac, olive oil', category: 'VEGETABLE', kcal100g: 50, proteins: 1.2, fats: 3.0, carbs: 5.5,imageUrl: 'assets/images/salads/38.jpeg'),
  FoodItem(name: 'French Ratatouille Salad', desc: 'Roasted zucchini, eggplant, peppers, herbes de Provence', category: 'VEGETABLE', kcal100g: 60, proteins: 1.5, fats: 3.5, carbs: 7.0,imageUrl: 'assets/images/salads/39.jpeg'),
  FoodItem(name: 'Egyptian Ful Salad', desc: 'Fava beans, tomato, onion, cumin, lemon juice, olive oil', category: 'VEGETABLE', kcal100g: 85, proteins: 5.0, fats: 3.0, carbs: 11.0,imageUrl: 'assets/images/salads/40.jpeg'),

  // --- MIXED ---
  FoodItem(name: 'Classic Seafood Mix', desc: 'Shrimps, mussels, calamari, lemon, olive oil, fresh herbs', category: 'MIXED', kcal100g: 95, proteins: 12.5, fats: 4.0, carbs: 2.0,imageUrl: 'assets/images/salads/41.jpeg'),
  FoodItem(name: 'French Chef Specialty', desc: 'Ham, cheese, eggs, vegetables, mayo, black pepper', category: 'MIXED', kcal100g: 220, proteins: 11.0, fats: 16.5, carbs: 5.0,imageUrl: 'assets/images/salads/42.jpeg'),
  FoodItem(name: 'Italian Antipasto Salad', desc: 'Salami, olives, artichokes, roasted peppers, mozzarella', category: 'MIXED', kcal100g: 235, proteins: 10.5, fats: 18.0, carbs: 5.5,imageUrl: 'assets/images/salads/43.jpeg'),
  FoodItem(name: 'American Cobb Salad', desc: 'Chicken, bacon, eggs, avocado, blue cheese, ranch dressing', category: 'MIXED', kcal100g: 245, proteins: 16.0, fats: 18.5, carbs: 4.0,imageUrl: 'assets/images/salads/44.jpeg'),
  FoodItem(name: 'Japanese Chirashi Salad', desc: 'Salmon, tuna, cucumber, edamame, sesame, soy dressing', category: 'MIXED', kcal100g: 160, proteins: 14.5, fats: 7.5, carbs: 7.0,imageUrl: 'assets/images/salads/45.jpeg'),
  FoodItem(name: 'Spanish Tapas Salad', desc: 'Chorizo, manchego, roasted peppers, olives, smoked paprika oil', category: 'MIXED', kcal100g: 255, proteins: 12.0, fats: 20.0, carbs: 4.5,imageUrl: 'assets/images/salads/46.jpeg'),
  FoodItem(name: 'Lebanese Mezze Salad', desc: 'Hummus, falafel, tabbouleh, pickles, tahini, pita chips', category: 'MIXED', kcal100g: 175, proteins: 7.5, fats: 9.0, carbs: 16.5,imageUrl: 'assets/images/salads/47.jpeg'),
  FoodItem(name: 'Thai Rainbow Salad', desc: 'Shrimps, mango, papaya, peanuts, chili lime dressing', category: 'MIXED', kcal100g: 145, proteins: 10.0, fats: 6.5, carbs: 12.0,imageUrl: 'assets/images/salads/48.jpeg'),
  FoodItem(name: 'Georgian Feast Salad', desc: 'Chicken, walnuts, beets, pomegranate, coriander, garlic oil', category: 'MIXED', kcal100g: 200, proteins: 13.5, fats: 13.0, carbs: 7.5,imageUrl: 'assets/images/salads/49.jpeg'),
  FoodItem(name: 'Peruvian Quinoa Salad', desc: 'Quinoa, grilled chicken, avocado, corn, lime aji dressing', category: 'MIXED', kcal100g: 185, proteins: 14.0, fats: 8.5, carbs: 14.0,imageUrl: 'assets/images/salads/50.jpeg'),
];


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final List<FoodItem> filteredSalads = selectedCat == 'ALL' 
        ? saladDatabase : saladDatabase.where((s) => s.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: jewelColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('SALADS', 
          style: TextStyle(color: jewelColor, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterPanel(screenWidth),
          Expanded(
            child: filteredSalads.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredSalads.length,
                  itemBuilder: (context, index) => _buildJewelCard(filteredSalads[index], screenWidth),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(double screenWidth) {
    return Container(
      height: screenWidth * 0.11,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
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
                color: isActive ? jewelColor : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: jewelColor.withOpacity(0.5), width: 0.8),
              ),
              alignment: Alignment.center,
              child: Text(categories[index],
                style: TextStyle(
                  color: isActive ? Colors.black : jewelColor, 
                  fontWeight: FontWeight.bold, 
                  fontSize: screenWidth * 0.03
                )),
            ),
          );
        },
      ),
    );
  }

Widget _buildJewelCard(FoodItem salad, double screenWidth) {
    return Container(
      width: double.infinity, // Растягиваем на всю ширину
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [jewelColor.withOpacity(0.6), deepShadow], 
          begin: Alignment.topLeft, end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: jewelColor.withOpacity(0.2), width: 0.5),
      ),
      child: InkWell(
        onTap: () {
          if (widget.mealName != 'ARCHIVE') _showPortionDialog(salad, screenWidth);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Ужали отступы для SE
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. КАРТИНКА (leading)
              GestureDetector(
                onTap: () {
                  if (salad.imageUrl != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenImage(imagePath: salad.imageUrl!)));
                  }
                },
                child: Hero(
                  tag: salad.imageUrl ?? salad.name,
                  child: Container(
                    width: screenWidth * 0.13, height: screenWidth * 0.13,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: salad.imageUrl != null 
                          ? Image.asset(salad.imageUrl!, fit: BoxFit.cover) 
                          : Icon(Icons.restaurant, color: jewelColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // 2. ИНФО (Текстовый блок - ТЕПЕРЬ РЕЗИНОВЫЙ)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      salad.name.toUpperCase(), 
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: contentColor, 
                        fontWeight: FontWeight.w900, 
                        fontSize: screenWidth * 0.032, 
                        letterSpacing: 0.5 // Ужали расстояние между буквами
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      salad.desc, 
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: contentColor.withOpacity(0.5), fontSize: screenWidth * 0.026)
                    ),
                    const SizedBox(height: 4),
                    // ЗАЩИТА МАКРОСОВ
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildMacro('P', salad.proteins, screenWidth),
                          _buildMacro('F', salad.fats, screenWidth),
                          _buildMacro('C', salad.carbs, screenWidth),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 3. ПРАВАЯ ЧАСТЬ (Адаптивная: Ккал + Кнопка)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${salad.kcal100g.toInt()} kcal', 
                        style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.034)),
                      Text('per 100g', 
                        style: TextStyle(color: contentColor.withOpacity(0.6), fontSize: screenWidth * 0.02)),
                    ],
                  ),
                  const SizedBox(width: 6),
                  
                  // ТВОЯ УМНАЯ КНОПКА (Без изменений в логике)
                  widget.imageFile == null 
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.add_circle_outline, color: contentColor, size: screenWidth * 0.075),
                      onPressed: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showPortionDialog(salad, screenWidth);
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showLibrarySaveDialog(salad); 
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: contentColor, width: 1.5),
                        ),
                        child: Icon(Icons.biotech, color: contentColor, size: screenWidth * 0.055),
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

  // ОБНОВЛЕННАЯ ФУНКЦИЯ МАКРОСОВ ДЛЯ САЛАТОВ
  Widget _buildMacro(String label, double val, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.015), // Ужали отступ
      child: Text(
        '$label: ${val.toStringAsFixed(0)}', 
        style: TextStyle(
          color: jewelColor.withOpacity(0.9), 
          fontWeight: FontWeight.bold, 
          fontSize: screenWidth * 0.024 // Ужали шрифт
        )
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

  void _showPortionDialog(FoodItem item, double screenWidth) {
    final TextEditingController controller = TextEditingController(text: '150');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: jewelColor), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: const TextStyle(color: jewelColor, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Portion weight (grams):', style: TextStyle(color: contentColor, fontSize: 12)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: jewelColor, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: jewelColor))),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: jewelColor),
            onPressed: () {
              double weight = double.tryParse(controller.text) ?? 150;
              double factor = weight / 100;
              final metrics = Provider.of<MetricsProvider>(context, listen: false);
              
              metrics.addMealData(
                mealName: widget.mealName,
                foodName: item.name,
                kcal: item.kcal100g * factor,
                p: item.proteins * factor,
                f: item.fats * factor,
                c: item.carbs * factor,
                imagePath: widget.imageFile?.path,
              );

              if (widget.mealName == 'BIO-SCAN') {
                Navigator.pop(context); Navigator.pop(context); 
                Navigator.pop(context); Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sent to Laboratory!'), backgroundColor: Colors.amber),
                );
              } else {
                Navigator.pop(context); Navigator.pop(context); Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to ${widget.mealName}!'), backgroundColor: jewelColor)
                );
              }
            },
            child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLibrarySaveDialog(FoodItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: jewelColor), borderRadius: BorderRadius.circular(15)),
        title: const Text("SAVE TO LIBRARY?", style: TextStyle(color: jewelColor, fontSize: 14)),
        content: Text("Do you want to save ${item.name} with your photo?", 
          style: const TextStyle(color: contentColor, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: jewelColor),
            onPressed: () {
              globalLibrary.add(
                LibraryProduct(
                  name: item.name,
                  calories: item.kcal100g.toInt().toString(),
                  proteins: item.proteins.toString(),
                  fats: item.fats.toString(),
                  carbs: item.carbs.toString(),
                  imagePath: widget.imageFile?.path,
                  desc: item.desc,
                ),
              );
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => FunctionalScreen(mealName: widget.mealName),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} saved!'), backgroundColor: Colors.green[800]),
              );
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}