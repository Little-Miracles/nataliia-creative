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

// ТВОИ МЕДНЫЕ ЦВЕТА (вынесены для стабильности)
const Color copperGold = Color(0xFF8B5E3C); 
const Color deepShadow = Color(0xFF1B140E);
const Color milkWhite = Color(0xFFEDE6D6);

class MainDishesScreen extends StatefulWidget {
  final String mealName; 
  final File? imageFile; // 1. Файл с фото

  // ОСТАВЛЯЕМ ТОЛЬКО ОДИН ПРАВИЛЬНЫЙ КОНСТРУКТОР:
  const MainDishesScreen({
    super.key, 
    required this.mealName, 
    this.imageFile,
  });

  @override
  State<MainDishesScreen> createState() => _MainDishesScreenState();
}
class _MainDishesScreenState extends State<MainDishesScreen> {
  final List<String> categories = [
  'ALL',
  'MEAT',
  'POULTRY',
  'FISH',
  'SEAFOOD',
  'PASTA',
  'GRAINS',
  'POTATO',
  'LEGUMES',
  'VEGETABLES',
  'EGGS'
];
  String selectedCat = 'ALL';

  // БАЗА ВТОРЫХ БЛЮД (на 100г)
  final List<FoodItem> mainDatabase = [

  FoodItem(
    name: 'Grilled Steak',
    desc: 'beef, rosemary, garlic, olive oil, pepper, salt',
    category: 'MEAT',
    kcal100g: 250,
    proteins: 22.0,
    fats: 18.0,
    carbs: 0.0,
    imageUrl: 'assets/images/mains/1.jpeg'
  ),

  FoodItem(
    name: 'Beef Stroganoff',
    desc: 'beef, cream, onion, mushrooms, butter, spices',
    category: 'MEAT',
    kcal100g: 180,
    proteins: 15.0,
    fats: 12.0,
    carbs: 4.0,
    imageUrl: 'assets/images/mains/2.jpeg'
  ),

  FoodItem(
    name: 'Pork Chops',
    desc: 'pork, garlic, herbs, oil, pepper, salt',
    category: 'MEAT',
    kcal100g: 210,
    proteins: 19.0,
    fats: 14.5,
    carbs: 0.5,
    imageUrl: 'assets/images/mains/3.jpeg'
  ),

  FoodItem(
    name: 'BBQ Ribs',
    desc: 'pork ribs, bbq sauce, garlic, spices, honey',
    category: 'MEAT',
    kcal100g: 290,
    proteins: 16.0,
    fats: 24.0,
    carbs: 6.0,
    imageUrl: 'assets/images/mains/4.jpeg'
  ),

  FoodItem(
    name: 'Lamb Stew',
    desc: 'lamb, potatoes, carrots, onion, herbs, broth',
    category: 'MEAT',
    kcal100g: 160,
    proteins: 14.0,
    fats: 10.0,
    carbs: 5.0,
    imageUrl: 'assets/images/mains/5.jpeg'
  ),

  FoodItem(
    name: 'Lamb Kebab',
    desc: 'lamb, onion, spices, herbs, oil, garlic',
    category: 'MEAT',
    kcal100g: 220,
    proteins: 18.0,
    fats: 15.0,
    carbs: 2.0,
    imageUrl: 'assets/images/mains/6.jpeg'
  ),

  FoodItem(
    name: 'Roasted Chicken',
    desc: 'chicken, garlic, herbs, oil, pepper, salt',
    category: 'POULTRY',
    kcal100g: 190,
    proteins: 20.0,
    fats: 12.0,
    carbs: 0.0,
    imageUrl: 'assets/images/mains/7.jpeg'
  ),

  FoodItem(
    name: 'Turkey Fillet',
    desc: 'turkey, herbs, garlic, oil, spices',
    category: 'POULTRY',
    kcal100g: 110,
    proteins: 24.0,
    fats: 1.5,
    carbs: 0.0,
    imageUrl: 'assets/images/mains/8.jpeg'
  ),

  FoodItem(
    name: 'Mixed Grill',
    desc: 'beef, pork, chicken, spices, herbs, oil',
    category: 'MEAT',
    kcal100g: 240,
    proteins: 21.0,
    fats: 17.0,
    carbs: 1.0,
    imageUrl: 'assets/images/mains/9.jpeg'
  ),


  // MEAT
  FoodItem(name: 'Beef Burger', desc: 'beef, bun, cheese, lettuce, tomato, sauce', category: 'MEAT', kcal100g: 260, proteins: 17.0, fats: 18.0, carbs: 15.0,
    imageUrl: 'assets/images/mains/10.jpeg'),
  FoodItem(name: 'Meatballs', desc: 'beef, onion, garlic, breadcrumbs, egg, spices', category: 'MEAT', kcal100g: 210, proteins: 15.0, fats: 14.0, carbs: 6.0,
    imageUrl: 'assets/images/mains/11.jpeg'),
  FoodItem(name: 'Stuffed Peppers', desc: 'beef, rice, peppers, onion, tomato, spices', category: 'MEAT', kcal100g: 150, proteins: 10.0, fats: 8.0, carbs: 10.0,
  imageUrl: 'assets/images/mains/12.jpeg'),
  FoodItem(name: 'Beef Steak', desc: 'beef, oil, garlic, rosemary, butter, spices', category: 'MEAT', kcal100g: 270, proteins: 26.0, fats: 18.0, carbs: 0.0,imageUrl: 'assets/images/mains/13.jpeg'),
  FoodItem(name: 'Pork Schnitzel', desc: 'pork, egg, breadcrumbs, oil, lemon, spices', category: 'MEAT', kcal100g: 280, proteins: 22.0, fats: 18.0, carbs: 8.0,imageUrl: 'assets/images/mains/14.jpeg'),
  FoodItem(name: 'Lamb Kebab', desc: 'lamb, onion, garlic, spices, herbs, oil', category: 'MEAT', kcal100g: 230, proteins: 18.0, fats: 16.0, carbs: 2.0,imageUrl: 'assets/images/mains/15.jpeg'),
  FoodItem(name: 'Beef Stroganoff', desc: 'beef, mushrooms, onion, cream, butter, spices', category: 'MEAT', kcal100g: 200, proteins: 16.0, fats: 13.0, carbs: 4.0,imageUrl: 'assets/images/mains/16.jpeg'),
  FoodItem(name: 'Pork Ribs', desc: 'pork ribs, garlic, soy sauce, honey, spices', category: 'MEAT', kcal100g: 310, proteins: 20.0, fats: 24.0, carbs: 5.0,imageUrl: 'assets/images/mains/17.jpeg'),
  FoodItem(name: 'Greek Moussaka', desc: 'beef, eggplant, tomato, bechamel, cheese, spices', category: 'MEAT', kcal100g: 180, proteins: 12.0, fats: 11.0, carbs: 9.0,imageUrl: 'assets/images/mains/18.jpeg'),
  FoodItem(name: 'Beef Gyros', desc: 'beef, pita, onion, tomato, tzatziki, spices', category: 'MEAT', kcal100g: 220, proteins: 15.0, fats: 10.0, carbs: 18.0,imageUrl: 'assets/images/mains/19.jpeg'),
  FoodItem(name: 'Korean Bulgogi', desc: 'beef, soy sauce, sesame oil, garlic, ginger, pear', category: 'MEAT', kcal100g: 190, proteins: 17.0, fats: 10.0, carbs: 8.0,imageUrl: 'assets/images/mains/20.jpeg'),
  FoodItem(name: 'Pork Goulash', desc: 'pork, onion, paprika, tomato, broth, spices', category: 'MEAT', kcal100g: 160, proteins: 14.0, fats: 9.0, carbs: 5.0,imageUrl: 'assets/images/mains/21.jpeg'),
  FoodItem(name: 'Beef Tagine', desc: 'beef, chickpeas, apricots, onion, spices, broth', category: 'MEAT', kcal100g: 175, proteins: 13.0, fats: 8.0, carbs: 12.0,imageUrl: 'assets/images/mains/22.jpeg'),
  FoodItem(name: 'Pork Tenderloin', desc: 'pork, mustard, garlic, herbs, oil, spices', category: 'MEAT', kcal100g: 185, proteins: 22.0, fats: 10.0, carbs: 1.0,imageUrl: 'assets/images/mains/23.jpeg'),
  FoodItem(name: 'Beef Kofta', desc: 'beef, onion, parsley, cumin, coriander, spices', category: 'MEAT', kcal100g: 210, proteins: 16.0, fats: 14.0, carbs: 3.0,imageUrl: 'assets/images/mains/24.jpeg'),

  // POULTRY
  FoodItem(name: 'Chicken Cutlets', desc: 'chicken, egg, breadcrumbs, oil, spices', category: 'POULTRY', kcal100g: 220, proteins: 18.0, fats: 14.0, carbs: 5.0,imageUrl: 'assets/images/mains/25.jpeg'),
  FoodItem(name: 'Chicken Curry', desc: 'chicken, coconut milk, curry, garlic, onion, spices', category: 'POULTRY', kcal100g: 170, proteins: 16.0, fats: 10.0, carbs: 5.0,imageUrl: 'assets/images/mains/26.jpeg'),
  FoodItem(name: 'Chicken Tikka Masala', desc: 'chicken, tomato, cream, garlic, ginger, spices', category: 'POULTRY', kcal100g: 180, proteins: 18.0, fats: 10.0, carbs: 6.0,imageUrl: 'assets/images/mains/27.jpeg'),
  FoodItem(name: 'Duck Breast', desc: 'duck, orange, honey, garlic, herbs, spices', category: 'POULTRY', kcal100g: 240, proteins: 19.0, fats: 17.0, carbs: 4.0,imageUrl: 'assets/images/mains/28.jpeg'),
  FoodItem(name: 'Chicken Shawarma', desc: 'chicken, pita, garlic sauce, tomato, onion, spices', category: 'POULTRY', kcal100g: 210, proteins: 17.0, fats: 10.0, carbs: 15.0,imageUrl: 'assets/images/mains/29.jpeg'),
  FoodItem(name: 'Turkey Meatballs', desc: 'turkey, egg, breadcrumbs, garlic, herbs, spices', category: 'POULTRY', kcal100g: 165, proteins: 17.0, fats: 8.0, carbs: 5.0,imageUrl: 'assets/images/mains/30.jpeg'),
  FoodItem(name: 'Chicken Souvlaki', desc: 'chicken, lemon, garlic, olive oil, oregano, spices', category: 'POULTRY', kcal100g: 175, proteins: 20.0, fats: 9.0, carbs: 2.0,imageUrl: 'assets/images/mains/31.jpeg'),
  FoodItem(name: 'Chicken Teriyaki', desc: 'chicken, soy sauce, mirin, honey, garlic, ginger', category: 'POULTRY', kcal100g: 190, proteins: 19.0, fats: 8.0, carbs: 10.0,imageUrl: 'assets/images/mains/32.jpeg'),
  FoodItem(name: 'Roast Chicken', desc: 'chicken, garlic, butter, herbs, lemon, spices', category: 'POULTRY', kcal100g: 215, proteins: 22.0, fats: 13.0, carbs: 1.0,imageUrl: 'assets/images/mains/33.jpeg'),
  FoodItem(name: 'Chicken Piccata', desc: 'chicken, lemon, capers, butter, white wine, herbs', category: 'POULTRY', kcal100g: 190, proteins: 21.0, fats: 11.0, carbs: 3.0,imageUrl: 'assets/images/mains/34.jpeg'),
  FoodItem(name: 'Kung Pao Chicken', desc: 'chicken, peanuts, chili, soy sauce, garlic, ginger', category: 'POULTRY', kcal100g: 185, proteins: 18.0, fats: 10.0, carbs: 7.0,imageUrl: 'assets/images/mains/35.jpeg'),
  FoodItem(name: 'Chicken Marsala', desc: 'chicken, mushrooms, marsala wine, butter, herbs', category: 'POULTRY', kcal100g: 200, proteins: 20.0, fats: 11.0, carbs: 4.0,imageUrl: 'assets/images/mains/36.jpeg'),
  FoodItem(name: 'Grilled Turkey Steak', desc: 'turkey, olive oil, garlic, lemon, rosemary, spices', category: 'POULTRY', kcal100g: 160, proteins: 24.0, fats: 6.0, carbs: 0.0,imageUrl: 'assets/images/mains/37.jpeg'),
  FoodItem(name: 'Chicken Gyros', desc: 'chicken, tzatziki, pita, tomato, onion, spices', category: 'POULTRY', kcal100g: 200, proteins: 18.0, fats: 9.0, carbs: 14.0,imageUrl: 'assets/images/mains/38.jpeg'),
  FoodItem(name: 'Hoisin Duck', desc: 'duck, hoisin sauce, scallions, cucumber, pancake', category: 'POULTRY', kcal100g: 255, proteins: 16.0, fats: 14.0, carbs: 16.0,imageUrl: 'assets/images/mains/39.jpeg'),

  // FISH
  FoodItem(name: 'Grilled Salmon', desc: 'salmon, lemon, herbs, oil, garlic, spices', category: 'FISH', kcal100g: 210, proteins: 20.0, fats: 14.0, carbs: 0.0,imageUrl: 'assets/images/mains/40.jpeg'),
  FoodItem(name: 'Fish Cutlets', desc: 'fish, egg, breadcrumbs, onion, spices, oil', category: 'FISH', kcal100g: 180, proteins: 16.0, fats: 10.0, carbs: 6.0,imageUrl: 'assets/images/mains/41.jpeg'),
  FoodItem(name: 'Baked Cod', desc: 'cod, lemon, garlic, olive oil, herbs, breadcrumbs', category: 'FISH', kcal100g: 140, proteins: 20.0, fats: 5.0, carbs: 4.0,imageUrl: 'assets/images/mains/42.jpeg'),
  FoodItem(name: 'Tuna Steak', desc: 'tuna, soy sauce, sesame oil, ginger, garlic, spices', category: 'FISH', kcal100g: 180, proteins: 28.0, fats: 6.0, carbs: 1.0,imageUrl: 'assets/images/mains/43.jpeg'),
  FoodItem(name: 'Fish Tacos', desc: 'white fish, corn tortilla, cabbage, salsa, lime, cream', category: 'FISH', kcal100g: 190, proteins: 14.0, fats: 9.0, carbs: 16.0,imageUrl: 'assets/images/mains/44.jpeg'),
  FoodItem(name: 'Sea Bass en Papillote', desc: 'sea bass, lemon, tomato, olives, herbs, olive oil', category: 'FISH', kcal100g: 150, proteins: 22.0, fats: 7.0, carbs: 2.0,imageUrl: 'assets/images/mains/45.jpeg'),
  FoodItem(name: 'Salmon Teriyaki', desc: 'salmon, soy sauce, mirin, honey, garlic, ginger', category: 'FISH', kcal100g: 220, proteins: 20.0, fats: 12.0, carbs: 9.0,imageUrl: 'assets/images/mains/46.jpeg'),
  FoodItem(name: 'Breaded Plaice', desc: 'plaice, egg, breadcrumbs, oil, lemon, herbs', category: 'FISH', kcal100g: 190, proteins: 16.0, fats: 10.0, carbs: 8.0,imageUrl: 'assets/images/mains/47.jpeg'),
  FoodItem(name: 'Trout with Almonds', desc: 'trout, almonds, butter, lemon, herbs, garlic', category: 'FISH', kcal100g: 210, proteins: 19.0, fats: 14.0, carbs: 2.0,imageUrl: 'assets/images/mains/48.jpeg'),
  FoodItem(name: 'Miso Glazed Salmon', desc: 'salmon, miso, mirin, soy sauce, sesame, ginger', category: 'FISH', kcal100g: 230, proteins: 21.0, fats: 13.0, carbs: 7.0,imageUrl: 'assets/images/mains/49.jpeg'),
  FoodItem(name: 'Fish Provencal', desc: 'white fish, tomatoes, olives, capers, garlic, herbs', category: 'FISH', kcal100g: 130, proteins: 18.0, fats: 5.0, carbs: 4.0,imageUrl: 'assets/images/mains/50.jpeg'),
  FoodItem(name: 'Mackerel in Tomato Sauce', desc: 'mackerel, tomato, onion, garlic, olive oil, spices', category: 'FISH', kcal100g: 175, proteins: 16.0, fats: 10.0, carbs: 5.0,imageUrl: 'assets/images/mains/51.jpeg'),
  FoodItem(name: 'Pan-Seared Halibut', desc: 'halibut, butter, garlic, lemon, capers, herbs', category: 'FISH', kcal100g: 155, proteins: 23.0, fats: 6.0, carbs: 1.0,imageUrl: 'assets/images/mains/52.jpeg'),
  FoodItem(name: 'Fish Curry', desc: 'white fish, coconut milk, curry, tomato, garlic, ginger', category: 'FISH', kcal100g: 160, proteins: 17.0, fats: 8.0, carbs: 6.0,imageUrl: 'assets/images/mains/53.jpeg'),
  FoodItem(name: 'Stuffed Sardines', desc: 'sardines, breadcrumbs, herbs, lemon, garlic, olive oil', category: 'FISH', kcal100g: 200, proteins: 18.0, fats: 12.0, carbs: 5.0,imageUrl: 'assets/images/mains/54.jpeg'),

  // SEAFOOD
  FoodItem(name: 'Shrimp Stir Fry', desc: 'shrimp, vegetables, garlic, soy sauce, oil', category: 'SEAFOOD', kcal100g: 120, proteins: 14.0, fats: 5.0, carbs: 6.0,imageUrl: 'assets/images/mains/55.jpeg'),
  FoodItem(name: 'Fried Calamari', desc: 'calamari, flour, oil, lemon, spices', category: 'SEAFOOD', kcal100g: 200, proteins: 13.0, fats: 12.0, carbs: 10.0,imageUrl: 'assets/images/mains/56.jpeg'),
  FoodItem(name: 'Grilled Octopus', desc: 'octopus, olive oil, lemon, garlic, herbs, paprika', category: 'SEAFOOD', kcal100g: 140, proteins: 18.0, fats: 6.0, carbs: 3.0,imageUrl: 'assets/images/mains/57.jpeg'),
  FoodItem(name: 'Mussels in White Wine', desc: 'mussels, white wine, garlic, butter, parsley, shallots', category: 'SEAFOOD', kcal100g: 110, proteins: 12.0, fats: 4.0, carbs: 4.0,imageUrl: 'assets/images/mains/58.jpeg'),
  FoodItem(name: 'Scallops with Butter', desc: 'scallops, butter, garlic, lemon, herbs, white wine', category: 'SEAFOOD', kcal100g: 130, proteins: 14.0, fats: 7.0, carbs: 3.0,imageUrl: 'assets/images/mains/59.jpeg'),
  FoodItem(name: 'Prawn Linguine', desc: 'prawns, pasta, garlic, chili, white wine, parsley', category: 'SEAFOOD', kcal100g: 195, proteins: 13.0, fats: 7.0, carbs: 22.0,imageUrl: 'assets/images/mains/60.jpeg'),
  FoodItem(name: 'Seafood Paella', desc: 'shrimp, mussels, squid, rice, saffron, tomato, spices', category: 'SEAFOOD', kcal100g: 180, proteins: 12.0, fats: 6.0, carbs: 22.0,imageUrl: 'assets/images/mains/61.jpeg'),
  FoodItem(name: 'Crab Cakes', desc: 'crab, egg, breadcrumbs, mayo, mustard, herbs', category: 'SEAFOOD', kcal100g: 220, proteins: 15.0, fats: 13.0, carbs: 10.0,imageUrl: 'assets/images/mains/62.jpeg'),
  FoodItem(name: 'Lobster Bisque', desc: 'lobster, cream, shallots, cognac, tomato, herbs', category: 'SEAFOOD', kcal100g: 150, proteins: 9.0, fats: 10.0, carbs: 6.0,imageUrl: 'assets/images/mains/63.jpeg'),
  FoodItem(name: 'Garlic Butter Shrimp', desc: 'shrimp, butter, garlic, lemon, parsley, white wine', category: 'SEAFOOD', kcal100g: 140, proteins: 15.0, fats: 8.0, carbs: 2.0,imageUrl: 'assets/images/mains/64.jpeg'),
  FoodItem(name: 'Thai Shrimp Curry', desc: 'shrimp, coconut milk, thai curry paste, lime, basil', category: 'SEAFOOD', kcal100g: 145, proteins: 13.0, fats: 8.0, carbs: 5.0,imageUrl: 'assets/images/mains/65.jpeg'),
  FoodItem(name: 'Clam Chowder', desc: 'clams, potato, cream, bacon, onion, celery, herbs', category: 'SEAFOOD', kcal100g: 130, proteins: 7.0, fats: 7.0, carbs: 10.0,imageUrl: 'assets/images/mains/66.jpeg'),
  FoodItem(name: 'Squid Ink Pasta', desc: 'squid, squid ink pasta, garlic, white wine, parsley', category: 'SEAFOOD', kcal100g: 210, proteins: 12.0, fats: 8.0, carbs: 24.0,imageUrl: 'assets/images/mains/67.jpeg'),
  FoodItem(name: 'Oysters Rockefeller', desc: 'oysters, spinach, butter, cream, breadcrumbs, herbs', category: 'SEAFOOD', kcal100g: 160, proteins: 10.0, fats: 10.0, carbs: 7.0,imageUrl: 'assets/images/mains/68.jpeg'),
  FoodItem(name: 'Spicy Crab Stir Fry', desc: 'crab, chili, garlic, ginger, soy sauce, scallions', category: 'SEAFOOD', kcal100g: 120, proteins: 14.0, fats: 4.0, carbs: 5.0,imageUrl: 'assets/images/mains/69.jpeg'),

  // PASTA
  FoodItem(name: 'Spaghetti Bolognese', desc: 'pasta, beef, tomato, garlic, onion, herbs', category: 'PASTA', kcal100g: 170, proteins: 8.0, fats: 7.0, carbs: 18.0,imageUrl: 'assets/images/mains/70.jpeg'),
  FoodItem(name: 'Carbonara', desc: 'pasta, bacon, egg, cheese, cream, pepper', category: 'PASTA', kcal100g: 250, proteins: 9.0, fats: 15.0, carbs: 20.0,imageUrl: 'assets/images/mains/71.jpeg'),
  FoodItem(name: 'Pasta Puttanesca', desc: 'pasta, tomato, olives, capers, anchovies, garlic', category: 'PASTA', kcal100g: 175, proteins: 6.0, fats: 7.0, carbs: 23.0,imageUrl: 'assets/images/mains/72.jpeg'),
  FoodItem(name: 'Fettuccine Alfredo', desc: 'fettuccine, butter, parmesan, cream, garlic, pepper', category: 'PASTA', kcal100g: 290, proteins: 9.0, fats: 17.0, carbs: 26.0,imageUrl: 'assets/images/mains/73.jpeg'),
  FoodItem(name: 'Pasta Primavera', desc: 'pasta, zucchini, bell pepper, tomato, olive oil, herbs', category: 'PASTA', kcal100g: 155, proteins: 6.0, fats: 5.0, carbs: 22.0,imageUrl: 'assets/images/mains/74.jpeg'),
  FoodItem(name: 'Lasagna', desc: 'pasta sheets, beef, bechamel, tomato, cheese, herbs', category: 'PASTA', kcal100g: 215, proteins: 11.0, fats: 11.0, carbs: 20.0,imageUrl: 'assets/images/mains/75.jpeg'),
  FoodItem(name: 'Penne Arrabbiata', desc: 'penne, tomato, chili, garlic, olive oil, parsley', category: 'PASTA', kcal100g: 165, proteins: 5.0, fats: 5.0, carbs: 25.0,imageUrl: 'assets/images/mains/76.jpeg'),
  FoodItem(name: 'Pasta e Fagioli', desc: 'pasta, beans, tomato, rosemary, garlic, olive oil', category: 'PASTA', kcal100g: 145, proteins: 7.0, fats: 4.0, carbs: 21.0,imageUrl: 'assets/images/mains/77.jpeg'),
  FoodItem(name: 'Tagliatelle with Mushrooms', desc: 'tagliatelle, mushrooms, cream, garlic, thyme, parmesan', category: 'PASTA', kcal100g: 230, proteins: 7.0, fats: 12.0, carbs: 26.0,imageUrl: 'assets/images/mains/78.jpeg'),
  FoodItem(name: 'Gnocchi with Pesto', desc: 'gnocchi, basil pesto, parmesan, pine nuts, olive oil', category: 'PASTA', kcal100g: 245, proteins: 7.0, fats: 13.0, carbs: 27.0,imageUrl: 'assets/images/mains/79.jpeg'),
  FoodItem(name: 'Orzo with Feta', desc: 'orzo, feta, tomato, cucumber, olive oil, herbs', category: 'PASTA', kcal100g: 200, proteins: 7.0, fats: 8.0, carbs: 26.0,imageUrl: 'assets/images/mains/80.jpeg'),
  FoodItem(name: 'Pasta Norma', desc: 'pasta, eggplant, tomato, ricotta, basil, garlic', category: 'PASTA', kcal100g: 190, proteins: 7.0, fats: 7.0, carbs: 26.0,imageUrl: 'assets/images/mains/81.jpeg'),
  FoodItem(name: 'Soba Noodles with Vegetables', desc: 'soba, bok choy, carrot, soy sauce, sesame oil, ginger', category: 'PASTA', kcal100g: 150, proteins: 6.0, fats: 4.0, carbs: 23.0,imageUrl: 'assets/images/mains/82.jpeg'),
  FoodItem(name: 'Pad Thai', desc: 'rice noodles, shrimp, egg, bean sprouts, peanuts, lime', category: 'PASTA', kcal100g: 185, proteins: 10.0, fats: 7.0, carbs: 23.0,imageUrl: 'assets/images/mains/83.jpeg'),
  FoodItem(name: 'Udon with Broth', desc: 'udon noodles, dashi, soy sauce, mirin, scallions, egg', category: 'PASTA', kcal100g: 130, proteins: 5.0, fats: 2.0, carbs: 23.0,imageUrl: 'assets/images/mains/84.jpeg'),
//----картинки выше - обработаны и находятся в канве
  // GRAINS
  FoodItem(name: 'Buckwheat with Mushrooms', desc: 'buckwheat, mushrooms, onion, oil, herbs', category: 'GRAINS', kcal100g: 110, proteins: 4.0, fats: 3.0, carbs: 18.0,imageUrl: 'assets/images/mains/85.jpeg'),
  FoodItem(name: 'Rice Pilaf', desc: 'rice, carrots, onion, oil, spices, garlic', category: 'GRAINS', kcal100g: 140, proteins: 3.5, fats: 4.0, carbs: 22.0,imageUrl: 'assets/images/mains/86.jpeg'),
  FoodItem(name: 'Quinoa Salad', desc: 'quinoa, cucumber, tomato, feta, olive oil, lemon', category: 'GRAINS', kcal100g: 130, proteins: 5.0, fats: 5.0, carbs: 17.0,imageUrl: 'assets/images/mains/87.jpeg'),
  FoodItem(name: 'Bulgur with Vegetables', desc: 'bulgur, tomato, cucumber, parsley, lemon, olive oil', category: 'GRAINS', kcal100g: 120, proteins: 4.0, fats: 3.0, carbs: 20.0,imageUrl: 'assets/images/mains/88.jpeg'),
  FoodItem(name: 'Couscous with Lamb', desc: 'couscous, lamb, chickpeas, vegetables, spices, broth', category: 'GRAINS', kcal100g: 185, proteins: 10.0, fats: 7.0, carbs: 22.0,imageUrl: 'assets/images/mains/89.jpeg'),
  FoodItem(name: 'Barley Risotto', desc: 'barley, mushrooms, onion, white wine, parmesan, herbs', category: 'GRAINS', kcal100g: 155, proteins: 5.0, fats: 5.0, carbs: 22.0,imageUrl: 'assets/images/mains/90.jpeg'),
  FoodItem(name: 'Millet Porridge', desc: 'millet, milk, butter, salt, herbs', category: 'GRAINS', kcal100g: 100, proteins: 3.0, fats: 3.0, carbs: 16.0,imageUrl: 'assets/images/mains/91.jpeg'),
  FoodItem(name: 'Fried Rice', desc: 'rice, egg, soy sauce, sesame oil, scallions, vegetables', category: 'GRAINS', kcal100g: 160, proteins: 5.0, fats: 5.0, carbs: 24.0,imageUrl: 'assets/images/mains/92.jpeg'),
  FoodItem(name: 'Tabbouleh', desc: 'bulgur, parsley, tomato, mint, lemon, olive oil', category: 'GRAINS', kcal100g: 110, proteins: 3.0, fats: 4.0, carbs: 16.0,imageUrl: 'assets/images/mains/93.jpeg'),
  FoodItem(name: 'Risotto al Funghi', desc: 'arborio rice, mushrooms, white wine, parmesan, butter', category: 'GRAINS', kcal100g: 175, proteins: 5.0, fats: 6.0, carbs: 24.0,imageUrl: 'assets/images/mains/94.jpeg'),
  FoodItem(name: 'Sushi Rice Bowl', desc: 'sushi rice, salmon, avocado, soy sauce, sesame, nori', category: 'GRAINS', kcal100g: 180, proteins: 9.0, fats: 6.0, carbs: 24.0,imageUrl: 'assets/images/mains/95.jpeg'),
  FoodItem(name: 'Polenta with Cheese', desc: 'polenta, parmesan, butter, cream, herbs, garlic', category: 'GRAINS', kcal100g: 150, proteins: 4.0, fats: 6.0, carbs: 20.0,imageUrl: 'assets/images/mains/96.jpeg'),
  FoodItem(name: 'Oat Groats with Mushrooms', desc: 'oat groats, mushrooms, onion, oil, herbs, broth', category: 'GRAINS', kcal100g: 115, proteins: 4.0, fats: 3.0, carbs: 18.0,imageUrl: 'assets/images/mains/97.jpeg'),
  FoodItem(name: 'Spelt with Roasted Vegetables', desc: 'spelt, zucchini, bell pepper, tomato, olive oil, herbs', category: 'GRAINS', kcal100g: 125, proteins: 4.5, fats: 3.5, carbs: 19.0,imageUrl: 'assets/images/mains/98.jpeg'),
  FoodItem(name: 'Congee', desc: 'rice, broth, ginger, scallions, soy sauce, sesame oil', category: 'GRAINS', kcal100g: 70, proteins: 2.0, fats: 1.5, carbs: 13.0,imageUrl: 'assets/images/mains/99.jpeg'),

  // POTATO
  FoodItem(name: 'Mashed Potatoes', desc: 'potatoes, butter, milk, salt, pepper', category: 'POTATO', kcal100g: 120, proteins: 2.5, fats: 5.0, carbs: 18.0,imageUrl: 'assets/images/mains/100.jpeg'),
  FoodItem(name: 'Fried Potatoes', desc: 'potatoes, oil, garlic, onion, herbs', category: 'POTATO', kcal100g: 190, proteins: 3.0, fats: 9.0, carbs: 25.0,imageUrl: 'assets/images/mains/101.jpeg'),
  FoodItem(name: 'Potato Gratin', desc: 'potatoes, cream, garlic, cheese, butter, nutmeg', category: 'POTATO', kcal100g: 200, proteins: 5.0, fats: 12.0, carbs: 18.0,imageUrl: 'assets/images/mains/102.jpeg'),
  FoodItem(name: 'Baked Potato', desc: 'potatoes, butter, sour cream, cheese, herbs', category: 'POTATO', kcal100g: 130, proteins: 3.0, fats: 5.0, carbs: 19.0,imageUrl: 'assets/images/mains/103.jpeg'),
  FoodItem(name: 'Potato Pancakes', desc: 'potatoes, egg, onion, flour, oil, sour cream', category: 'POTATO', kcal100g: 175, proteins: 4.0, fats: 9.0, carbs: 20.0,imageUrl: 'assets/images/mains/104.jpeg'),
  FoodItem(name: 'Potato Wedges', desc: 'potatoes, olive oil, paprika, garlic, herbs, spices', category: 'POTATO', kcal100g: 165, proteins: 3.0, fats: 7.0, carbs: 23.0,imageUrl: 'assets/images/mains/159.jpeg'),
  FoodItem(name: 'Potato Soup', desc: 'potatoes, onion, cream, butter, herbs, broth', category: 'POTATO', kcal100g: 95, proteins: 2.5, fats: 4.0, carbs: 13.0,imageUrl: 'assets/images/mains/105.jpeg'),
  FoodItem(name: 'Spanish Omelette', desc: 'potatoes, eggs, olive oil, onion, salt, pepper', category: 'POTATO', kcal100g: 185, proteins: 8.0, fats: 11.0, carbs: 14.0,imageUrl: 'assets/images/mains/106.jpeg'),
  FoodItem(name: 'Hasselback Potatoes', desc: 'potatoes, butter, garlic, herbs, cheese, oil', category: 'POTATO', kcal100g: 155, proteins: 3.0, fats: 7.0, carbs: 20.0,imageUrl: 'assets/images/mains/108.jpeg'),
  FoodItem(name: 'Potato Croquettes', desc: 'potatoes, egg, breadcrumbs, cheese, herbs, oil', category: 'POTATO', kcal100g: 200, proteins: 5.0, fats: 10.0, carbs: 23.0,imageUrl: 'assets/images/mains/109.jpeg'),
  FoodItem(name: 'Aloo Gobi', desc: 'potatoes, cauliflower, onion, tomato, turmeric, spices', category: 'POTATO', kcal100g: 110, proteins: 3.0, fats: 4.0, carbs: 15.0,imageUrl: 'assets/images/mains/107.jpeg'),
  FoodItem(name: 'Potato Gnocchi', desc: 'potatoes, flour, egg, salt, butter, sage', category: 'POTATO', kcal100g: 170, proteins: 4.0, fats: 3.0, carbs: 32.0,imageUrl: 'assets/images/mains/110.jpeg'),
  FoodItem(name: 'Patatas Bravas', desc: 'potatoes, tomato sauce, spicy aioli, paprika, garlic', category: 'POTATO', kcal100g: 180, proteins: 3.0, fats: 9.0, carbs: 22.0,imageUrl: 'assets/images/mains/111.jpeg'),
  FoodItem(name: 'Vichyssoise', desc: 'potatoes, leek, cream, broth, butter, chives', category: 'POTATO', kcal100g: 105, proteins: 2.0, fats: 6.0, carbs: 11.0,imageUrl: 'assets/images/mains/112.jpeg'),
  FoodItem(name: 'Jacket Potatoes with Tuna', desc: 'potatoes, tuna, mayo, corn, onion, herbs', category: 'POTATO', kcal100g: 155, proteins: 9.0, fats: 5.0, carbs: 19.0,imageUrl: 'assets/images/mains/113.jpeg'),

  // LEGUMES
  FoodItem(name: 'Lentil Stew', desc: 'lentils, carrots, onion, garlic, spices, broth', category: 'LEGUMES', kcal100g: 110, proteins: 7.0, fats: 2.0, carbs: 15.0,imageUrl: 'assets/images/mains/114.jpeg'),
  FoodItem(name: 'Chickpea Curry', desc: 'chickpeas, tomato, garlic, spices, oil', category: 'LEGUMES', kcal100g: 150, proteins: 6.0, fats: 5.0, carbs: 18.0,imageUrl: 'assets/images/mains/115.jpeg'),
  FoodItem(name: 'Black Bean Stew', desc: 'black beans, onion, garlic, cumin, tomato, broth', category: 'LEGUMES', kcal100g: 130, proteins: 8.0, fats: 2.0, carbs: 20.0,imageUrl: 'assets/images/mains/116.jpeg'),
  FoodItem(name: 'Hummus', desc: 'chickpeas, tahini, lemon, garlic, olive oil, cumin', category: 'LEGUMES', kcal100g: 165, proteins: 7.0, fats: 9.0, carbs: 14.0,imageUrl: 'assets/images/mains/117.jpeg'),
  FoodItem(name: 'Dal Makhani', desc: 'lentils, kidney beans, cream, butter, tomato, spices', category: 'LEGUMES', kcal100g: 145, proteins: 7.0, fats: 6.0, carbs: 17.0,imageUrl: 'assets/images/mains/118.jpeg'),
  FoodItem(name: 'White Bean Soup', desc: 'white beans, garlic, rosemary, olive oil, broth, tomato', category: 'LEGUMES', kcal100g: 105, proteins: 6.0, fats: 2.5, carbs: 15.0,imageUrl: 'assets/images/mains/119.jpeg'),
  FoodItem(name: 'Falafel', desc: 'chickpeas, onion, garlic, parsley, cumin, coriander', category: 'LEGUMES', kcal100g: 255, proteins: 11.0, fats: 13.0, carbs: 24.0,imageUrl: 'assets/images/mains/120.jpeg'),
  FoodItem(name: 'Pea and Mint Soup', desc: 'peas, mint, onion, broth, cream, butter, spices', category: 'LEGUMES', kcal100g: 90, proteins: 5.0, fats: 3.0, carbs: 12.0,imageUrl: 'assets/images/mains/121.jpeg'),
  FoodItem(name: 'Edamame with Sesame', desc: 'edamame, sesame oil, soy sauce, garlic, chili flakes', category: 'LEGUMES', kcal100g: 120, proteins: 9.0, fats: 4.0, carbs: 10.0,imageUrl: 'assets/images/mains/122.jpeg'),
  FoodItem(name: 'Bean Burger', desc: 'kidney beans, oats, onion, garlic, spices, egg', category: 'LEGUMES', kcal100g: 175, proteins: 9.0, fats: 4.0, carbs: 26.0,imageUrl: 'assets/images/mains/123.jpeg'),
  FoodItem(name: 'Lentil Soup', desc: 'lentils, onion, carrot, cumin, lemon, olive oil', category: 'LEGUMES', kcal100g: 95, proteins: 6.0, fats: 2.0, carbs: 14.0,imageUrl: 'assets/images/mains/124.jpeg'),
  FoodItem(name: 'Ful Medames', desc: 'fava beans, lemon, garlic, olive oil, cumin, parsley', category: 'LEGUMES', kcal100g: 110, proteins: 7.0, fats: 3.0, carbs: 14.0,imageUrl: 'assets/images/mains/125.jpeg'),
  FoodItem(name: 'Split Pea Soup', desc: 'split peas, ham, onion, carrot, celery, broth, herbs', category: 'LEGUMES', kcal100g: 100, proteins: 7.0, fats: 2.0, carbs: 14.0,imageUrl: 'assets/images/mains/126.jpeg'),
  FoodItem(name: 'Mung Bean Stir Fry', desc: 'mung beans, garlic, ginger, soy sauce, sesame oil', category: 'LEGUMES', kcal100g: 105, proteins: 7.0, fats: 3.0, carbs: 13.0,imageUrl: 'assets/images/mains/127.jpeg'),
  FoodItem(name: 'Cassoulet', desc: 'white beans, duck confit, sausage, tomato, herbs, garlic', category: 'LEGUMES', kcal100g: 190, proteins: 13.0, fats: 9.0, carbs: 14.0,imageUrl: 'assets/images/mains/128.jpeg'),

  // VEGETABLES
  FoodItem(name: 'Grilled Vegetables', desc: 'zucchini, eggplant, pepper, oil, herbs', category: 'VEGETABLES', kcal100g: 90, proteins: 2.0, fats: 5.0, carbs: 8.0,imageUrl: 'assets/images/mains/129.jpeg'),
  FoodItem(name: 'Vegetable Stew', desc: 'potatoes, carrots, cabbage, onion, tomato, herbs', category: 'VEGETABLES', kcal100g: 80, proteins: 2.5, fats: 3.0, carbs: 10.0,imageUrl: 'assets/images/mains/130.jpeg'),
  FoodItem(name: 'Ratatouille', desc: 'eggplant, zucchini, tomato, pepper, garlic, herbs', category: 'VEGETABLES', kcal100g: 75, proteins: 2.0, fats: 3.5, carbs: 8.0,imageUrl: 'assets/images/mains/158.jpeg'),
  FoodItem(name: 'Stuffed Eggplant', desc: 'eggplant, tomato, onion, garlic, herbs, olive oil', category: 'VEGETABLES', kcal100g: 95, proteins: 2.5, fats: 5.0, carbs: 9.0,imageUrl: 'assets/images/mains/131.jpeg'),
  FoodItem(name: 'Vegetable Tempura', desc: 'broccoli, sweet potato, zucchini, batter, soy sauce', category: 'VEGETABLES', kcal100g: 185, proteins: 3.0, fats: 10.0, carbs: 21.0,imageUrl: 'assets/images/mains/132.jpeg'),
  FoodItem(name: 'Caprese Salad', desc: 'tomato, mozzarella, basil, olive oil, balsamic, salt', category: 'VEGETABLES', kcal100g: 145, proteins: 7.0, fats: 11.0, carbs: 4.0,imageUrl: 'assets/images/mains/133.jpeg'),
  FoodItem(name: 'Shakshuka', desc: 'eggs, tomato, pepper, onion, garlic, cumin, paprika', category: 'VEGETABLES', kcal100g: 120, proteins: 7.0, fats: 7.0, carbs: 7.0,imageUrl: 'assets/images/mains/134.jpeg'),
  FoodItem(name: 'Roasted Cauliflower', desc: 'cauliflower, olive oil, garlic, turmeric, herbs, lemon', category: 'VEGETABLES', kcal100g: 85, proteins: 3.0, fats: 5.0, carbs: 7.0,imageUrl: 'assets/images/mains/135.jpeg'),
  FoodItem(name: 'Stuffed Zucchini', desc: 'zucchini, rice, tomato, onion, herbs, olive oil', category: 'VEGETABLES', kcal100g: 100, proteins: 3.0, fats: 4.0, carbs: 12.0,imageUrl: 'assets/images/mains/136.jpeg'),
  FoodItem(name: 'Buddha Bowl', desc: 'quinoa, chickpeas, avocado, greens, tahini, vegetables', category: 'VEGETABLES', kcal100g: 145, proteins: 6.0, fats: 7.0, carbs: 16.0,imageUrl: 'assets/images/mains/137.jpeg'),
  FoodItem(name: 'Greek Salad', desc: 'tomato, cucumber, olives, feta, onion, olive oil, oregano', category: 'VEGETABLES', kcal100g: 115, proteins: 3.5, fats: 9.0, carbs: 5.0,imageUrl: 'assets/images/mains/138.jpeg'),
  FoodItem(name: 'Bok Choy Stir Fry', desc: 'bok choy, garlic, ginger, soy sauce, sesame oil', category: 'VEGETABLES', kcal100g: 65, proteins: 2.5, fats: 3.5, carbs: 5.0,imageUrl: 'assets/images/mains/139.jpeg'),
  FoodItem(name: 'Baba Ganoush', desc: 'eggplant, tahini, garlic, lemon, olive oil, parsley', category: 'VEGETABLES', kcal100g: 90, proteins: 2.5, fats: 6.0, carbs: 6.0,imageUrl: 'assets/images/mains/140.jpeg'),
  FoodItem(name: 'Panzanella', desc: 'tomato, bread, cucumber, basil, olive oil, vinegar', category: 'VEGETABLES', kcal100g: 130, proteins: 3.0, fats: 5.0, carbs: 18.0,imageUrl: 'assets/images/mains/141.jpeg'),
  FoodItem(name: 'Mushroom Stroganoff', desc: 'mushrooms, onion, cream, butter, garlic, paprika, herbs', category: 'VEGETABLES', kcal100g: 135, proteins: 3.0, fats: 9.0, carbs: 8.0,imageUrl: 'assets/images/mains/142.jpeg'),

  // EGGS
  FoodItem(name: 'Omelette', desc: 'eggs, milk, butter, salt, pepper', category: 'EGGS', kcal100g: 150, proteins: 10.0, fats: 11.0, carbs: 2.0,imageUrl: 'assets/images/mains/143.jpeg'),
  FoodItem(name: 'Scrambled Eggs', desc: 'eggs, butter, milk, salt, herbs', category: 'EGGS', kcal100g: 160, proteins: 11.0, fats: 12.0, carbs: 1.5,imageUrl: 'assets/images/mains/144.jpeg'),
  FoodItem(name: 'Eggs Benedict', desc: 'eggs, ham, english muffin, hollandaise, butter', category: 'EGGS', kcal100g: 220, proteins: 11.0, fats: 15.0, carbs: 12.0,imageUrl: 'assets/images/mains/145.jpeg'),
  FoodItem(name: 'Frittata', desc: 'eggs, zucchini, peppers, onion, cheese, olive oil', category: 'EGGS', kcal100g: 165, proteins: 11.0, fats: 12.0, carbs: 3.0,imageUrl: 'assets/images/mains/146.jpeg'),
  FoodItem(name: 'Quiche Lorraine', desc: 'eggs, cream, bacon, cheese, pastry, nutmeg', category: 'EGGS', kcal100g: 270, proteins: 9.0, fats: 20.0, carbs: 14.0,imageUrl: 'assets/images/mains/147.jpeg'),
  FoodItem(name: 'Egg Fried Rice', desc: 'rice, egg, soy sauce, sesame oil, scallions, vegetables', category: 'EGGS', kcal100g: 170, proteins: 6.0, fats: 6.0, carbs: 24.0,imageUrl: 'assets/images/mains/148.jpeg'),
  FoodItem(name: 'Deviled Eggs', desc: 'eggs, mayo, mustard, paprika, herbs, salt', category: 'EGGS', kcal100g: 185, proteins: 10.0, fats: 15.0, carbs: 2.0,imageUrl: 'assets/images/mains/149.jpeg'),
  FoodItem(name: 'Poached Eggs on Toast', desc: 'eggs, bread, butter, herbs, salt, pepper', category: 'EGGS', kcal100g: 175, proteins: 9.0, fats: 9.0, carbs: 15.0,imageUrl: 'assets/images/mains/150.jpeg'),
  FoodItem(name: 'Egg Drop Soup', desc: 'eggs, broth, cornstarch, scallions, sesame oil, ginger', category: 'EGGS', kcal100g: 55, proteins: 4.0, fats: 3.0, carbs: 2.0,imageUrl: 'assets/images/mains/151.jpeg'),
  FoodItem(name: 'Baked Eggs in Tomato', desc: 'eggs, tomato, garlic, herbs, olive oil, feta', category: 'EGGS', kcal100g: 130, proteins: 8.0, fats: 9.0, carbs: 4.0,imageUrl: 'assets/images/mains/152.jpeg'),
  FoodItem(name: 'Japanese Tamagoyaki', desc: 'eggs, mirin, soy sauce, dashi, sugar, oil', category: 'EGGS', kcal100g: 145, proteins: 9.0, fats: 9.0, carbs: 5.0,imageUrl: 'assets/images/mains/153.jpeg'),
  FoodItem(name: 'Egg Salad', desc: 'eggs, mayo, mustard, celery, dill, salt, pepper', category: 'EGGS', kcal100g: 195, proteins: 10.0, fats: 17.0, carbs: 2.0,imageUrl: 'assets/images/mains/154.jpeg'),
  FoodItem(name: 'Huevos Rancheros', desc: 'eggs, tortilla, tomato salsa, beans, cheese, avocado', category: 'EGGS', kcal100g: 185, proteins: 9.0, fats: 10.0, carbs: 16.0,imageUrl: 'assets/images/mains/155.jpeg'),
  FoodItem(name: 'Cloud Eggs', desc: 'eggs, parmesan, herbs, salt, pepper, butter', category: 'EGGS', kcal100g: 155, proteins: 12.0, fats: 11.0, carbs: 1.0,imageUrl: 'assets/images/mains/156.jpeg'),
  FoodItem(name: 'Menemen', desc: 'eggs, tomato, green pepper, onion, olive oil, spices', category: 'EGGS', kcal100g: 125, proteins: 7.0, fats: 9.0, carbs: 4.0,imageUrl: 'assets/images/mains/157.jpeg'),

];

@override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    final List<FoodItem> filteredItems = selectedCat == 'ALL' 
        ? mainDatabase 
        : mainDatabase.where((item) => item.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: copperGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('MAIN DISHES', 
          style: TextStyle(color: copperGold, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterPanel(screenWidth),
          Expanded(
            child: filteredItems.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) => _buildMainCard(filteredItems[index], screenWidth),
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
                color: isActive ? copperGold : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: copperGold.withOpacity(0.5), width: 0.8),
              ),
              alignment: Alignment.center,
              child: Text(categories[index],
                style: TextStyle(
                  color: isActive ? Colors.black : copperGold, 
                  fontWeight: FontWeight.bold, 
                  fontSize: screenWidth * 0.03
                )),
            ),
          );
        },
      ),
    );
  }

  /*Widget _buildMainCard(FoodItem item, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [copperGold, deepShadow], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (widget.mealName != 'ARCHIVE') _showPortionDialog(item, screenWidth);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            children: [
              // 1. КАРТИНКА
              Hero(
                tag: item.imageUrl ?? item.name,
                child: Container(
                  width: screenWidth * 0.13,
                  height: screenWidth * 0.13,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.imageUrl != null 
                        ? Image.asset(item.imageUrl!, fit: BoxFit.cover) 
                        : Icon(Icons.restaurant, color: milkWhite.withOpacity(0.5)),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // 2. ИНФО (Название и БЖУ)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.name.toUpperCase(), 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: milkWhite, fontWeight: FontWeight.w900, fontSize: screenWidth * 0.032, letterSpacing: 1.1)),
                    const SizedBox(height: 2),
                    Text(item.desc, 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: milkWhite.withOpacity(0.7), fontSize: screenWidth * 0.028)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildMacro('P', item.proteins, screenWidth),
                        _buildMacro('F', item.fats, screenWidth),
                        _buildMacro('C', item.carbs, screenWidth),
                      ],
                    )
                  ],
                ),
              ),

              // 3. ПРАВАЯ ЧАСТЬ (Ккал + Кнопка)
              SizedBox(
                width: screenWidth * 0.30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${item.kcal100g.toInt()} kcal', 
                          style: TextStyle(color: milkWhite, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035)),
                        Text('per 100g', 
                          style: TextStyle(color: milkWhite.withOpacity(0.6), fontSize: screenWidth * 0.022)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    
                    // УМНАЯ КНОПКА
                    widget.imageFile == null 
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.add_circle_outline, color: milkWhite, size: screenWidth * 0.075),
                        onPressed: () {
                          if (widget.mealName == 'ARCHIVE') {
                            _showArchiveInfo(context);
                          } else {
                            _showPortionDialog(item, screenWidth);
                          }
                        },
                      )
                    : GestureDetector(
                        onTap: () {
                          if (widget.mealName == 'ARCHIVE') {
                            _showArchiveInfo(context);
                          } else {
                            _showLibrarySaveDialog(item); 
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: milkWhite, width: 1.5),
                          ),
                          child: Icon(Icons.biotech, color: milkWhite, size: screenWidth * 0.055),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }*/

  Widget _buildMainCard(FoodItem item, double screenWidth) {
    return Container(
      width: double.infinity, // Растягиваем карточку полностью
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [copperGold, deepShadow], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          if (widget.mealName != 'ARCHIVE') _showPortionDialog(item, screenWidth);
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Ужали отступы для SE
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. КАРТИНКА (С увеличением)
              GestureDetector(
                onTap: () {
                  if (item.imageUrl != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(imagePath: item.imageUrl!),
                      ),
                    );
                  }
                },
                child: Hero(
                  tag: item.imageUrl ?? item.name,
                  child: Container(
                    width: screenWidth * 0.13,
                    height: screenWidth * 0.13,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: item.imageUrl != null 
                          ? Image.asset(item.imageUrl!, fit: BoxFit.cover) 
                          : Icon(Icons.restaurant, color: milkWhite.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // 2. ИНФО (Центральная гибкая часть)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name.toUpperCase(), 
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: milkWhite, 
                        fontWeight: FontWeight.w900, 
                        fontSize: screenWidth * 0.032, 
                        letterSpacing: 0.5 // УМЕНЬШИЛИ, чтобы не вылетало
                      )
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.desc, 
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(color: milkWhite.withOpacity(0.7), fontSize: screenWidth * 0.026)
                    ),
                    // Внутри Column, после описания (item.desc)
const SizedBox(height: 4),
FittedBox(
  fit: BoxFit.scaleDown,
  alignment: Alignment.centerLeft,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      _buildMacro('P', item.proteins, screenWidth),
      _buildMacro('F', item.fats, screenWidth),
      _buildMacro('C', item.carbs, screenWidth),
      // Если где-то затесался сахар (S), он тоже влезет
    ],
  ),
),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 3. ПРАВАЯ ЧАСТЬ (Адаптивная умная кнопка)
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${item.kcal100g.toInt()} kcal', 
                        style: TextStyle(color: milkWhite, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.034)),
                      Text('per 100g', 
                        style: TextStyle(color: milkWhite.withOpacity(0.6), fontSize: screenWidth * 0.02)),
                    ],
                  ),
                  const SizedBox(width: 6),
                  
                  // УМНАЯ КНОПКА
                  widget.imageFile == null 
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.add_circle_outline, color: milkWhite, size: screenWidth * 0.075),
                      onPressed: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showPortionDialog(item, screenWidth);
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showLibrarySaveDialog(item); 
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: milkWhite, width: 1.5),
                        ),
                        child: Icon(Icons.biotech, color: milkWhite, size: screenWidth * 0.055),
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

  Widget _buildMacro(String label, double val, double screenWidth) {
  return Padding(
    padding: EdgeInsets.only(right: screenWidth * 0.015), 
    child: Text(
      // Делаем как в супах: только число без .0 и без 'g'
      '$label: ${val.toStringAsFixed(0)}', 
      style: TextStyle(
        color: milkWhite.withOpacity(0.9), 
        fontWeight: FontWeight.bold, 
        fontSize: screenWidth * 0.024 
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

  void _showPortionDialog(FoodItem item, double screenWidth) {
    final TextEditingController controller = TextEditingController(text: '200');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: copperGold), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: const TextStyle(color: copperGold, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter weight (grams):', style: TextStyle(color: milkWhite, fontSize: 12)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: copperGold, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: copperGold)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: copperGold)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: copperGold),
            onPressed: () {
              double weight = double.tryParse(controller.text) ?? 200;
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
                  SnackBar(content: Text('Added to ${widget.mealName}!'), backgroundColor: copperGold)
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
        shape: RoundedRectangleBorder(side: const BorderSide(color: copperGold), borderRadius: BorderRadius.circular(15)),
        title: const Text("SAVE TO LIBRARY?", style: TextStyle(color: copperGold, fontSize: 14)),
        content: Text("Do you want to save ${item.name} with your photo?", 
          style: const TextStyle(color: milkWhite, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: copperGold),
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