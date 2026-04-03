// lib/global_data.dart
import 'package:flutter/material.dart';

// ТЕПЕРЬ МОДЕЛЬ ХРАНИТ ВСЕ 14 ПОКАЗАТЕЛЕЙ ИЗ АНКЕТЫ
class LibraryProduct {
  final String name;
  final String calories;
  final String desc;
  final String? imagePath; // <--- ВОТ ОНО! Наше секретное хранилище для фото 📸
  
  // Macros (BJU + Sugar)
  final String proteins;
  final String fats;
  final String carbs;
  final String sugar;

  // Minerals
  final String potassium;
  final String magnesium;
  final String calcium;
  final String zinc;

  // Vitamins
  final String vitC;
  final String vitD;
  final String vitB12;

  LibraryProduct({
    required this.name,
    required this.calories,
    required this.desc,
    this.proteins = "0", // Заглушки, чтобы не было ошибок типа
    this.fats = "0",
    this.carbs = "0",
    this.sugar = "0",
    this.potassium = "0",
    this.magnesium = "0",
    this.calcium = "0",
    this.zinc = "0",
    this.vitC = "0",
    this.vitD = "0",
    this.vitB12 = "0",
    this.imagePath,
  });
}

// ЭТОТ СПИСОК ПУСТОЙ
List<LibraryProduct> globalLibrary = [];