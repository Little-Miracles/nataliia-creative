import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/global_data.dart';
import 'package:smart_body_life/screens/functional_screen.dart';
import '../providers/metrics_provider.dart';

class BasicItem {
  final String name;
  final String desc;
  final String category;
  final double kcal100g;
  final double p;
  final double f;
  final double c;
  final String icon;
  final String? imageUrl; 

  BasicItem({
    required this.name, required this.desc, required this.category,
    required this.kcal100g, required this.p, required this.f, required this.c,
    required this.icon,this.imageUrl,
  });
}

class BasicsScreen extends StatefulWidget {
  final String mealName;
  final File? imageFile; // 1. ДОБАВЬ ЭТУ СТРОКУ
  const BasicsScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<BasicsScreen> createState() => _BasicsScreenState();
}

class _BasicsScreenState extends State<BasicsScreen> {
  final Color sandGold = const Color(0xFFC2B280); // Песочное золото для основ
  String selectedCat = 'ALL';

  final List<String> categories = ['ALL', 'BREAD', 'DAIRY', 'OILS', 'SAUCES', 'SPICES', 'PASTA', 'CEREALS', 'SWEETENERS', 'VINEGAR'];

  final List<BasicItem> basicsDatabase = [
    // BREAD
    BasicItem(name: 'Rye Bread', desc: 'dark, fiber, sour', category: 'BREAD', kcal100g: 250, p: 8.5, f: 3.3, c: 48, icon: '🍞'),
    BasicItem(name: 'Wheat Bread', desc: 'white, soft, classic', category: 'BREAD', kcal100g: 265, p: 9, f: 3.2, c: 49, icon: '🥖'),
    BasicItem(name: 'Toast Bread', desc: 'for sandwich, crispy', category: 'BREAD', kcal100g: 290, p: 8, f: 4, c: 52, icon: '🥪'),
    BasicItem(name: 'Whole Grain', desc: 'healthy, seeds, fiber', category: 'BREAD', kcal100g: 245, p: 10, f: 4, c: 42, icon: '🍞'),
    BasicItem(name: 'Borodinsky', desc: 'rye, coriander, dark', category: 'BREAD', kcal100g: 208, p: 7, f: 1.2, c: 40, icon: '🍞'),
    BasicItem(name: 'Baguette', desc: 'French, crispy crust, airy', category: 'BREAD', kcal100g: 270, p: 9, f: 1.5, c: 55, icon: '🥖'),
BasicItem(name: 'Ciabatta', desc: 'Italian, porous, olive oil', category: 'BREAD', kcal100g: 260, p: 8, f: 2.5, c: 50, icon: '🍞'),
BasicItem(name: 'Sourdough', desc: 'fermented, tangy, artisan', category: 'BREAD', kcal100g: 230, p: 8, f: 1.5, c: 45, icon: '🍞'),
BasicItem(name: 'Pita Bread', desc: 'flat, Middle Eastern, pocket', category: 'BREAD', kcal100g: 275, p: 9, f: 1.5, c: 55, icon: '🫓'),
BasicItem(name: 'Flatbread', desc: 'thin, versatile, quick', category: 'BREAD', kcal100g: 300, p: 8, f: 4, c: 58, icon: '🫓'),
BasicItem(name: 'Corn Bread', desc: 'sweet, crumbly, American', category: 'BREAD', kcal100g: 310, p: 7, f: 9, c: 50, icon: '🌽'),
BasicItem(name: 'Multigrain', desc: 'seeds, grains, healthy', category: 'BREAD', kcal100g: 250, p: 10, f: 4.5, c: 43, icon: '🍞'),
BasicItem(name: 'Gluten Free', desc: 'rice flour, light, special diet', category: 'BREAD', kcal100g: 240, p: 4, f: 3, c: 50, icon: '🍞'),
BasicItem(name: 'Lavash', desc: 'thin, Armenian, wrap', category: 'BREAD', kcal100g: 277, p: 9, f: 1.5, c: 57, icon: '🫓'),
BasicItem(name: 'Focaccia', desc: 'Italian, herbs, olive oil', category: 'BREAD', kcal100g: 290, p: 7, f: 8, c: 47, icon: '🍞'),

    // DAIRY (Сметана и масло)
    BasicItem(name: 'Sour Cream 15%', desc: 'light, for soups', category: 'DAIRY', kcal100g: 160, p: 2.6, f: 15, c: 3, icon: '🥛'),
    BasicItem(name: 'Sour Cream 20%', desc: 'classic, rich', category: 'DAIRY', kcal100g: 204, p: 2.5, f: 20, c: 3, icon: '🥛'),
    BasicItem(name: 'Butter 82%', desc: 'creamy, natural', category: 'DAIRY', kcal100g: 748, p: 0.8, f: 82, c: 0.8, icon: '🧈'),
    BasicItem(name: 'Milk 2.5%', desc: 'classic, calcium, protein', category: 'DAIRY', kcal100g: 52, p: 2.9, f: 2.5, c: 4.7, icon: '🥛'),
BasicItem(name: 'Milk 3.2%', desc: 'whole, rich, natural', category: 'DAIRY', kcal100g: 60, p: 3.2, f: 3.2, c: 4.8, icon: '🥛'),
BasicItem(name: 'Kefir 1%', desc: 'light, probiotic, digestive', category: 'DAIRY', kcal100g: 40, p: 2.8, f: 1, c: 4, icon: '🥛'),
BasicItem(name: 'Kefir 2.5%', desc: 'classic, probiotic, fresh', category: 'DAIRY', kcal100g: 53, p: 2.9, f: 2.5, c: 4, icon: '🥛'),
BasicItem(name: 'Cottage Cheese 5%', desc: 'protein, light, fresh', category: 'DAIRY', kcal100g: 121, p: 17, f: 5, c: 2.5, icon: '🧀'),
BasicItem(name: 'Cottage Cheese 9%', desc: 'creamy, protein, rich', category: 'DAIRY', kcal100g: 159, p: 16, f: 9, c: 2, icon: '🧀'),
BasicItem(name: 'Greek Yogurt', desc: 'thick, protein, probiotic', category: 'DAIRY', kcal100g: 59, p: 10, f: 0.4, c: 3.6, icon: '🥛'),
BasicItem(name: 'Ryazhenka', desc: 'baked milk, creamy, warm', category: 'DAIRY', kcal100g: 85, p: 3, f: 4, c: 5, icon: '🥛'),
BasicItem(name: 'Cream 10%', desc: 'light cream, for coffee', category: 'DAIRY', kcal100g: 119, p: 3, f: 10, c: 4, icon: '🥛'),
BasicItem(name: 'Cream 33%', desc: 'heavy, for whipping', category: 'DAIRY', kcal100g: 322, p: 2.2, f: 33, c: 3.7, icon: '🥛'),
BasicItem(name: 'Ghee', desc: 'clarified butter, rich, Ayurvedic', category: 'DAIRY', kcal100g: 900, p: 0, f: 99, c: 0, icon: '🧈'),
BasicItem(name: 'Condensed Milk', desc: 'sweet, thick, indulgent', category: 'DAIRY', kcal100g: 328, p: 7.2, f: 8.5, c: 55, icon: '🥛'),

    // OILS
    BasicItem(name: 'Olive Oil', desc: 'extra virgin, salads', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🫒'),
    BasicItem(name: 'Sunflower Oil', desc: 'unrefined, smell of home', category: 'OILS', kcal100g: 899, p: 0, f: 99.9, c: 0, icon: '🌻'),
    BasicItem(name: 'Coconut Oil', desc: 'tropical, medium-chain fats', category: 'OILS', kcal100g: 862, p: 0, f: 99, c: 0, icon: '🥥'),
BasicItem(name: 'Flaxseed Oil', desc: 'omega-3, cold pressed, nutty', category: 'OILS', kcal100g: 884, p: 0, f: 99.8, c: 0, icon: '🌱'),
BasicItem(name: 'Corn Oil', desc: 'neutral, for frying', category: 'OILS', kcal100g: 900, p: 0, f: 100, c: 0, icon: '🌽'),
BasicItem(name: 'Sesame Oil', desc: 'toasted, aromatic, Asian', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🌿'),
BasicItem(name: 'Pumpkin Seed Oil', desc: 'nutty, vitamins, salads', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🎃'),
BasicItem(name: 'Walnut Oil', desc: 'rich, omega-3, salads', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🌰'),
BasicItem(name: 'Avocado Oil', desc: 'high smoke point, neutral', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🥑'),
BasicItem(name: 'Butter 72%', desc: 'light, for spreading', category: 'OILS', kcal100g: 663, p: 0.9, f: 72, c: 1, icon: '🧈'),
BasicItem(name: 'Rapeseed Oil', desc: 'light, neutral, cooking', category: 'OILS', kcal100g: 884, p: 0, f: 99.9, c: 0, icon: '🌼'),
BasicItem(name: 'Grape Seed Oil', desc: 'light, high smoke point', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🍇'),
BasicItem(name: 'Almond Oil', desc: 'delicate, vitamin e, salads', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🌰'),
BasicItem(name: 'Hemp Oil', desc: 'omega-3, omega-6, earthy', category: 'OILS', kcal100g: 884, p: 0, f: 100, c: 0, icon: '🌿'),
BasicItem(name: 'Margarine', desc: 'plant-based, for baking', category: 'OILS', kcal100g: 718, p: 0.5, f: 80, c: 1, icon: '🧈'),
    
    // SAUCES (Аджика, горчица)
    BasicItem(name: 'Adjika Hot', desc: 'spicy, pepper, garlic', category: 'SAUCES', kcal100g: 60, p: 1, f: 3, c: 7, icon: '🌶️'),
    BasicItem(name: 'Mustard', desc: 'sharp, for meat', category: 'SAUCES', kcal100g: 160, p: 9, f: 6, c: 10, icon: '🍯'),
    BasicItem(name: 'Horseradish', desc: 'very spicy, root', category: 'SAUCES', kcal100g: 110, p: 3, f: 0.5, c: 13, icon: '🧪'),
    BasicItem(name: 'Soy Sauce', desc: 'salty, for everything', category: 'SAUCES', kcal100g: 53, p: 8, f: 0, c: 5, icon: '🧴'),
  BasicItem(name: 'Ketchup', desc: 'tomato, sweet, classic', category: 'SAUCES', kcal100g: 100, p: 1.5, f: 0.1, c: 24, icon: '🍅'),
BasicItem(name: 'Mayonnaise', desc: 'creamy, rich, classic', category: 'SAUCES', kcal100g: 680, p: 2.5, f: 74, c: 3, icon: '🥚'),
BasicItem(name: 'Tkemali', desc: 'Georgian plum sauce, sour', category: 'SAUCES', kcal100g: 72, p: 0.8, f: 0.3, c: 17, icon: '🍒'),
BasicItem(name: 'Pesto', desc: 'basil, parmesan, pine nuts', category: 'SAUCES', kcal100g: 350, p: 7, f: 34, c: 5, icon: '🌿'),
BasicItem(name: 'Tabasco', desc: 'very hot, vinegar, pepper', category: 'SAUCES', kcal100g: 12, p: 0.5, f: 0.2, c: 1, icon: '🌶️'),
BasicItem(name: 'Teriyaki Sauce', desc: 'sweet, soy, Japanese', category: 'SAUCES', kcal100g: 89, p: 4, f: 0, c: 18, icon: '🍱'),
BasicItem(name: 'Worcestershire', desc: 'complex, umami, British', category: 'SAUCES', kcal100g: 78, p: 1.5, f: 0, c: 19, icon: '🧴'),
BasicItem(name: 'Tartar Sauce', desc: 'mayo, pickles, for fish', category: 'SAUCES', kcal100g: 320, p: 1.5, f: 33, c: 5, icon: '🐟'),
BasicItem(name: 'Tomato Paste', desc: 'concentrated, rich, cooking base', category: 'SAUCES', kcal100g: 82, p: 4.5, f: 0.5, c: 15, icon: '🍅'),
BasicItem(name: 'Fish Sauce', desc: 'umami, salty, Asian', category: 'SAUCES', kcal100g: 35, p: 5, f: 0, c: 3.5, icon: '🐟'),
BasicItem(name: 'Sriracha', desc: 'hot, garlic, chili, Asian', category: 'SAUCES', kcal100g: 93, p: 1.5, f: 0.5, c: 20, icon: '🌶️'),
 // 🧂 SPICES (новая категория)
// ─────────────────────────────────────────────
BasicItem(name: 'Salt', desc: 'classic, mineral, essential', category: 'SPICES', kcal100g: 0, p: 0, f: 0, c: 0, icon: '🧂'),
BasicItem(name: 'Black Pepper', desc: 'sharp, aromatic, universal', category: 'SPICES', kcal100g: 255, p: 10, f: 3, c: 64, icon: '🌑'),
BasicItem(name: 'Red Pepper', desc: 'hot, capsaicin, spicy', category: 'SPICES', kcal100g: 318, p: 12, f: 17, c: 56, icon: '🌶️'),
BasicItem(name: 'Paprika', desc: 'sweet, smoky, colorful', category: 'SPICES', kcal100g: 282, p: 14, f: 13, c: 54, icon: '🫑'),
BasicItem(name: 'Turmeric', desc: 'golden, anti-inflammatory, earthy', category: 'SPICES', kcal100g: 354, p: 8, f: 10, c: 65, icon: '🟡'),
BasicItem(name: 'Cumin', desc: 'warm, earthy, Middle Eastern', category: 'SPICES', kcal100g: 375, p: 18, f: 22, c: 44, icon: '🌿'),
BasicItem(name: 'Coriander', desc: 'citrusy, aromatic, versatile', category: 'SPICES', kcal100g: 298, p: 12, f: 18, c: 55, icon: '🌿'),
BasicItem(name: 'Cinnamon', desc: 'sweet, warm, baking spice', category: 'SPICES', kcal100g: 247, p: 4, f: 1.2, c: 81, icon: '🟤'),
BasicItem(name: 'Garlic Powder', desc: 'concentrated, universal, aromatic', category: 'SPICES', kcal100g: 331, p: 17, f: 0.7, c: 73, icon: '🧄'),
BasicItem(name: 'Dried Basil', desc: 'Italian, aromatic, sweet', category: 'SPICES', kcal100g: 233, p: 23, f: 4, c: 48, icon: '🌿'),
 BasicItem(name: 'Oregano', desc: 'Mediterranean, pizza, fragrant', category: 'SPICES', kcal100g: 265, p: 11, f: 4, c: 69, icon: '🌿'),
BasicItem(name: 'Rosemary', desc: 'pine-like, meat, Mediterranean', category: 'SPICES', kcal100g: 331, p: 5, f: 15, c: 65, icon: '🌿'),
BasicItem(name: 'Bay Leaf', desc: 'soups, stews, aromatic', category: 'SPICES', kcal100g: 313, p: 8, f: 8, c: 75, icon: '🍃'),
BasicItem(name: 'Cloves', desc: 'intense, warm, baking', category: 'SPICES', kcal100g: 274, p: 6, f: 13, c: 66, icon: '🌰'),
BasicItem(name: 'Cardamom', desc: 'exotic, floral, tea spice', category: 'SPICES', kcal100g: 311, p: 11, f: 7, c: 68, icon: '🫛'),

// ─────────────────────────────────────────────
// 🍝 PASTA (новая категория)
// ─────────────────────────────────────────────
BasicItem(name: 'Spaghetti', desc: 'classic, thin, Italian', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Penne', desc: 'tubes, sauce holds well', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Fusilli', desc: 'spiral, holds sauce, fun', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Fettuccine', desc: 'flat, wide, creamy sauces', category: 'PASTA', kcal100g: 350, p: 13, f: 2, c: 71, icon: '🍝'),
BasicItem(name: 'Linguine', desc: 'flat, thin, seafood pairing', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Lasagna Sheets', desc: 'layered, wide, baked dishes', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Farfalle', desc: 'bow-tie, salads, light sauces', category: 'PASTA', kcal100g: 350, p: 12, f: 1.5, c: 72, icon: '🦋'),
BasicItem(name: 'Rigatoni', desc: 'ridged tubes, chunky sauces', category: 'PASTA', kcal100g: 350, p: 13, f: 1.5, c: 72, icon: '🍝'),
BasicItem(name: 'Orzo', desc: 'rice-shaped, soups, salads', category: 'PASTA', kcal100g: 350, p: 12, f: 1.5, c: 72, icon: '🍚'),
BasicItem(name: 'Whole Wheat Pasta', desc: 'healthy, fiber, nutty taste', category: 'PASTA', kcal100g: 330, p: 14, f: 2, c: 66, icon: '🌾'),
BasicItem(name: 'Rice Noodles', desc: 'gluten-free, Asian, light', category: 'PASTA', kcal100g: 364, p: 6, f: 0.6, c: 80, icon: '🍜'),
BasicItem(name: 'Soba Noodles', desc: 'buckwheat, Japanese, nutty', category: 'PASTA', kcal100g: 336, p: 14, f: 1, c: 74, icon: '🍜'),
BasicItem(name: 'Udon Noodles', desc: 'thick, Japanese, chewy', category: 'PASTA', kcal100g: 132, p: 3.5, f: 0.6, c: 28, icon: '🍜'),
BasicItem(name: 'Egg Noodles', desc: 'rich, golden, soups', category: 'PASTA', kcal100g: 138, p: 4.5, f: 2, c: 25, icon: '🍝'),
BasicItem(name: 'Vermicelli', desc: 'very thin, soups, Asian', category: 'PASTA', kcal100g: 350, p: 12, f: 1.5, c: 72, icon: '🍝'),

// ─────────────────────────────────────────────
// 🌾 CEREALS (новая категория)
// ─────────────────────────────────────────────
BasicItem(name: 'Oatmeal', desc: 'classic, fiber, breakfast', category: 'CEREALS', kcal100g: 350, p: 13, f: 7, c: 62, icon: '🥣'),
BasicItem(name: 'Buckwheat', desc: 'earthy, iron, gluten-free', category: 'CEREALS', kcal100g: 343, p: 13, f: 3.4, c: 72, icon: '🌾'),
BasicItem(name: 'Rice White', desc: 'light, neutral, classic', category: 'CEREALS', kcal100g: 365, p: 7, f: 0.7, c: 80, icon: '🍚'),
BasicItem(name: 'Rice Brown', desc: 'whole grain, fiber, nutty', category: 'CEREALS', kcal100g: 362, p: 8, f: 2.7, c: 76, icon: '🍚'),
BasicItem(name: 'Millet', desc: 'light, gluten-free, golden', category: 'CEREALS', kcal100g: 378, p: 11, f: 4, c: 75, icon: '🌾'),
BasicItem(name: 'Barley', desc: 'hearty, fiber, soups', category: 'CEREALS', kcal100g: 352, p: 10, f: 2.3, c: 73, icon: '🌾'),
BasicItem(name: 'Semolina', desc: 'fine, smooth porridge, classic', category: 'CEREALS', kcal100g: 360, p: 11, f: 1, c: 73, icon: '🥣'),
BasicItem(name: 'Corn Grits', desc: 'polenta base, golden, filling', category: 'CEREALS', kcal100g: 362, p: 8, f: 1.5, c: 79, icon: '🌽'),
BasicItem(name: 'Quinoa', desc: 'complete protein, superfood', category: 'CEREALS', kcal100g: 368, p: 14, f: 6, c: 64, icon: '🌱'),
BasicItem(name: 'Spelt', desc: 'ancient grain, nutty, fiber', category: 'CEREALS', kcal100g: 338, p: 15, f: 2.4, c: 70, icon: '🌾'),
BasicItem(name: 'Bulgur', desc: 'pre-cooked wheat, quick, nutty', category: 'CEREALS', kcal100g: 342, p: 12, f: 1.3, c: 76, icon: '🌾'),
BasicItem(name: 'Couscous', desc: 'North African, quick, light', category: 'CEREALS', kcal100g: 376, p: 13, f: 0.6, c: 77, icon: '🌾'),
BasicItem(name: 'Flax Porridge', desc: 'omega-3, fiber, healthy', category: 'CEREALS', kcal100g: 270, p: 12, f: 10, c: 40, icon: '🌱'),
BasicItem(name: 'Amaranth', desc: 'ancient, protein, gluten-free', category: 'CEREALS', kcal100g: 371, p: 14, f: 7, c: 65, icon: '🌿'),
BasicItem(name: 'Instant Oats', desc: 'quick, breakfast, convenient', category: 'CEREALS', kcal100g: 352, p: 12, f: 6, c: 60, icon: '🥣'),

// ─────────────────────────────────────────────
// 🍬 SWEETENERS (новая категория)
// ─────────────────────────────────────────────
BasicItem(name: 'Sugar White', desc: 'classic, refined, sweet', category: 'SWEETENERS', kcal100g: 399, p: 0, f: 0, c: 100, icon: '🍬'),
BasicItem(name: 'Brown Sugar', desc: 'molasses, caramel notes', category: 'SWEETENERS', kcal100g: 380, p: 0.1, f: 0, c: 98, icon: '🟤'),
BasicItem(name: 'Honey', desc: 'natural, floral, antioxidants', category: 'SWEETENERS', kcal100g: 304, p: 0.3, f: 0, c: 82, icon: '🍯'),
BasicItem(name: 'Maple Syrup', desc: 'Canadian, rich, natural', category: 'SWEETENERS', kcal100g: 260, p: 0, f: 0.1, c: 67, icon: '🍁'),
BasicItem(name: 'Agave Syrup', desc: 'low GI, mild, vegan', category: 'SWEETENERS', kcal100g: 310, p: 0.1, f: 0.3, c: 76, icon: '🌵'),
BasicItem(name: 'Stevia', desc: 'zero calorie, plant-based', category: 'SWEETENERS', kcal100g: 0, p: 0, f: 0, c: 0, icon: '🌿'),
BasicItem(name: 'Coconut Sugar', desc: 'natural, caramel, lower GI', category: 'SWEETENERS', kcal100g: 375, p: 0, f: 0, c: 92, icon: '🥥'),
BasicItem(name: 'Fructose', desc: 'fruit sugar, low GI', category: 'SWEETENERS', kcal100g: 399, p: 0, f: 0, c: 100, icon: '🍬'),
BasicItem(name: 'Date Syrup', desc: 'natural, rich, fiber', category: 'SWEETENERS', kcal100g: 285, p: 1.5, f: 0.3, c: 72, icon: '🟤'),
BasicItem(name: 'Molasses', desc: 'dark, iron-rich, baking', category: 'SWEETENERS', kcal100g: 290, p: 0, f: 0.1, c: 75, icon: '🟫'),
BasicItem(name: 'Erythritol', desc: 'zero calorie, sugar alcohol', category: 'SWEETENERS', kcal100g: 20, p: 0, f: 0, c: 100, icon: '🍬'),
BasicItem(name: 'Xylitol', desc: 'dental friendly, low GI', category: 'SWEETENERS', kcal100g: 240, p: 0, f: 0, c: 100, icon: '🍬'),
BasicItem(name: 'Rice Syrup', desc: 'mild, natural, baking', category: 'SWEETENERS', kcal100g: 316, p: 0.3, f: 0, c: 77, icon: '🍚'),
BasicItem(name: 'Powdered Sugar', desc: 'fine, baking, decoration', category: 'SWEETENERS', kcal100g: 398, p: 0, f: 0, c: 100, icon: '🍬'),
BasicItem(name: 'Vanilla Sugar', desc: 'aromatic, baking, sweet', category: 'SWEETENERS', kcal100g: 395, p: 0, f: 0, c: 99, icon: '🌼'),

// ─────────────────────────────────────────────
// 🧪 VINEGAR (новая категория)
// ─────────────────────────────────────────────
BasicItem(name: 'Apple Cider Vinegar', desc: 'fermented, health benefits', category: 'VINEGAR', kcal100g: 22, p: 0, f: 0, c: 0.9, icon: '🍎'),
BasicItem(name: 'White Wine Vinegar', desc: 'light, salad dressings', category: 'VINEGAR', kcal100g: 18, p: 0.1, f: 0, c: 0.3, icon: '🍷'),
BasicItem(name: 'Red Wine Vinegar', desc: 'bold, Mediterranean, salads', category: 'VINEGAR', kcal100g: 19, p: 0.1, f: 0, c: 0.3, icon: '🍷'),
BasicItem(name: 'Balsamic Vinegar', desc: 'Italian, sweet, aged', category: 'VINEGAR', kcal100g: 88, p: 0.5, f: 0, c: 17, icon: '🫙'),
BasicItem(name: 'Rice Vinegar', desc: 'mild, Asian, sushi', category: 'VINEGAR', kcal100g: 18, p: 0.1, f: 0, c: 0.3, icon: '🍚'),
BasicItem(name: 'Table Vinegar 9%', desc: 'classic, sharp, universal', category: 'VINEGAR', kcal100g: 11, p: 0, f: 0, c: 0, icon: '🧪'),
BasicItem(name: 'Sherry Vinegar', desc: 'Spanish, nutty, complex', category: 'VINEGAR', kcal100g: 25, p: 0.1, f: 0, c: 2, icon: '🍾'),
BasicItem(name: 'Malt Vinegar', desc: 'British, for fish and chips', category: 'VINEGAR', kcal100g: 14, p: 0.1, f: 0, c: 0.5, icon: '🍺'),
BasicItem(name: 'Coconut Vinegar', desc: 'mild, probiotic, tropical', category: 'VINEGAR', kcal100g: 15, p: 0, f: 0, c: 0.5, icon: '🥥'),
BasicItem(name: 'Champagne Vinegar', desc: 'delicate, light, French', category: 'VINEGAR', kcal100g: 15, p: 0.1, f: 0, c: 0.2, icon: '🥂'),
BasicItem(name: 'Tarragon Vinegar', desc: 'herbal, aromatic, French', category: 'VINEGAR', kcal100g: 18, p: 0.1, f: 0, c: 0.5, icon: '🌿'),
BasicItem(name: 'Pomegranate Vinegar', desc: 'fruity, antioxidants, Middle East', category: 'VINEGAR', kcal100g: 30, p: 0.1, f: 0, c: 5, icon: '🍒'),
BasicItem(name: 'Plum Vinegar', desc: 'Japanese umeboshi, sour, salty', category: 'VINEGAR', kcal100g: 20, p: 0.1, f: 0, c: 1, icon: '🫐'),
BasicItem(name: 'Honey Vinegar', desc: 'sweet, mild, natural', category: 'VINEGAR', kcal100g: 25, p: 0, f: 0, c: 2, icon: '🍯'),
BasicItem(name: 'Fig Vinegar', desc: 'fruity, sweet, Mediterranean', category: 'VINEGAR', kcal100g: 28, p: 0.1, f: 0, c: 3, icon: '🍃'),
  
  ];

 @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    final List<BasicItem> filtered = selectedCat == 'ALL' 
        ? basicsDatabase 
        : basicsDatabase.where((i) => i.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: sandGold, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('BASICS', 
          style: TextStyle(color: sandGold, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilter(screenWidth), // Передаем screenWidth
          Expanded(
            child: filtered.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _buildCard(filtered[index], screenWidth),
                ),
          ),
        ],
      ),
    );
  }

 Widget _buildFilter(double screenWidth) {
    return Container(
      // Высота теперь четко привязана к ширине экрана (около 40-45 пикселей)
      height: screenWidth * 0.11, 
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: ListView.builder(
        scrollDirection: Axis.horizontal, 
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool active = selectedCat == categories[index];
          return GestureDetector(
            onTap: () => setState(() => selectedCat = categories[index]),
            child: Container(
              margin: EdgeInsets.only(right: screenWidth * 0.02), 
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              decoration: BoxDecoration(
                color: active ? sandGold : Colors.transparent, 
                borderRadius: BorderRadius.circular(5), // Сделали углы как в супах
                border: Border.all(color: sandGold.withOpacity(0.5))
              ),
              alignment: Alignment.center,
              child: Text(
                categories[index], 
                style: TextStyle(
                  color: active ? Colors.black : sandGold, 
                  fontWeight: FontWeight.bold, 
                  fontSize: screenWidth * 0.03 // Оптимальный размер шрифта
                )
              ),
            ),
          );
        },
      ),
    );
  }

/*Widget _buildCard(BasicItem item, double screenWidth) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [sandGold.withOpacity(0.8), const Color(0xFF0D0805)], 
        begin: Alignment.topLeft, 
        end: Alignment.bottomRight
      ),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: sandGold.withOpacity(0.2)),
    ),
    child: InkWell(
      // --- ВОТ ЭТОТ ТАКТ, КОТОРЫЙ Я ТЕРЯЛ ---
      onTap: () {
        if (widget.mealName != 'ARCHIVE') _showDialog(item, screenWidth);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Row(
          children: [
            // 1. ИКОНКА
            Container(
              width: screenWidth * 0.12,
              alignment: Alignment.centerLeft,
              child: Text(item.icon, style: TextStyle(fontSize: screenWidth * 0.08)),
            ),
            
            const SizedBox(width: 8),

            // 2. ЦЕНТРАЛЬНАЯ ЧАСТЬ (Название и БЖУ)
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item.name.toUpperCase(), 
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: screenWidth * 0.032, letterSpacing: 1.1)),
                  const SizedBox(height: 2),
                  Text("Nutritional Value", style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.025)),
                  Row(
                    children: [
                      Text('P: ${item.p.toStringAsFixed(0)} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                      Text('F: ${item.f.toStringAsFixed(0)} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                      Text('C: ${item.c.toStringAsFixed(0)} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
                    ],
                  )
                ],
              ),
            ),

            // 3. ПРАВАЯ ПАНЕЛЬ (Калории + Умная Кнопка)
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
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035)),
                      Text('per 100g', 
                        style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.022)),
                    ],
                  ),
                  const SizedBox(width: 8),
                  
                  // Кнопка (Плюс или Лаборатория)
                  widget.imageFile == null 
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.add_circle_outline, color: Colors.black, size: screenWidth * 0.075),
                      onPressed: () {
                        if (widget.mealName == 'ARCHIVE') {
                          _showArchiveInfo(context);
                        } else {
                          _showDialog(item, screenWidth);
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
                          border: Border.all(color: Colors.black, width: 1.5),
                        ),
                        child: Icon(Icons.biotech, color: Colors.black, size: screenWidth * 0.055),
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
Widget _buildCard(BasicItem item, double screenWidth) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [sandGold.withOpacity(0.8), const Color(0xFF0D0805)], 
        begin: Alignment.topLeft, 
        end: Alignment.bottomRight
      ),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: sandGold.withOpacity(0.2)),
    ),
    child: InkWell(
      onTap: () {
        if (widget.mealName != 'ARCHIVE') _showDialog(item, screenWidth);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Чуть уменьшили боковой отступ
        child: Row(
          children: [
            // 1. ИКОНКА (Компактная)
            Text(item.icon, style: TextStyle(fontSize: screenWidth * 0.07)),
            
            const SizedBox(width: 10),

            // 2. ЦЕНТРАЛЬНАЯ ЧАСТЬ (Гибкая)
            Expanded( 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name.toUpperCase(), 
                    overflow: TextOverflow.ellipsis, // Если не влезет — будет "..."
                    maxLines: 1, // Строго одна строка
                    style: TextStyle(
                      color: Colors.black, 
                      fontWeight: FontWeight.w900, 
                      fontSize: screenWidth * 0.03, // Чуть уменьшили шрифт для SE
                      letterSpacing: 0.5
                    )
                  ),
                  const SizedBox(height: 2),
                  // Nutritional Value — делаем мельче или убираем на очень узких экранах
                  Text("Value", style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.022)),
                  FittedBox(
  fit: BoxFit.scaleDown, // Используем масштаб, который только уменьшает, если не влезает
  alignment: Alignment.centerLeft, // А выравнивание пишем отдельно
  child: Row(
    children: [
      Text('P:${item.p.toInt()} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.024)),
      Text('F:${item.f.toInt()} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.024)),
      Text('C:${item.c.toInt()} ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.024)),
    ],
  ),
),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // 3. ПРАВАЯ ПАНЕЛЬ (Без жесткой ширины)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${item.kcal100g.toInt()} kcal', 
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.032)),
                    Text('per 100g', 
                      style: TextStyle(color: Colors.black54, fontSize: screenWidth * 0.02)),
                  ],
                ),
                const SizedBox(width: 6),
                
                // Кнопка (Плюс или Лаборатория)
                widget.imageFile == null 
                ? Icon(Icons.add_circle_outline, color: Colors.black, size: screenWidth * 0.065)
                : Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 1.2),
                    ),
                    child: Icon(Icons.biotech, color: Colors.black, size: screenWidth * 0.045),
                  ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showDialog(BasicItem item, double screenWidth) {
    final TextEditingController ctrl = TextEditingController(text: '30');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: BorderSide(color: sandGold), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: TextStyle(color: sandGold, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter weight (grams):', style: TextStyle(color: Colors.white70, fontSize: 12)),
            TextField(
              controller: ctrl,
              keyboardType: TextInputType.number,
              style: TextStyle(color: sandGold, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: sandGold.withOpacity(0.5))),
                labelText: 'Grams', labelStyle: const TextStyle(color: Colors.white54)
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: sandGold),
            onPressed: () {
              double w = double.tryParse(ctrl.text) ?? 30;
              double f = w / 100;
              final metrics = Provider.of<MetricsProvider>(context, listen: false);

              metrics.addMealData(
                mealName: widget.mealName, 
                foodName: item.name, 
                kcal: item.kcal100g * f, p: item.p * f, f: item.f * f, c: item.c * f,
                imagePath: widget.imageFile?.path, // Берем фото из сканера!
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
                  SnackBar(content: Text('${item.name} added!'), backgroundColor: sandGold),
                );
              }
            },
            child: const Text('ADD', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
  // Эта функция лечит твою ошибку!
  void _showArchiveInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("To add to Diary, please start from Breakfast/Lunch"),
        backgroundColor: Color.fromARGB(255, 88, 192, 196),
        duration: Duration(seconds: 2),
      ),
    );
  }
  void _showLibrarySaveDialog(BasicItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: BorderSide(color: sandGold), borderRadius: BorderRadius.circular(15)),
        title: const Text("SAVE TO LIBRARY?", style: TextStyle(color: Color(0xFFC2B280), fontSize: 14)),
        content: Text("Do you want to save ${item.name} with your photo?", 
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: sandGold),
            onPressed: () {
              globalLibrary.add(
                LibraryProduct(
                  name: item.name,
                  calories: item.kcal100g.toInt().toString(),
                  proteins: item.p.toString(),
                  fats: item.f.toString(),
                  carbs: item.c.toString(),
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
