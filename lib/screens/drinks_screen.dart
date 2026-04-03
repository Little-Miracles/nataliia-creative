import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_body_life/data/global_data.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/screens/functional_screen.dart';

// 1. Единая модель для напитков
class DrinksItem {
  final String name;
  final String desc;
  final String category;
  final String icon; // Новое поле
  final double kcal100g;
  final double proteins;
  final double fats;
  final double carbs;

  DrinksItem({
    required this.name,
    required this.desc,
    required this.category,
    required this.icon,
    required this.kcal100g,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });
}

// ТВОИ САПФИРОВЫЕ ЦВЕТА
const Color sapphire = Color(0xFF3565DE); 
const Color deepBlue = Color(0xFF020326);
const Color contentColor = Color(0xFFEDE6D6);

class DrinksScreen extends StatefulWidget {
  final String mealName; // <--- Добавь это
  final File? imageFile; // 1. ДОБАВЬ ЭТУ СТРОКУ
  const DrinksScreen({super.key, required this.mealName, this.imageFile});

  @override
  State<DrinksScreen> createState() => _DrinksScreenState();
}

class _DrinksScreenState extends State<DrinksScreen> {
  final List<String> categories = [
    'ALL', 'WATER', 'TEA', 'COFFEE', 'JUICE', 'FRESH', 'SOFT', 'ENERGY', 'SMOOTHIE', 'ALCOHOL'
  ];
  String selectedCat = 'ALL';


// ВНУТРИ _DrinksScreenState:
  final List<DrinksItem> drinksDatabase = [
    // WATER
    DrinksItem(name: 'Still Water', icon: '💧', desc: 'pure water, minerals', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Sparkling Water', icon: '🫧', desc: 'carbonated water, minerals', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Mineral Water Borjomi', icon: '🏔️', desc: 'natural mineral water', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Mineral Water Evian', icon: '🍶', desc: 'natural spring water, France', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Mineral Water San Pellegrino', icon: '🍶', desc: 'sparkling mineral water, Italy', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Coconut Water', icon: '🥥', desc: 'natural electrolytes, potassium', category: 'WATER', kcal100g: 19, proteins: 0.7, fats: 0.2, carbs: 3.7),
    DrinksItem(name: 'Alkaline Water', icon: '💎', desc: 'water, high pH, minerals', category: 'WATER', kcal100g: 0, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Flavoured Water Lemon', icon: '🍋', desc: 'water, lemon, no sugar', category: 'WATER', kcal100g: 2, proteins: 0, fats: 0, carbs: 0.4),
    DrinksItem(name: 'Flavoured Water Mint', icon: '🌱', desc: 'water, mint, no sugar', category: 'WATER', kcal100g: 2, proteins: 0, fats: 0, carbs: 0.3),
    // TEA
    DrinksItem(name: 'Black Tea', icon: '☕', desc: 'tea leaves, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Green Tea', icon: '🍵', desc: 'green tea leaves, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Herbal Tea', icon: '🌿', desc: 'herbs, chamomile, mint', category: 'TEA', kcal100g: 2, proteins: 0, fats: 0, carbs: 0.5),
    DrinksItem(name: 'Lemon Tea', icon: '🍋', desc: 'tea, lemon, sugar, water', category: 'TEA', kcal100g: 25, proteins: 0, fats: 0, carbs: 6),
    DrinksItem(name: 'White Tea', icon: '⚪', desc: 'white tea leaves, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Oolong Tea', icon: '🍂', desc: 'oolong tea leaves, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Chai Tea', icon: '🌶️', desc: 'tea, milk, spices', category: 'TEA', kcal100g: 40, proteins: 1.5, fats: 1.2, carbs: 6),
    DrinksItem(name: 'Matcha Tea', icon: '🍃', desc: 'matcha powder, hot water', category: 'TEA', kcal100g: 3, proteins: 0.3, fats: 0.1, carbs: 0.3),
    DrinksItem(name: 'Peppermint Tea', icon: '🌱', desc: 'peppermint leaves, water', category: 'TEA', kcal100g: 2, proteins: 0, fats: 0, carbs: 0.4),
    DrinksItem(name: 'Ginger Tea', icon: '🫚', desc: 'ginger root, honey, lemon', category: 'TEA', kcal100g: 20, proteins: 0, fats: 0, carbs: 5),
    DrinksItem(name: 'Chamomile Tea', icon: '🌼', desc: 'chamomile flowers, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0.2),
    DrinksItem(name: 'Rooibos Tea', icon: '🪵', desc: 'rooibos leaves, water', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0.1),
    DrinksItem(name: 'Earl Grey', icon: '🎩', desc: 'black tea, bergamot oil', category: 'TEA', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Bubble Tea', icon: '🧋', desc: 'tea, milk, tapioca pearls', category: 'TEA', kcal100g: 110, proteins: 1.5, fats: 2.0, carbs: 22),
    // COFFEE
    DrinksItem(name: 'Espresso', icon: '☕', desc: 'coffee beans, water', category: 'COFFEE', kcal100g: 2, proteins: 0.2, fats: 0.1, carbs: 0),
    DrinksItem(name: 'Americano', icon: '🥤', desc: 'espresso, water', category: 'COFFEE', kcal100g: 2, proteins: 0.2, fats: 0.1, carbs: 0),
    DrinksItem(name: 'Cappuccino', icon: '☁️', desc: 'espresso, milk, foam', category: 'COFFEE', kcal100g: 45, proteins: 2.5, fats: 2.0, carbs: 4.5),
    DrinksItem(name: 'Latte', icon: '🥛', desc: 'espresso, milk, foam', category: 'COFFEE', kcal100g: 55, proteins: 3.0, fats: 2.5, carbs: 5.5),
    DrinksItem(name: 'Flat White', icon: '⚪', desc: 'espresso, steamed milk', category: 'COFFEE', kcal100g: 50, proteins: 3.0, fats: 2.0, carbs: 4.5),
    DrinksItem(name: 'Macchiato', icon: '🎯', desc: 'espresso, splash of milk', category: 'COFFEE', kcal100g: 10, proteins: 0.5, fats: 0.3, carbs: 1.0),
    DrinksItem(name: 'Mocha', icon: '🍫', desc: 'espresso, chocolate, milk', category: 'COFFEE', kcal100g: 80, proteins: 3.0, fats: 4.0, carbs: 9.0),
    DrinksItem(name: 'Iced Coffee', icon: '🧊', desc: 'espresso, ice, milk', category: 'COFFEE', kcal100g: 35, proteins: 1.5, fats: 1.0, carbs: 5.0),
    DrinksItem(name: 'Cold Brew', icon: '❄️', desc: 'long cold brew coffee', category: 'COFFEE', kcal100g: 5, proteins: 0.3, fats: 0.1, carbs: 0),
    DrinksItem(name: 'Frappuccino', icon: '🍦', desc: 'coffee, ice, syrup, cream', category: 'COFFEE', kcal100g: 110, proteins: 2.5, fats: 4.5, carbs: 16),
    DrinksItem(name: 'Ristretto', icon: '🤏', desc: 'coffee, short pull', category: 'COFFEE', kcal100g: 2, proteins: 0.2, fats: 0.1, carbs: 0),
    DrinksItem(name: 'Lungo', icon: '📏', desc: 'espresso, extra water', category: 'COFFEE', kcal100g: 2, proteins: 0.2, fats: 0.1, carbs: 0),
    DrinksItem(name: 'Dalgona Coffee', icon: '🌪️', desc: 'whipped coffee, sugar, milk', category: 'COFFEE', kcal100g: 65, proteins: 2.5, fats: 2.0, carbs: 9.0),
    DrinksItem(name: 'Turkish Coffee', icon: '☕', desc: 'finely ground, water, sugar', category: 'COFFEE', kcal100g: 5, proteins: 0.3, fats: 0.2, carbs: 0.7),    
    // JUICE
    DrinksItem(name: 'Orange Juice', icon: '🍊', desc: 'orange, pulp, vitamins', category: 'JUICE', kcal100g: 45, proteins: 0.7, fats: 0.2, carbs: 10),
    DrinksItem(name: 'Apple Juice', icon: '🍎', desc: 'apple, natural sugar', category: 'JUICE', kcal100g: 42, proteins: 0.3, fats: 0.1, carbs: 11),
    DrinksItem(name: 'Carrot Juice', icon: '🥕', desc: 'carrot, vitamins', category: 'JUICE', kcal100g: 40, proteins: 1.0, fats: 0.2, carbs: 9),
    DrinksItem(name: 'Tomato Juice', icon: '🍅', desc: 'tomato, salt, spices', category: 'JUICE', kcal100g: 20, proteins: 1.0, fats: 0.2, carbs: 4),
    DrinksItem(name: 'Grape Juice', icon: '🍇', desc: 'grapes, natural sugar', category: 'JUICE', kcal100g: 60, proteins: 0.3, fats: 0.1, carbs: 15),
    DrinksItem(name: 'Pineapple Juice', icon: '🍍', desc: 'pineapple, natural sugar', category: 'JUICE', kcal100g: 50, proteins: 0.3, fats: 0.1, carbs: 12),
    DrinksItem(name: 'Peach Juice', icon: '🍑', desc: 'peach, water, sugar', category: 'JUICE', kcal100g: 48, proteins: 0.4, fats: 0.1, carbs: 11),
    DrinksItem(name: 'Mango Juice', icon: '🥭', desc: 'mango, water, sugar', category: 'JUICE', kcal100g: 55, proteins: 0.4, fats: 0.1, carbs: 13),
    DrinksItem(name: 'Pomegranate Juice', icon: '🍷', desc: 'pomegranate, water', category: 'JUICE', kcal100g: 54, proteins: 0.2, fats: 0.3, carbs: 13),
    DrinksItem(name: 'Multivitamin Juice', icon: '🌈', desc: 'mixed fruits, vitamins', category: 'JUICE', kcal100g: 47, proteins: 0.5, fats: 0.1, carbs: 11),
    DrinksItem(name: 'Cherry Juice', icon: '🍒', desc: 'cherry, water, sugar', category: 'JUICE', kcal100g: 47, proteins: 0.8, fats: 0.1, carbs: 11),
    DrinksItem(name: 'Cranberry Juice', icon: '🔴', desc: 'cranberry, water, sugar', category: 'JUICE', kcal100g: 46, proteins: 0.1, fats: 0.1, carbs: 12),
    // FRESH
    DrinksItem(name: 'Fresh Orange Juice', icon: '🍊', desc: 'orange, freshly squeezed', category: 'FRESH', kcal100g: 45, proteins: 0.7, fats: 0.2, carbs: 10),
    DrinksItem(name: 'Fresh Apple Juice', icon: '🍏', desc: 'apple, freshly squeezed', category: 'FRESH', kcal100g: 46, proteins: 0.3, fats: 0.1, carbs: 11),
    DrinksItem(name: 'Fresh Carrot Juice', icon: '🥕', desc: 'carrot, freshly squeezed', category: 'FRESH', kcal100g: 40, proteins: 1.0, fats: 0.2, carbs: 9),
    DrinksItem(name: 'Fresh Beet Juice', icon: '🍠', desc: 'beetroot, freshly squeezed', category: 'FRESH', kcal100g: 43, proteins: 1.6, fats: 0.2, carbs: 10),
    DrinksItem(name: 'Fresh Celery Juice', icon: '🥬', desc: 'celery, freshly squeezed', category: 'FRESH', kcal100g: 16, proteins: 0.7, fats: 0.2, carbs: 3),
    DrinksItem(name: 'Fresh Mix Juice', icon: '🍹', desc: 'apple, carrot, orange, fresh', category: 'FRESH', kcal100g: 42, proteins: 0.8, fats: 0.2, carbs: 9),
    DrinksItem(name: 'Fresh Grapefruit Juice', icon: '🍈', desc: 'grapefruit, freshly squeezed', category: 'FRESH', kcal100g: 38, proteins: 0.5, fats: 0.1, carbs: 9),
    DrinksItem(name: 'Fresh Watermelon Juice', icon: '🍉', desc: 'watermelon, freshly squeezed', category: 'FRESH', kcal100g: 30, proteins: 0.6, fats: 0.2, carbs: 7),
    DrinksItem(name: 'Fresh Pomegranate Juice', icon: '🍷', desc: 'pomegranate, freshly squeezed', category: 'FRESH', kcal100g: 54, proteins: 0.2, fats: 0.3, carbs: 13),
    DrinksItem(name: 'Fresh Pineapple Juice', icon: '🍍', desc: 'pineapple, freshly squeezed', category: 'FRESH', kcal100g: 50, proteins: 0.3, fats: 0.1, carbs: 12),
    DrinksItem(name: 'Fresh Cucumber Juice', icon: '🥒', desc: 'cucumber, freshly squeezed', category: 'FRESH', kcal100g: 14, proteins: 0.6, fats: 0.1, carbs: 2.5),
    DrinksItem(name: 'Fresh Green Detox', icon: '🥦', desc: 'spinach, cucumber, apple, ginger', category: 'FRESH', kcal100g: 28, proteins: 1.0, fats: 0.2, carbs: 5),
    DrinksItem(name: 'Fresh Mango Juice', icon: '🥭', desc: 'mango, freshly squeezed', category: 'FRESH', kcal100g: 60, proteins: 0.4, fats: 0.1, carbs: 15),    
    // SOFT
    DrinksItem(name: 'Cola', icon: '🥤', desc: 'carbonated water, sugar, caffeine', category: 'SOFT', kcal100g: 42, proteins: 0, fats: 0, carbs: 10.6),
    DrinksItem(name: 'Cola Zero', icon: '⬛', desc: 'carbonated, sweeteners, no sugar', category: 'SOFT', kcal100g: 1, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Cola Light', icon: '⬜', desc: 'carbonated, sweeteners, no sugar', category: 'SOFT', kcal100g: 1, proteins: 0, fats: 0, carbs: 0.1),
    DrinksItem(name: 'Cherry Cola', icon: '🍒', desc: 'carbonated, sugar, cherry flavour', category: 'SOFT', kcal100g: 42, proteins: 0, fats: 0, carbs: 10.5),
    DrinksItem(name: 'Tonic Water', icon: '🧪', desc: 'carbonated, quinine, sugar', category: 'SOFT', kcal100g: 34, proteins: 0, fats: 0, carbs: 8.5),
    DrinksItem(name: 'Bitter Lemon Soda', icon: '🍋', desc: 'carbonated, lemon, quinine', category: 'SOFT', kcal100g: 38, proteins: 0, fats: 0, carbs: 9.5),
    DrinksItem(name: 'Ginger Ale', icon: '🫚', desc: 'carbonated, ginger extract, sugar', category: 'SOFT', kcal100g: 36, proteins: 0, fats: 0, carbs: 9.0),
    DrinksItem(name: 'Orange Soda', icon: '🟠', desc: 'carbonated, sugar, orange', category: 'SOFT', kcal100g: 44, proteins: 0, fats: 0, carbs: 11),
    DrinksItem(name: 'Lemon Soda', icon: '🟡', desc: 'carbonated, sugar, lemon', category: 'SOFT', kcal100g: 42, proteins: 0, fats: 0, carbs: 10.5),
    DrinksItem(name: 'Lemon-Lime Soda', icon: '🟢', desc: 'carbonated, sugar, lemon-lime', category: 'SOFT', kcal100g: 39, proteins: 0, fats: 0, carbs: 9.7),
    DrinksItem(name: 'Citrus Soda', icon: '☀️', desc: 'carbonated, sugar, citrus, caffeine', category: 'SOFT', kcal100g: 46, proteins: 0, fats: 0, carbs: 12),
    DrinksItem(name: 'Spiced Cola', icon: '🌶️', desc: 'carbonated, 23 flavours blend', category: 'SOFT', kcal100g: 40, proteins: 0, fats: 0, carbs: 10),
    DrinksItem(name: 'Iced Tea Lemon', icon: '🧊', desc: 'tea, lemon, sugar, water', category: 'SOFT', kcal100g: 30, proteins: 0, fats: 0, carbs: 7),
    DrinksItem(name: 'Iced Tea Peach', icon: '🍑', desc: 'tea, peach, sugar, water', category: 'SOFT', kcal100g: 32, proteins: 0, fats: 0, carbs: 8),
    DrinksItem(name: 'Ginger Beer', icon: '🫚', desc: 'carbonated, ginger, sugar', category: 'SOFT', kcal100g: 37, proteins: 0, fats: 0, carbs: 9),
    DrinksItem(name: 'Root Beer', icon: '🍺', desc: 'carbonated, sassafras, vanilla', category: 'SOFT', kcal100g: 41, proteins: 0, fats: 0, carbs: 10.7),
    // ENERGY  
    DrinksItem(name: 'Energy Drink Classic', icon: '⚡', desc: 'caffeine, taurine, B-vitamins', category: 'ENERGY', kcal100g: 45, proteins: 0, fats: 0, carbs: 11),
    DrinksItem(name: 'Energy Drink Sugar Free', icon: '🟦', desc: 'caffeine, B-vitamins, no sugar', category: 'ENERGY', kcal100g: 3, proteins: 0, fats: 0, carbs: 0.3),
    DrinksItem(name: 'Energy Drink Green Tea', icon: '🍃', desc: 'caffeine, green tea, ginger', category: 'ENERGY', kcal100g: 4, proteins: 0, fats: 0, carbs: 0.5),
    DrinksItem(name: 'Energy Drink Guarana', icon: '🍒', desc: 'caffeine, guarana, ginseng', category: 'ENERGY', kcal100g: 47, proteins: 0, fats: 0, carbs: 12),
    DrinksItem(name: 'Energy Drink Berry', icon: '🍓', desc: 'caffeine, taurine, berry flavour', category: 'ENERGY', kcal100g: 46, proteins: 0, fats: 0, carbs: 11.5),
    DrinksItem(name: 'Energy Drink Citrus', icon: '🍋', desc: 'caffeine, taurine, citrus flavour', category: 'ENERGY', kcal100g: 44, proteins: 0, fats: 0, carbs: 11),   
    // SMOOTHIE
    DrinksItem(name: 'Banana Smoothie', icon: '🍌', desc: 'banana, milk, yogurt, honey', category: 'SMOOTHIE', kcal100g: 95, proteins: 3.0, fats: 2.5, carbs: 15),
    DrinksItem(name: 'Berry Smoothie', icon: '🍓', desc: 'berries, yogurt, honey, milk', category: 'SMOOTHIE', kcal100g: 85, proteins: 2.5, fats: 2.0, carbs: 14),
    DrinksItem(name: 'Green Smoothie', icon: '🥬', desc: 'spinach, apple, banana, water', category: 'SMOOTHIE', kcal100g: 60, proteins: 2.0, fats: 0.5, carbs: 12),
    DrinksItem(name: 'Protein Shake', icon: '💪', desc: 'protein powder, milk, banana', category: 'SMOOTHIE', kcal100g: 120, proteins: 10.0, fats: 3.0, carbs: 10),
    DrinksItem(name: 'Mango Smoothie', icon: '🥭', desc: 'mango, yogurt, orange juice', category: 'SMOOTHIE', kcal100g: 90, proteins: 2.0, fats: 1.5, carbs: 18),
    DrinksItem(name: 'Avocado Smoothie', icon: '🥑', desc: 'avocado, banana, milk, honey', category: 'SMOOTHIE', kcal100g: 120, proteins: 2.5, fats: 7.0, carbs: 12),
    DrinksItem(name: 'Strawberry Smoothie', icon: '🥤', desc: 'strawberry, milk, yogurt', category: 'SMOOTHIE', kcal100g: 75, proteins: 2.5, fats: 1.5, carbs: 13),
    DrinksItem(name: 'Peanut Butter Smoothie', icon: '🥜', desc: 'peanut butter, banana, milk', category: 'SMOOTHIE', kcal100g: 140, proteins: 5.0, fats: 7.0, carbs: 15),
    DrinksItem(name: 'Acai Bowl Smoothie', icon: '🫐', desc: 'acai, banana, almond milk', category: 'SMOOTHIE', kcal100g: 90, proteins: 2.0, fats: 3.0, carbs: 14),
    DrinksItem(name: 'Detox Smoothie', icon: '🥒', desc: 'cucumber, lemon, ginger', category: 'SMOOTHIE', kcal100g: 25, proteins: 1.0, fats: 0.3, carbs: 4),
    DrinksItem(name: 'Coconut Smoothie', icon: '🥥', desc: 'coconut milk, pineapple, mango', category: 'SMOOTHIE', kcal100g: 100, proteins: 1.0, fats: 5.0, carbs: 14),
    DrinksItem(name: 'Oat Smoothie', icon: '🌾', desc: 'oats, banana, milk, cinnamon', category: 'SMOOTHIE', kcal100g: 110, proteins: 4.0, fats: 2.5, carbs: 19),
    // ALCOHOL
    DrinksItem(name: 'Lager Beer', icon: '🍺', desc: 'malt, hops, water, light', category: 'ALCOHOL', kcal100g: 43, proteins: 0.5, fats: 0, carbs: 3.5),
    DrinksItem(name: 'Dark Beer', icon: '🍺', desc: 'dark malt, hops, yeast', category: 'ALCOHOL', kcal100g: 55, proteins: 0.7, fats: 0, carbs: 4.5),
    DrinksItem(name: 'Wheat Beer', icon: '🍺', desc: 'wheat malt, hops, water', category: 'ALCOHOL', kcal100g: 48, proteins: 0.6, fats: 0, carbs: 4.0),
    DrinksItem(name: 'IPA Beer', icon: '🍺', desc: 'malt, hops, yeast, bitter', category: 'ALCOHOL', kcal100g: 55, proteins: 0.6, fats: 0, carbs: 4.5),
    DrinksItem(name: 'Non-Alcoholic Beer', icon: '🚫', desc: 'malt, hops, <0.5% alcohol', category: 'ALCOHOL', kcal100g: 22, proteins: 0.4, fats: 0, carbs: 4.0),
    DrinksItem(name: 'Guinness Stout', icon: '🍺', desc: 'roasted barley, malt, yeast', category: 'ALCOHOL', kcal100g: 37, proteins: 0.4, fats: 0, carbs: 3.5),
    DrinksItem(name: 'Heineken', icon: '🍺', desc: 'barley malt, hops, water', category: 'ALCOHOL', kcal100g: 42, proteins: 0.3, fats: 0, carbs: 3.2),
    DrinksItem(name: 'Corona', icon: '🍺', desc: 'barley malt, hops, corn', category: 'ALCOHOL', kcal100g: 40, proteins: 0.3, fats: 0, carbs: 3.6),
    DrinksItem(name: 'Red Wine', icon: '🍷', desc: 'grapes, alcohol, tannins', category: 'ALCOHOL', kcal100g: 85, proteins: 0.1, fats: 0, carbs: 2.5),
    DrinksItem(name: 'White Wine', icon: '🥂', desc: 'grapes, alcohol', category: 'ALCOHOL', kcal100g: 80, proteins: 0.1, fats: 0, carbs: 2.0),
    DrinksItem(name: 'Rosé Wine', icon: '🍷', desc: 'grapes, alcohol, rosé', category: 'ALCOHOL', kcal100g: 82, proteins: 0.1, fats: 0, carbs: 2.5),
    DrinksItem(name: 'Prosecco', icon: '🍾', desc: 'sparkling wine, grapes, Italy', category: 'ALCOHOL', kcal100g: 75, proteins: 0.1, fats: 0, carbs: 1.5),
    DrinksItem(name: 'Champagne', icon: '🍾', desc: 'sparkling wine, France', category: 'ALCOHOL', kcal100g: 76, proteins: 0.3, fats: 0, carbs: 1.4),
    DrinksItem(name: 'Sangria', icon: '🍷', desc: 'wine, orange, brandy, fruit', category: 'ALCOHOL', kcal100g: 90, proteins: 0.1, fats: 0, carbs: 8.0),
    DrinksItem(name: 'Mulled Wine', icon: '🍷', desc: 'red wine, spices, orange', category: 'ALCOHOL', kcal100g: 95, proteins: 0.1, fats: 0, carbs: 9.0),
    DrinksItem(name: 'Vodka', icon: '🍸', desc: 'ethanol, water', category: 'ALCOHOL', kcal100g: 230, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Whiskey', icon: '🥃', desc: 'grain, alcohol, water', category: 'ALCOHOL', kcal100g: 250, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Rum', icon: '🥃', desc: 'sugarcane, alcohol, water', category: 'ALCOHOL', kcal100g: 231, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Gin', icon: '🍸', desc: 'grain, juniper, botanicals', category: 'ALCOHOL', kcal100g: 263, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Tequila', icon: '🥃', desc: 'agave, alcohol, water', category: 'ALCOHOL', kcal100g: 231, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Brandy', icon: '🥃', desc: 'grapes, alcohol, aged', category: 'ALCOHOL', kcal100g: 237, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Cognac', icon: '🥃', desc: 'grapes, alcohol, France', category: 'ALCOHOL', kcal100g: 240, proteins: 0, fats: 0, carbs: 0),
    DrinksItem(name: 'Baileys', icon: '🧉', desc: 'whiskey, cream, chocolate', category: 'ALCOHOL', kcal100g: 327, proteins: 3.0, fats: 14.0, carbs: 25.0),
    DrinksItem(name: 'Aperol', icon: '🍊', desc: 'bitter orange, alcohol', category: 'ALCOHOL', kcal100g: 155, proteins: 0, fats: 0, carbs: 18.0),
    DrinksItem(name: 'Campari', icon: '🟥', desc: 'bitter herbs, alcohol', category: 'ALCOHOL', kcal100g: 245, proteins: 0, fats: 0, carbs: 22.0),
    DrinksItem(name: 'Mojito', icon: '🍹', desc: 'rum, lime, mint, sugar, soda', category: 'ALCOHOL', kcal100g: 70, proteins: 0, fats: 0, carbs: 9.0),
    DrinksItem(name: 'Margarita', icon: '🍸', desc: 'tequila, lime, triple sec', category: 'ALCOHOL', kcal100g: 110, proteins: 0, fats: 0, carbs: 8.0),
    DrinksItem(name: 'Aperol Spritz', icon: '🍹', desc: 'aperol, prosecco, soda', category: 'ALCOHOL', kcal100g: 60, proteins: 0, fats: 0, carbs: 7.0),
    DrinksItem(name: 'Gin Tonic', icon: '🍸', desc: 'gin, tonic water, lime', category: 'ALCOHOL', kcal100g: 80, proteins: 0, fats: 0, carbs: 5.0),
    DrinksItem(name: 'Piña Colada', icon: '🥥', desc: 'rum, coconut, pineapple', category: 'ALCOHOL', kcal100g: 125, proteins: 0.5, fats: 3.5, carbs: 15.0),
    DrinksItem(name: 'Cosmopolitan', icon: '🍸', desc: 'vodka, cranberry, lime', category: 'ALCOHOL', kcal100g: 95, proteins: 0, fats: 0, carbs: 8.0),
    DrinksItem(name: 'Bloody Mary', icon: '🍅', desc: 'vodka, tomato juice, spices', category: 'ALCOHOL', kcal100g: 55, proteins: 0.5, fats: 0, carbs: 4.5),
    DrinksItem(name: 'Negroni', icon: '🥃', desc: 'gin, campari, vermouth', category: 'ALCOHOL', kcal100g: 170, proteins: 0, fats: 0, carbs: 10.0),
    DrinksItem(name: 'Old Fashioned', icon: '🥃', desc: 'whiskey, bitters, sugar', category: 'ALCOHOL', kcal100g: 155, proteins: 0, fats: 0, carbs: 5.0),  
  ];

@override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    final List<DrinksItem> filteredDrinks = selectedCat == 'ALL' 
        ? drinksDatabase : drinksDatabase.where((d) => d.category == selectedCat).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: sapphire, size: 20), 
          onPressed: () => Navigator.pop(context)
        ),
        title: const Text('DRINKS', 
          style: TextStyle(color: sapphire, fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterPanel(screenWidth),
          Expanded(
            child: filteredDrinks.isEmpty 
              ? const Center(child: Text('No items found', style: TextStyle(color: Colors.white54)))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: filteredDrinks.length,
                  itemBuilder: (context, index) => _buildJewelTile(filteredDrinks[index], screenWidth),
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
                color: isActive ? sapphire : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: sapphire.withOpacity(0.5), width: 0.8),
              ),
              alignment: Alignment.center,
              child: Text(categories[index],
                style: TextStyle(
                  color: isActive ? Colors.black : sapphire, 
                  fontWeight: FontWeight.bold, 
                  fontSize: screenWidth * 0.03
                )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJewelTile(DrinksItem item, double screenWidth) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [sapphire.withOpacity(0.6), deepBlue], 
          begin: Alignment.topLeft, end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: sapphire.withOpacity(0.2), width: 0.5),
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
              // 1. ИКОНКА (Твои красивые бутылочки)
              Container(
                width: screenWidth * 0.12,
                alignment: Alignment.centerLeft,
                child: Text(item.icon, style: TextStyle(fontSize: screenWidth * 0.08)),
              ),
              const SizedBox(width: 8),

              // 2. ИНФО (Название и БЖУ)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.name.toUpperCase(), 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: contentColor, fontWeight: FontWeight.w900, fontSize: screenWidth * 0.032, letterSpacing: 1.1)),
                    const SizedBox(height: 2),
                    Text(item.desc, 
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: contentColor.withOpacity(0.5), fontSize: screenWidth * 0.026)),
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

              // 3. ПРАВАЯ ЧАСТЬ (Ккал + Умная кнопка)
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
                          style: TextStyle(color: contentColor, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.035)),
                        Text('per 100ml', 
                          style: TextStyle(color: contentColor.withOpacity(0.6), fontSize: screenWidth * 0.022)),
                      ],
                    ),
                    const SizedBox(width: 8),
                    
                    // УМНАЯ КНОПКА
                    widget.imageFile == null 
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(Icons.add_circle_outline, color: sapphire, size: screenWidth * 0.075),
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
                            border: Border.all(color: sapphire, width: 1.5),
                          ),
                          child: Icon(Icons.biotech, color: sapphire, size: screenWidth * 0.055),
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
  }

  Widget _buildMacro(String label, double val, double screenWidth) {
    return Padding(
      padding: EdgeInsets.only(right: screenWidth * 0.025),
      child: Text('$label: ${val.toStringAsFixed(0)}', 
        style: TextStyle(color: sapphire.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: screenWidth * 0.026)),
    );
  }

  void _showArchiveInfo(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("To add to Diary, please start from Breakfast/Lunch"),
        backgroundColor: Color(0xFF020326),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showPortionDialog(DrinksItem item, double screenWidth) {
    final TextEditingController controller = TextEditingController(text: '250');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: sapphire), borderRadius: BorderRadius.circular(15)),
        title: Text(item.name.toUpperCase(), style: const TextStyle(color: sapphire, fontSize: 14)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Volume in ml:', style: TextStyle(color: contentColor, fontSize: 12)),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: sapphire, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: sapphire)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: sapphire)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: sapphire),
            onPressed: () {
              double volumeMl = double.tryParse(controller.text) ?? 250;
              double factor = volumeMl / 100;
              final metrics = Provider.of<MetricsProvider>(context, listen: false);
              
              if (item.category == 'WATER') {
                metrics.addWater(volumeMl / 1000); 
              }

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
                  SnackBar(content: Text('Added to ${widget.mealName}!'), backgroundColor: sapphire)
                );
              }
            },
            child: const Text('ADD', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showLibrarySaveDialog(DrinksItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF05100A),
        shape: RoundedRectangleBorder(side: const BorderSide(color: sapphire), borderRadius: BorderRadius.circular(15)),
        title: const Text("SAVE TO LIBRARY?", style: TextStyle(color: sapphire, fontSize: 14)),
        content: Text("Do you want to save ${item.name} with your photo?", 
          style: const TextStyle(color: contentColor, fontSize: 12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: sapphire),
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
            child: const Text('SAVE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}