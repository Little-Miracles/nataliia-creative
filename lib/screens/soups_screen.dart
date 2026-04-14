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
   /* FoodItem(
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
  ),*/

  // --- MEAT (15) ---
  FoodItem(name: ' Classic Ukrainian Borscht', desc: 'beef, beets, cabbage, potatoes, carrots, tomato paste, sour cream', category: 'MEAT', kcal100g: 65, proteins: 3.5, fats: 4.2, carbs: 6.0, 
  imageUrl: 'assets/images/soups/1.png'),
  FoodItem(name: 'Georgian Beef Kharcho', desc: 'beef, rice, tomato, garlic, walnuts, tkemali, herbs', category: 'MEAT', kcal100g: 75, proteins: 5.5, fats: 4.5, carbs: 5.5,
   imageUrl: 'assets/images/soups/2.png'),
  FoodItem(name: 'Russian Beef Solyanka', desc: 'beef, sausages, pickles, olives, onion, tomato paste, lemon', category: 'MEAT', kcal100g: 95, proteins: 6.5, fats: 7.5, carbs: 3.0,
   imageUrl: 'assets/images/soups/3.png'),
  FoodItem(name: 'Uzbek Shurpa', desc: 'lamb, potatoes, carrots, onion, tomato, herbs, spices', category: 'MEAT', kcal100g: 85, proteins: 6.0, fats: 5.5, carbs: 6.0,
   imageUrl: 'assets/images/soups/4.png'),
  FoodItem(name: 'Italian Meatball Soup', desc: 'beef meatballs, potatoes, carrots, onion, herbs, broth', category: 'MEAT', kcal100g: 70, proteins: 5.0, fats: 4.0, carbs: 5.5,
   imageUrl: 'assets/images/soups/5.png'),
  FoodItem(name: 'Moroccan Harira', desc: 'lamb, chickpeas, lentils, tomato, coriander, lemon, spices', category: 'MEAT', kcal100g: 90, proteins: 7.0, fats: 4.5, carbs: 8.0, 
  imageUrl: 'assets/images/soups/6.png'),
  FoodItem(name: 'Hungarian Goulash Soup', desc: 'beef, potatoes, peppers, onion, paprika, caraway, broth', category: 'MEAT', kcal100g: 80, proteins: 6.5, fats: 4.0, carbs: 6.5, 
  imageUrl: 'assets/images/soups/7.png'),
  FoodItem(name: 'Vietnamese Pho Bo', desc: 'beef, rice noodles, star anise, ginger, onion, herbs, broth', category: 'MEAT', kcal100g: 60, proteins: 5.5, fats: 2.5, carbs: 6.0, 
  imageUrl: 'assets/images/soups/8.png'),
  FoodItem(name: 'Mexican Caldo de Res', desc: 'beef, corn, zucchini, carrots, cabbage, chili, lime', category: 'MEAT', kcal100g: 70, proteins: 5.5, fats: 3.5, carbs: 6.0,
   imageUrl: 'assets/images/soups/9.png'),
  FoodItem(name: 'Scottish Lamb Broth', desc: 'lamb, barley, carrots, turnip, leek, parsley, broth', category: 'MEAT', kcal100g: 75, proteins: 6.0, fats: 4.0, carbs: 6.5,
   imageUrl: 'assets/images/soups/10.png'),
  FoodItem(name: 'Turkish Iskembe Soup', desc: 'lamb, garlic, vinegar, butter, paprika, yogurt', category: 'MEAT', kcal100g: 85, proteins: 7.0, fats: 5.5, carbs: 3.5,
   imageUrl: 'assets/images/soups/11.png'),
  FoodItem(name: 'Chinese Beef Noodle Soup', desc: 'beef, noodles, soy sauce, star anise, ginger, bok choy', category: 'MEAT', kcal100g: 78, proteins: 7.5, fats: 3.5, carbs: 7.0,
   imageUrl: 'assets/images/soups/12.png'),
  FoodItem(name: 'Irish Beef Stew Soup', desc: 'beef, potatoes, carrots, onion, Guinness, thyme, broth', category: 'MEAT', kcal100g: 88, proteins: 6.5, fats: 4.5, carbs: 7.0,
   imageUrl: 'assets/images/soups/13.png'),
  FoodItem(name: 'Egyptian Lentil Meat Soup', desc: 'beef, red lentils, cumin, turmeric, onion, lemon, olive oil', category: 'MEAT', kcal100g: 82, proteins: 7.5, fats: 4.0, carbs: 7.5,
   imageUrl: 'assets/images/soups/14.png'),
  FoodItem(name: 'Korean Galbitang', desc: 'beef ribs, radish, garlic, green onion, soy sauce, sesame', category: 'MEAT', kcal100g: 92, proteins: 8.5, fats: 5.5, carbs: 3.0, 
  imageUrl: 'assets/images/soups/15.png'),

  // --- POULTRY (15) ---
  FoodItem(name: 'American Chicken Noodle', desc: 'chicken, noodles, carrots, onion, celery, herbs, broth', category: 'POULTRY', kcal100g: 50, proteins: 4.0, fats: 2.5, carbs: 5.0,
   imageUrl: 'assets/images/soups/16.png'),
  FoodItem(name: 'European Turkey Soup', desc: 'turkey, rice, carrots, celery, onion, thyme, broth', category: 'POULTRY', kcal100g: 48, proteins: 4.5, fats: 1.8, carbs: 4.0, 
  imageUrl: 'assets/images/soups/17.png'),
  FoodItem(name: 'Asian Chicken Rice Soup', desc: 'chicken, rice, ginger, garlic, sesame oil, green onion', category: 'POULTRY', kcal100g: 52, proteins: 4.2, fats: 2.2, carbs: 5.5,
   imageUrl: 'assets/images/soups/18.png'),
  FoodItem(name: 'Chinese Duck Soup', desc: 'duck, noodles, bok choy, soy sauce, ginger, star anise', category: 'POULTRY', kcal100g: 80, proteins: 6.5, fats: 5.0, carbs: 4.5, 
  imageUrl: 'assets/images/soups/19.png'),
  FoodItem(name: 'Mexican Chicken Tortilla', desc: 'chicken, tortilla strips, tomato, chili, avocado, lime', category: 'POULTRY', kcal100g: 65, proteins: 5.5, fats: 3.5, carbs: 6.0, 
  imageUrl: 'assets/images/soups/20.png'),
  FoodItem(name: 'Thai Chicken Coconut', desc: 'chicken, coconut milk, lemongrass, galangal, lime, chili', category: 'POULTRY', kcal100g: 95, proteins: 6.0, fats: 7.5, carbs: 4.0,
   imageUrl: 'assets/images/soups/21.png'),
  FoodItem(name: 'Georgian Chikhirtma', desc: 'chicken, eggs, lemon, onion, coriander, flour, saffron', category: 'POULTRY', kcal100g: 58, proteins: 5.5, fats: 3.5, carbs: 3.0, 
  imageUrl: 'assets/images/soups/22.png'),
  FoodItem(name: 'Moroccan Chicken Harira', desc: 'chicken, chickpeas, tomato, coriander, cinnamon, lemon', category: 'POULTRY', kcal100g: 72, proteins: 6.5, fats: 3.0, carbs: 7.0, imageUrl: 'assets/images/soups/23.png'),
  FoodItem(name: 'French Poulet au Pot', desc: 'chicken, leek, carrots, turnip, celery, herbs, broth', category: 'POULTRY', kcal100g: 55, proteins: 5.0, fats: 2.5, carbs: 4.5, imageUrl: 'assets/images/soups/24.png'),
  FoodItem(name: 'Korean Samgyetang', desc: 'whole chicken, ginseng, garlic, rice, jujube, broth', category: 'POULTRY', kcal100g: 85, proteins: 8.0, fats: 4.5, carbs: 5.0, imageUrl: 'assets/images/soups/25.png'),
  FoodItem(name: 'Indian Chicken Shorba', desc: 'chicken, tomato, onion, garam masala, ginger, coriander', category: 'POULTRY', kcal100g: 68, proteins: 6.5, fats: 3.5, carbs: 4.5, imageUrl: 'assets/images/soups/26.png'),
  FoodItem(name: 'Italian Chicken Minestrone', desc: 'chicken, pasta, zucchini, tomato, beans, basil, parmesan', category: 'POULTRY', kcal100g: 62, proteins: 5.5, fats: 2.5, carbs: 6.5, imageUrl: 'assets/images/soups/27.png'),
  FoodItem(name: 'Greek Avgolemono', desc: 'chicken, rice, eggs, lemon juice, broth, fresh dill', category: 'POULTRY', kcal100g: 60, proteins: 5.0, fats: 3.0, carbs: 5.0, imageUrl: 'assets/images/soups/28.png'),
  FoodItem(name: 'Vietnamese Pho Ga', desc: 'chicken, rice noodles, star anise, ginger, onion, herbs', category: 'POULTRY', kcal100g: 55, proteins: 5.5, fats: 2.0, carbs: 5.5, imageUrl: 'assets/images/soups/29.png'),
  FoodItem(name: 'Peruvian Aguadito', desc: 'chicken, rice, cilantro, aji amarillo, peas, corn, broth', category: 'POULTRY', kcal100g: 65, proteins: 6.0, fats: 2.5, carbs: 6.5, imageUrl: 'assets/images/soups/30.png'),

  // --- FISH (15) ---
  FoodItem(name: 'Russian Fish Ukha', desc: 'salmon, potatoes, onion, carrots, bay leaf, dill, broth', category: 'FISH', kcal100g: 55, proteins: 5.5, fats: 3.0, carbs: 4.2, imageUrl: 'assets/images/soups/31.png'),
  FoodItem(name: 'Norwegian Salmon Soup', desc: 'salmon, potatoes, carrots, leek, cream, dill, butter', category: 'FISH', kcal100g: 78, proteins: 6.0, fats: 5.0, carbs: 4.0, imageUrl: 'assets/images/soups/32.png'),
  FoodItem(name: 'Finnish Lohikeitto', desc: 'salmon, potatoes, leek, cream, dill, butter, white pepper', category: 'FISH', kcal100g: 90, proteins: 7.0, fats: 6.5, carbs: 4.5, imageUrl: 'assets/images/soups/33.png'),
  FoodItem(name: 'Portuguese Caldeirada', desc: 'white fish, potatoes, tomato, peppers, olive oil, herbs', category: 'FISH', kcal100g: 60, proteins: 6.5, fats: 3.0, carbs: 4.0, imageUrl: 'assets/images/soups/34.png'),
  FoodItem(name: 'Japanese Miso Fish Soup', desc: 'cod, miso paste, tofu, seaweed, green onion, dashi', category: 'FISH', kcal100g: 45, proteins: 5.5, fats: 2.0, carbs: 3.5, imageUrl: 'assets/images/soups/35.png'),
  FoodItem(name: 'Greek Kakavia', desc: 'sea bass, potatoes, onion, olive oil, lemon, herbs', category: 'FISH', kcal100g: 58, proteins: 6.0, fats: 3.5, carbs: 3.5, imageUrl: 'assets/images/soups/36.png'),
  FoodItem(name: 'Italian Cioppino', desc: 'white fish, tomato, garlic, white wine, basil, olive oil', category: 'FISH', kcal100g: 62, proteins: 7.0, fats: 3.0, carbs: 4.0, imageUrl: 'assets/images/soups/37.png'),
  FoodItem(name: 'Swedish Fish Soup', desc: 'cod, salmon, potatoes, carrots, cream, dill, mustard', category: 'FISH', kcal100g: 75, proteins: 6.5, fats: 4.5, carbs: 4.5, imageUrl: 'assets/images/soups/38.png'),
  FoodItem(name: 'Moroccan Chermoula Fish', desc: 'white fish, tomato, cumin, coriander, preserved lemon, olive oil', category: 'FISH', kcal100g: 65, proteins: 7.0, fats: 3.5, carbs: 3.5, imageUrl: 'assets/images/soups/39.png'),
  FoodItem(name: 'Chinese Steamed Fish Soup', desc: 'tilapia, ginger, soy sauce, sesame oil, green onion, broth', category: 'FISH', kcal100g: 50, proteins: 6.5, fats: 2.0, carbs: 2.5, imageUrl: 'assets/images/soups/40.png'),
  FoodItem(name: 'Thai Fish Curry Soup', desc: 'white fish, coconut milk, red curry paste, lime, lemongrass', category: 'FISH', kcal100g: 85, proteins: 6.5, fats: 6.0, carbs: 4.5, imageUrl: 'assets/images/soups/41.png'),
  FoodItem(name: 'Brazilian Moqueca', desc: 'white fish, coconut milk, tomato, peppers, palm oil, coriander', category: 'FISH', kcal100g: 80, proteins: 7.0, fats: 5.5, carbs: 4.0, imageUrl: 'assets/images/soups/42.png'),
  FoodItem(name: 'Indian Fish Rasam', desc: 'fish, tamarind, tomato, turmeric, cumin, mustard seeds, curry leaves', category: 'FISH', kcal100g: 48, proteins: 5.5, fats: 2.0, carbs: 4.0, imageUrl: 'assets/images/soups/43.png'),
  FoodItem(name: 'Turkish Balik Corbasi', desc: 'sea bass, potatoes, carrots, tomato, lemon, olive oil, herbs', category: 'FISH', kcal100g: 62, proteins: 6.5, fats: 3.5, carbs: 4.0, imageUrl: 'assets/images/soups/44.png'),
  FoodItem(name: 'Caribbean Fish Broth', desc: 'snapper, yam, plantain, coconut milk, chili, thyme, lime', category: 'FISH', kcal100g: 70, proteins: 6.0, fats: 4.0, carbs: 6.0, imageUrl: 'assets/images/soups/45.png'),

  // --- SEAFOOD (15) ---
  FoodItem(name: 'French Bouillabaisse', desc: 'fish, mussels, shrimp, tomato, saffron, garlic, herbs', category: 'SEAFOOD', kcal100g: 70, proteins: 6.5, fats: 3.5, carbs: 4.5, imageUrl: 'assets/images/soups/46.png'),
  FoodItem(name: 'Thai Tom Yum', desc: 'shrimp, mushrooms, lemongrass, lime, chili, fish sauce', category: 'SEAFOOD', kcal100g: 50, proteins: 5.0, fats: 2.0, carbs: 4.0, imageUrl: 'assets/images/soups/47.png'),
  FoodItem(name: 'American Clam Chowder', desc: 'clams, potatoes, cream, bacon, onion, celery, thyme', category: 'SEAFOOD', kcal100g: 95, proteins: 5.5, fats: 6.5, carbs: 7.0, imageUrl: 'assets/images/soups/48.png'),
  FoodItem(name: 'Spanish Seafood Zarzuela', desc: 'shrimp, mussels, calamari, tomato, garlic, white wine', category: 'SEAFOOD', kcal100g: 65, proteins: 7.0, fats: 3.0, carbs: 4.0, imageUrl: 'assets/images/soups/49.png'),
  FoodItem(name: 'Korean Haemul Jeongol', desc: 'seafood mix, tofu, mushrooms, chili paste, green onion', category: 'SEAFOOD', kcal100g: 55, proteins: 6.5, fats: 2.5, carbs: 3.5, imageUrl: 'assets/images/soups/50.png'),
  FoodItem(name: 'Italian Cacciucco', desc: 'octopus, squid, shrimp, tomato, garlic, red wine, herbs', category: 'SEAFOOD', kcal100g: 72, proteins: 7.5, fats: 3.5, carbs: 4.0, imageUrl: 'assets/images/soups/51.png'),
  FoodItem(name: 'Japanese Seafood Miso', desc: 'shrimp, clams, tofu, miso, seaweed, green onion, dashi', category: 'SEAFOOD', kcal100g: 48, proteins: 5.5, fats: 2.0, carbs: 4.0, imageUrl: 'assets/images/soups/52.png'),
  FoodItem(name: 'Portuguese Caldeirada Mar', desc: 'shrimp, mussels, fish, potatoes, tomato, white wine, olive oil', category: 'SEAFOOD', kcal100g: 68, proteins: 6.5, fats: 3.0, carbs: 5.0, imageUrl: 'assets/images/soups/53.png'),
  FoodItem(name: 'Malaysian Laksa', desc: 'shrimp, rice noodles, coconut milk, curry paste, tofu, bean sprouts', category: 'SEAFOOD', kcal100g: 105, proteins: 6.0, fats: 7.0, carbs: 8.0, imageUrl: 'assets/images/soups/54.png'),
  FoodItem(name: 'Greek Seafood Soup', desc: 'octopus, shrimp, mussels, tomato, olive oil, lemon, ouzo', category: 'SEAFOOD', kcal100g: 62, proteins: 7.0, fats: 3.0, carbs: 3.5, imageUrl: 'assets/images/soups/55.png'),
  FoodItem(name: 'Chinese Seafood Hot Pot', desc: 'shrimp, scallops, squid, bok choy, mushrooms, soy broth', category: 'SEAFOOD', kcal100g: 58, proteins: 7.5, fats: 2.0, carbs: 3.5, imageUrl: 'assets/images/soups/56.png'),
  FoodItem(name: 'Brazilian Moqueca Seafood', desc: 'shrimp, mussels, coconut milk, palm oil, tomato, coriander', category: 'SEAFOOD', kcal100g: 85, proteins: 7.0, fats: 5.5, carbs: 4.5, imageUrl: 'assets/images/soups/57.png'),
  FoodItem(name: 'Peruvian Chupe de Camarones', desc: 'shrimp, potatoes, corn, cream, egg, chili, herbs', category: 'SEAFOOD', kcal100g: 90, proteins: 7.5, fats: 5.0, carbs: 7.0, imageUrl: 'assets/images/soups/58.png'),
  FoodItem(name: 'Turkish Seafood Soup', desc: 'shrimp, mussels, calamari, tomato, lemon, olive oil, herbs', category: 'SEAFOOD', kcal100g: 60, proteins: 6.5, fats: 3.0, carbs: 3.5, imageUrl: 'assets/images/soups/59.png'),
  FoodItem(name: 'Indian Prawn Curry Soup', desc: 'prawns, coconut milk, tomato, curry leaves, mustard seeds, turmeric', category: 'SEAFOOD', kcal100g: 88, proteins: 7.5, fats: 6.0, carbs: 4.5, imageUrl: 'assets/images/soups/60.png'),

  // --- VEGETABLE (15) ---
  FoodItem(name: 'Russian Shchi', desc: 'cabbage, potatoes, carrots, onion, tomato paste, sour cream', category: 'VEGETABLE', kcal100g: 35, proteins: 1.5, fats: 1.5, carbs: 5.5, imageUrl: 'assets/images/soups/61.png'),
  FoodItem(name: 'Italian Minestrone', desc: 'zucchini, tomato, beans, pasta, basil, parmesan, olive oil', category: 'VEGETABLE', kcal100g: 55, proteins: 2.5, fats: 2.0, carbs: 8.5, imageUrl: 'assets/images/soups/62.png'),
  FoodItem(name: 'French Soupe au Pistou', desc: 'beans, zucchini, tomato, pasta, basil pesto, garlic', category: 'VEGETABLE', kcal100g: 60, proteins: 3.0, fats: 2.5, carbs: 9.0, imageUrl: 'assets/images/soups/63.png'),
  FoodItem(name: 'Indian Dal Soup', desc: 'red lentils, tomato, onion, turmeric, cumin, ginger, coriander', category: 'VEGETABLE', kcal100g: 65, proteins: 4.5, fats: 2.0, carbs: 9.5, imageUrl: 'assets/images/soups/64.png'),
  FoodItem(name: 'Lebanese Lentil Soup', desc: 'lentils, onion, cumin, lemon juice, olive oil, coriander', category: 'VEGETABLE', kcal100g: 70, proteins: 4.5, fats: 2.5, carbs: 10.0, imageUrl: 'assets/images/soups/65.png'),
  FoodItem(name: 'Spanish Gazpacho', desc: 'tomatoes, cucumber, peppers, garlic, olive oil, vinegar', category: 'VEGETABLE', kcal100g: 35, proteins: 1.0, fats: 2.0, carbs: 5.0, imageUrl: 'assets/images/soups/66.png'),
  FoodItem(name: 'Thai Vegetable Tom Kha', desc: 'mushrooms, tofu, coconut milk, lemongrass, galangal, lime', category: 'VEGETABLE', kcal100g: 75, proteins: 2.5, fats: 6.0, carbs: 4.5, imageUrl: 'assets/images/soups/67.png'),
  FoodItem(name: 'Moroccan Vegetable Harira', desc: 'chickpeas, lentils, tomato, celery, coriander, lemon, spices', category: 'VEGETABLE', kcal100g: 68, proteins: 4.0, fats: 2.0, carbs: 10.5, imageUrl: 'assets/images/soups/68.png'),
  FoodItem(name: 'Ukrainian Green Borscht', desc: 'sorrel, potatoes, carrots, onion, egg, sour cream, dill', category: 'VEGETABLE', kcal100g: 42, proteins: 2.0, fats: 2.0, carbs: 5.5, imageUrl: 'assets/images/soups/69.png'),
  FoodItem(name: 'Japanese Tofu Miso', desc: 'tofu, miso paste, seaweed, green onion, mushrooms, dashi', category: 'VEGETABLE', kcal100g: 38, proteins: 3.0, fats: 1.5, carbs: 3.5, imageUrl: 'assets/images/soups/70.png'),
  FoodItem(name: 'Mexican Black Bean Soup', desc: 'black beans, tomato, onion, garlic, cumin, chili, lime', category: 'VEGETABLE', kcal100g: 72, proteins: 4.5, fats: 1.5, carbs: 12.0, imageUrl: 'assets/images/soups/71.png'),
  FoodItem(name: 'Egyptian Lentil Soup', desc: 'red lentils, cumin, turmeric, onion, lemon, olive oil', category: 'VEGETABLE', kcal100g: 65, proteins: 4.0, fats: 2.0, carbs: 10.0, imageUrl: 'assets/images/soups/72.png'),
  FoodItem(name: 'German Pea Soup', desc: 'split peas, carrots, celery, onion, marjoram, mustard, broth', category: 'VEGETABLE', kcal100g: 78, proteins: 5.0, fats: 1.5, carbs: 13.0, imageUrl: 'assets/images/soups/73.png'),
  FoodItem(name: 'Turkish Red Lentil Soup', desc: 'red lentils, onion, butter, paprika, mint, lemon, broth', category: 'VEGETABLE', kcal100g: 68, proteins: 4.5, fats: 2.5, carbs: 10.0, imageUrl: 'assets/images/soups/74.png'),
  FoodItem(name: 'Greek Fasolada', desc: 'white beans, tomato, carrots, celery, olive oil, herbs', category: 'VEGETABLE', kcal100g: 62, proteins: 3.5, fats: 2.5, carbs: 9.5, imageUrl: 'assets/images/soups/75.png'),

  // --- CREAM (15) ---
  FoodItem(name: 'French Mushroom Cream', desc: 'mushrooms, cream, onion, garlic, butter, thyme, broth', category: 'CREAM', kcal100g: 85, proteins: 2.5, fats: 7.0, carbs: 5.5, imageUrl: 'assets/images/soups/76.png'),
  FoodItem(name: 'Thai Pumpkin Cream', desc: 'pumpkin, coconut milk, ginger, garlic, lemongrass, spices', category: 'CREAM', kcal100g: 40, proteins: 1.2, fats: 2.5, carbs: 6.5, imageUrl: 'assets/images/soups/77.png'),
  FoodItem(name: 'Italian Tomato Cream', desc: 'tomatoes, cream, basil, garlic, olive oil, parmesan', category: 'CREAM', kcal100g: 55, proteins: 1.5, fats: 4.0, carbs: 5.0, imageUrl: 'assets/images/soups/78.png'),
  FoodItem(name: 'French Vichyssoise', desc: 'leek, potatoes, cream, onion, butter, chives, white pepper', category: 'CREAM', kcal100g: 75, proteins: 1.8, fats: 5.5, carbs: 7.0, imageUrl: 'assets/images/soups/79.png'),
  FoodItem(name: 'American Broccoli Cheddar', desc: 'broccoli, cheddar, cream, onion, garlic, butter, broth', category: 'CREAM', kcal100g: 95, proteins: 4.5, fats: 7.5, carbs: 5.0, imageUrl: 'assets/images/soups/80.png'),
  FoodItem(name: 'Spanish Roasted Pepper Cream', desc: 'roasted peppers, tomato, onion, garlic, cream, smoked paprika', category: 'CREAM', kcal100g: 65, proteins: 1.5, fats: 4.5, carbs: 6.0, imageUrl: 'assets/images/soups/81.png'),
  FoodItem(name: 'Indian Carrot Ginger Cream', desc: 'carrots, ginger, coconut milk, onion, curry, coriander', category: 'CREAM', kcal100g: 58, proteins: 1.2, fats: 3.5, carbs: 8.0, imageUrl: 'assets/images/soups/82.png'),
  FoodItem(name: 'French Asparagus Cream', desc: 'asparagus, cream, butter, onion, lemon, tarragon, broth', category: 'CREAM', kcal100g: 70, proteins: 2.5, fats: 5.5, carbs: 4.5, imageUrl: 'assets/images/soups/83.png'),
  FoodItem(name: 'German Potato Cream', desc: 'potatoes, cream, bacon, onion, chives, mustard, broth', category: 'CREAM', kcal100g: 88, proteins: 3.0, fats: 6.0, carbs: 8.5, imageUrl: 'assets/images/soups/84.png'),
  FoodItem(name: 'Turkish Red Lentil Cream', desc: 'red lentils, butter, paprika, onion, mint, lemon, cream', category: 'CREAM', kcal100g: 72, proteins: 3.5, fats: 4.0, carbs: 9.0, imageUrl: 'assets/images/soups/85.png'),
  FoodItem(name: 'Japanese Corn Cream', desc: 'corn, cream, butter, dashi, miso, green onion, sesame', category: 'CREAM', kcal100g: 80, proteins: 2.5, fats: 5.0, carbs: 9.5, imageUrl: 'assets/images/soups/86.png'),
  FoodItem(name: 'Mexican Avocado Cream', desc: 'avocado, cream, lime, jalapeño, onion, garlic, coriander', category: 'CREAM', kcal100g: 95, proteins: 1.5, fats: 8.5, carbs: 5.0, imageUrl: 'assets/images/soups/87.png'),
  FoodItem(name: 'Norwegian Seafood Cream', desc: 'salmon, shrimp, cream, leek, dill, white wine, butter', category: 'CREAM', kcal100g: 105, proteins: 6.5, fats: 8.0, carbs: 4.0, imageUrl: 'assets/images/soups/88.png'),
  FoodItem(name: 'Greek Spinach Cream', desc: 'spinach, feta, cream, onion, garlic, lemon, olive oil', category: 'CREAM', kcal100g: 68, proteins: 3.5, fats: 5.5, carbs: 4.0, imageUrl: 'assets/images/soups/89.png'),
  FoodItem(name: 'Moroccan Chickpea Cream', desc: 'chickpeas, tahini, cumin, lemon, garlic, olive oil, paprika', category: 'CREAM', kcal100g: 82, proteins: 4.5, fats: 4.5, carbs: 10.0, imageUrl: 'assets/images/soups/90.png'),
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