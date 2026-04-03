import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/main.dart';
class Artifact {
  final String id;
  final String nameMale;   
  final String nameFemale; 
  final String displayName; 
  final String description;
  final IconData icon;
  bool isLocked;
  bool isEquipped;
  final double x; 
  final double y; 

  Artifact({
    required this.id,
    required this.nameMale,
    required this.nameFemale,
    required this.displayName,
    required this.description,
    required this.icon,
    this.isLocked = true,
    this.isEquipped = false,
    this.x = 0.5,
    this.y = 0.5,
  });
}

class EvolutionProvider with ChangeNotifier {
  // --- КОПИЛКИ КРИСТАЛЛОВ (Для накопления и шторок) ---
  int _totalGreen = 0;
  int _totalBlue = 0;
  int _totalGold = 0;

  int get greenCrystals => _totalGreen;
  int get blueCrystals => _totalBlue;
  int get goldCrystals => _totalGold;

  // ДОБАВЬ ЭТИ ДВЕ СТРОЧКИ ЗДЕСЬ:
  double _currentVaultProgress = 0.0; 
  double get currentVaultProgress => _currentVaultProgress;

  List<Artifact> artifacts = [
    // === VAULT 1: EVOLUTION BASE (L) ===
    Artifact(id: 'L1', nameMale: 'L1', nameFemale: 'L1', displayName: 'Vital Thread', icon: Icons.waves, description: 'Fiber-optic headband synchronizing your rhythm.', x: 0.5, y: 0.12),
    Artifact(id: 'L2', nameMale: 'L2', nameFemale: 'L2', displayName: 'Glow Bracelet', icon: Icons.blur_on, description: 'Cybernetic wrist bands with golden energy lines.', x: 0.5, y: 0.45),
    Artifact(id: 'L3', nameMale: 'L3', nameFemale: 'L3', displayName: 'Silk Bindings', icon: Icons.gesture, description: 'Futuristic leg wraps made of smart-fabric.', x: 0.5, y: 0.70),
    Artifact(id: 'L4', nameMale: 'L4', nameFemale: 'L4', displayName: 'Core Vest', icon: Icons.shield, description: 'Lightweight chest piece with a glowing node.', x: 0.5, y: 0.35),
    Artifact(id: 'L5', nameMale: 'L5', nameFemale: 'L5', displayName: 'Flow Boots', icon: Icons.directions_run, description: 'High-tech boots with stabilizer heel wings.', x: 0.5, y: 0.90),
    Artifact(id: 'L6', nameMale: 'L6', nameFemale: 'L6', displayName: 'Pulse Gauntlets', icon: Icons.bolt, description: 'Sleek gauntlets with golden energy conduits.', x: 0.5, y: 0.45),
    Artifact(id: 'L7', nameMale: 'L7', nameFemale: 'L7', displayName: 'Aura Mantle', icon: Icons.auto_awesome, description: 'Shoulder armor with pulsating light patterns.', x: 0.5, y: 0.25),
    Artifact(id: 'L8', nameMale: 'L8', nameFemale: 'L8', displayName: 'Origin Crown', icon: Icons.workspace_premium, description: 'The ultimate geometric light structure crown.', x: 0.5, y: 0.08),

    // === VAULT 2: NEURO-LINK (R) ===  
    Artifact(id: 'R1', nameMale: 'R1', nameFemale: 'R1', displayName: 'Ether Tiara', icon: Icons.visibility, description: 'Cybernetic monocle with holographic data HUD.', x: 0.5, y: 0.15),
    Artifact(id: 'R2', nameMale: 'R2', nameFemale: 'R2', displayName: 'Chrono-Watch', icon: Icons.timer, description: 'Holographic wrist watch with 3D interface.', x: 0.7, y: 0.45),
    Artifact(id: 'R3', nameMale: 'R3', nameFemale: 'R3', displayName: 'Logic Chip', icon: Icons.memory, description: 'Neural interface chip with golden circuitry.', x: 0.4, y: 0.18),
    Artifact(id: 'R4', nameMale: 'R4', nameFemale: 'R4', displayName: 'Cyber Scarf', icon: Icons.settings_voice, description: 'Metallic neck collar with fiber-optic lines.', x: 0.5, y: 0.28),
    Artifact(id: 'R5', nameMale: 'R5', nameFemale: 'R5', displayName: 'Tech-Pouch', icon: Icons.shopping_bag, description: 'Sleek data pouch with magnetic attachment.', x: 0.5, y: 0.55),
    Artifact(id: 'R6', nameMale: 'R6', nameFemale: 'R6', displayName: 'Scanner Glasses', icon: Icons.remove_red_eye, description: 'Mirrored visor with neon scanner lines.', x: 0.5, y: 0.15),
    Artifact(id: 'R7', nameMale: 'R7', nameFemale: 'R7', displayName: 'Neo-Cloak', icon: Icons.layers, description: 'High-tech hooded cloak with circuit patterns.', x: 0.5, y: 0.40),
    Artifact(id: 'R8', nameMale: 'R8', nameFemale: 'R8', displayName: 'Genius Helm', icon: Icons.psychology, description: 'Full neural-link crown with integrated sensors.', x: 0.5, y: 0.10),

    // === VAULT 3: VITAL-FLOW (V) ===
    Artifact(id: 'V1', nameMale: 'V1', nameFemale: 'V1', displayName: 'Flux Core', icon: Icons.opacity, description: 'Glowing core pendant with floating liquid energy.', x: 0.5, y: 0.35),
    Artifact(id: 'V2', nameMale: 'V2', nameFemale: 'V2', displayName: 'Oxygen Mask', icon: Icons.air, description: 'Cyber-respirator with luminous air filters.', x: 0.5, y: 0.20),
    Artifact(id: 'V3', nameMale: 'V3', nameFemale: 'V3', displayName: 'Plasma Ring', icon: Icons.adjust, description: 'Floating plasma rings with electric sparks.', x: 0.3, y: 0.45),
    Artifact(id: 'V4', nameMale: 'V4', nameFemale: 'V4', displayName: 'Heart Reactor', icon: Icons.favorite, description: 'Mechanical chest reactor with moving gears.', x: 0.5, y: 0.38),
    Artifact(id: 'V5', nameMale: 'V5', nameFemale: 'V5', displayName: 'Jet Pack Wings', icon: Icons.airplanemode_active, description: 'Mechanical wings with blue thrusters.', x: 0.5, y: 0.30),
    Artifact(id: 'V6', nameMale: 'V6', nameFemale: 'V6', displayName: 'Storm Bringer', icon: Icons.flash_on, description: 'Lightning rod accessory with energy sparks.', x: 0.6, y: 0.18),
    Artifact(id: 'V7', nameMale: 'V7', nameFemale: 'V7', displayName: 'Solar Halo', icon: Icons.wb_sunny, description: 'Holographic halo with glowing solar flares.', x: 0.5, y: 0.05),
    Artifact(id: 'V8', nameMale: 'V8', nameFemale: 'V8', displayName: 'God Armor', icon: Icons.stars, description: 'Divine cyber-armor with flowing energy lines.', x: 0.5, y: 0.50),
  ];

// --- ЦЕНТРАЛЬНЫЕ ФОРМУЛЫ "СКВОЗНЯК" (ВСТАВЛЯЙ ОТСЮДА) ---

// =========================================================
  // ЦЕНТРАЛЬНЫЕ СКВОЗНЫЕ КАНАЛЫ (ЗЕЛЕНЫЙ, СИНИЙ, ЖЕЛТЫЙ + XP)
  // С ПОДДЕРЖКОЙ НАКОПЛЕНИЯ ДРОБНЫХ ЧИСЕЛ
  // =========================================================

  // 1. ЗЕЛЕНЫЙ КАНАЛ (Питание)
  int calculateNutritionScore(MetricsProvider metrics) {
    double raw = 0.0; // Используем double, чтобы копить дробные (0.25, 0.5...)
    
    if (metrics.targetWater > 0) {
      raw += (metrics.waterToday / metrics.targetWater);
    }
    
    if (metrics.targetProtein > 0 && metrics.proteinToday >= (metrics.targetProtein * 0.8)) raw += 1.0;
    
    if (metrics.eatenToday > 0 && metrics.fatsToday <= metrics.targetFats && metrics.carbsToday <= metrics.targetCarbs) {
      raw += 1.0;
    }

    int finalRaw = raw.floor(); // Берем целую часть для кристаллов

    if (finalRaw <= 10) return finalRaw;
    return 10 + ((finalRaw - 10) ~/ 2);
  }

  // 2. СИНИЙ КАНАЛ (Активность)
  int calculateActivityScore(MetricsProvider metrics) {
    double raw = 0.0;
    
    if (metrics.stepsToday >= 5000) raw += 1.0;
    if (metrics.stepsToday >= 10000) raw += 1.0;
    if (metrics.burnedToday >= 500) raw += 1.0;
    
    if (metrics.stepsToday > 10000) {
      raw += (metrics.stepsToday - 10000) / 10000; // Копим остаток шагов
    }

    int finalRaw = raw.floor();
    return (finalRaw <= 3) ? finalRaw : 3 + ((finalRaw - 3) ~/ 2);
  }

  // 3. ЖЕЛТЫЙ КАНАЛ (Тренировка) - ТВОЙ ТРЕТИЙ КАНАЛ!
  int calculateWorkoutScore(MetricsProvider metrics) {
    // Если тренировка закончена — 3 кристалла, если нет — 0.
    return metrics.isWorkoutFinishedToday ? 3 : 0;
  }

  // 4. РАСЧЕТ ОПЫТА (XP)
  double calculateDailyXP(int nutritionScore, int activityScore, int workoutScore) {
    double dailyXP = 0.0;
    dailyXP += (nutritionScore / 3) * 0.1; 
    dailyXP += (activityScore / 3) * 0.15;
    if (workoutScore >= 3) dailyXP += 0.2;
    return dailyXP;
  }
  // --- КОНЕЦ ВСТАВКИ ---
  // --- МЕТОД ДЛЯ СВЯЗИ СО СКЛАДОМ (Чтобы ошибка исчезла) ---
  int getCrystalsForArt(String artId) {
    if (artId.startsWith('L')) return _totalGreen; 
    if (artId.startsWith('R')) return _totalBlue;
    if (artId.startsWith('V')) return _totalGold;
    return 0;
  }

  // --- СИНХРОНИЗАЦИЯ С ЭКРАНОМ ИГРЫ ---
  void syncDailyCrystals(int dailyGreen, int dailyBlue, int dailyGold) async {
    _totalGreen += dailyGreen; // Теперь они ПРИБАВЛЯЮТСЯ
    _totalBlue += dailyBlue;
    _totalGold += dailyGold;
    // ДОБАВЬ ЭТО: Рассчитываем прогресс для шторки (на базе 20 кристаллов)
    // Мы берем остаток от деления на 20, чтобы шторка сбрасывалась для нового предмета
    _currentVaultProgress = (_totalGreen % 20) / 20.0;

    // Автоматическое открытие по уровню (как было в тесте)
    _checkLocksSimple(); 

    notifyListeners();
    _saveToPrefs();
  }

  void _checkLocksSimple() {
  for (var art in artifacts) {
    int current = getCrystalsForArt(art.id);
    
    // Если накопили 20 или больше и артефакт еще был закрыт
    if (current >= 20 && art.isLocked == true) {
      art.isLocked = false;
      
      // ВЫЗЫВАЕМ НАШЕ КРАСИВОЕ УВЕДОМЛЕНИЕ
      // Передаем название артефакта прямо в текст
      showArtifactNotification(
        "NEW ARTIFACT UNLOCKED! 💎", 
        "The vault has opened: ${art.displayName} is now available for your Avatar."
      );
    }
  }
}

  // Сохранение/Загрузка
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('total_green', _totalGreen);
    await prefs.setInt('total_blue', _totalBlue);
    await prefs.setInt('total_gold', _totalGold);
    for (var art in artifacts) {
      await prefs.setBool('lock_${art.id}', art.isLocked);
      await prefs.setBool('equip_${art.id}', art.isEquipped);
    }
  }

  Future<void> loadArtifacts() async {
    final prefs = await SharedPreferences.getInstance();
    _totalGreen = prefs.getInt('total_green') ?? 0;
    _totalBlue = prefs.getInt('total_blue') ?? 0;
    _totalGold = prefs.getInt('total_gold') ?? 0;
    for (var art in artifacts) {
      art.isLocked = prefs.getBool('lock_${art.id}') ?? true;
      art.isEquipped = prefs.getBool('equip_${art.id}') ?? false;
    }
    notifyListeners();
  }

  // Метод для кнопки ТЕСТ (Молния)
  /*void checkLevelLocks(int level) {
    for (int i = 0; i < artifacts.length; i++) {
      // Открываем артефакты соответствующего уровня
      if (i < level) {
        artifacts[i].isLocked = false;
      }
    }
    notifyListeners();
  }*/

  void toggleEquip(String id) async {
    final index = artifacts.indexWhere((a) => a.id == id);
    if (index != -1 && !artifacts[index].isLocked) {
      artifacts[index].isEquipped = !artifacts[index].isEquipped;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('equip_$id', artifacts[index].isEquipped);
      notifyListeners();
    }
  }

  bool get hasNewArtifactsToEquip => artifacts.any((art) => !art.isLocked && !art.isEquipped);
}