import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../screens/calc_screen.dart'; 

class FoodRecord {
  final String name;
  final double kcal;
  final double p; // Белки
  final double f; // Жиры
  final double c; // Углеводы
  final DateTime time;
final String? imagePath; // <--- 1. ДОБАВЬ ЭТУ СТРОКУ

  FoodRecord({
    required this.name, 
    required this.kcal, 
    required this.p, 
    required this.f, 
    required this.c, 
    required this.time,
    this.imagePath, // <--- 2. И ЭТУ СТРОКУ В СКОБКИ
  });
}

class MetricsProvider with ChangeNotifier {
  String selectedPeriod = 'WEEK';
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  // --- 1. ФАКТИЧЕСКИЕ ДАННЫЕ ЗА ДЕНЬ (Нужны для Food и Workout) ---
  double eatenToday = 0.0;
// --- НОВЫЕ ПОЛКИ ДЛЯ РАЗДЕЛЬНОЙ ЕДЫ (Вставляем сюда) ---
  double breakfastKcal = 0.0, breakfastP = 0.0, breakfastF = 0.0, breakfastC = 0.0;
  double snack1Kcal = 0.0, snack1P = 0.0, snack1F = 0.0, snack1C = 0.0;
  double lunchKcal = 0.0, lunchP = 0.0, lunchF = 0.0, lunchC = 0.0;
  double snack2Kcal = 0.0, snack2P = 0.0, snack2F = 0.0, snack2C = 0.0;
  double dinnerKcal = 0.0, dinnerP = 0.0, dinnerF = 0.0, dinnerC = 0.0;



// --- СПИСКИ ДЛЯ ИСТОРИИ БЛЮД ---
  final List<FoodRecord> _breakfastList = [];
  final List<FoodRecord> _snack1List = [];
  final List<FoodRecord> _lunchList = [];
  final List<FoodRecord> _snack2List = [];
  final List<FoodRecord> _dinnerList = [];

  // Геттеры для доступа к спискам из экранов
  List<FoodRecord> get breakfastList => _breakfastList;
  List<FoodRecord> get snack1List => _snack1List;
  List<FoodRecord> get lunchList => _lunchList;
  List<FoodRecord> get snack2List => _snack2List;
  List<FoodRecord> get dinnerList => _dinnerList;

  double burnedToday = 0.0;
  double waterToday = 0.0;
  double proteinToday = 0.0;
  double carbsToday = 0.0;
  double fatsToday = 0.0;
  int stepsToday = 0; // ДОБАВЬ ВОТ ЭТУ СТРОЧКУ
  int activeMinutesToday = 0; // Активные минуты для голубых кристаллов
  bool isWorkoutFinishedToday = false; // Была ли тренировка сегодня?
  int totalXP = 0; // Весь накопленный опыт за всё время
  int todayXP = 0; // Опыт, полученный сегодня
  int userLevel = 1; // Уровень атлета

  // --- 2. ЦЕЛЕВЫЕ ПОКАЗАТЕЛИ ---
  int dailyCaloriesLimit = 0;
  double targetWater = 0.0;
  double targetProtein = 0.0;
  double targetCarbs = 0.0;
  double targetFats = 0.0;
  double currentWeight = 0.0; 
  double targetWeight = 0.0;

  // --- 3. ДАННЫЕ ПРОФИЛЯ И TANITA (Новое) ---
  String userName = "_";
  int userAge = 0;
  double userHeight = 0.0;
  double startWeight = 0.0;
// --- НОВАЯ ВСТАВКА (ПОЛ АВАТАРА) ---
  bool? _isMale; // Теперь может быть null (пусто)
  bool? get isMale => _isMale;

  // Правильный блок для аватарки:
  String _userAvatar = ''; 
  String get userAvatar => _userAvatar;    

  double bmi = 0.0;
  double tanitaFat = 0.0;
  double tanitaMuscle = 0.0;
  double tanitaWater = 0.0;
  double tanitaBoneMass = 0.0;
  int tanitaVisceral = 0;
  double tanitaProtein = 0.0;
  int tanitaMetabolicAge = 0;

  // Замеры (Сантиметры)
  double chest = 0.0;
  double waist = 0.0;
  double hips = 0.0;
  double neck = 0.0;    // Добавлено
  double biceps = 0.0;  // Добавлено
  double forearm = 0.0; // Добавлено
  double thigh = 0.0;   // Добавлено
  double calf = 0.0;

  Map<String, Map<String, double>> weeklyHistory = {};

  MetricsProvider() { _init(); }

  //Future<void> _init() async {
   // await loadDataForDate(_selectedDate);
  //}
  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Проверяем дату последнего входа
    String lastVisit = prefs.getString('last_visit_date') ?? "";
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    
    // 2. Если дата изменилась (наступило утро)
    if (lastVisit != today) {
      // Обновляем дату в памяти, чтобы завтра сработало снова
      await prefs.setString('last_visit_date', today);
      
      // ВАЖНО: Мы НЕ обнуляем переменные вручную. 
      // Когда чуть ниже вызовется loadDataForDate(_selectedDate), 
      // программа посмотрит в память по ключу "СЕГОДНЯ" (например, 2026-03-20),
      // не найдет там вчерашних калорий и сама поставит 0.0.
    }

    // 3. Загружаем данные (теперь уже чистые, если день новый)
    await loadDataForDate(_selectedDate);
  }
// Метод специально для прибавления калорий (из йоги или тренировок)
// Метод для ПРИБАВЛЕНИЯ калорий (подходит для соревнований и нескольких тренировок)
Future<void> addBurnedCalories(double kcal) async {
  final prefs = await SharedPreferences.getInstance();
  
  // 1. ПРОВЕРКА ДАТЫ: Всегда работаем с текущей датой (сегодня)
  String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
  
  // Если мы переключили календарь на "вчера", но тренируемся "сегодня", 
  // калории должны упасть в сегодняшний день.
  
  // 2. СУММИРУЕМ
// ... (начало метода оставляем как есть)
  burnedToday += kcal; 
  
  // ДОБАВИМ ЛОГИКУ: Каждые 5 сожженных калорий дарят нам 1 минуту активности
  activeMinutesToday += (kcal / 5).toInt();
  
  // СОХРАНЯЕМ И ТО, И ДРУГОЕ
  await prefs.setDouble('${todayKey}_burned', burnedToday);
  await prefs.setInt('${todayKey}_active_mins', activeMinutesToday); // СОХРАНЯЕМ МИНУТЫ
  
  await loadWeeklyHistory(); 
  notifyListeners();
}
  String get _dateKey => DateFormat('yyyy-MM-dd').format(_selectedDate);

  void setDate(DateTime date) {
    _selectedDate = date;
    loadDataForDate(date);
  }

  // --- ЗАГРУЗКА ВСЕХ ДАННЫХ ---
  Future<void> loadDataForDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    String key = DateFormat('yyyy-MM-dd').format(date);

// --- ДОБАВЬ ЭТОТ БЛОК (ЖЕСТКОЕ ОБНУЛЕНИЕ ПЕРЕД ЗАГРУЗКОЙ) ---
    // Это очистит "вчерашние" 7.5 литров из памяти самого телефона (RAM)
    waterToday = 0.0;
    stepsToday = 0;
    burnedToday = 0.0;
    activeMinutesToday = 0;
    todayXP = 0;
    eatenToday = 0.0;
    // ----------------------------------------------------------

    // 1. Загружаем данные за конкретный день
    eatenToday = prefs.getDouble('${key}_eaten') ?? 0.0;
    burnedToday = prefs.getDouble('${key}_burned') ?? 0.0;
    waterToday = prefs.getDouble('${key}_water') ?? 0.0;
    stepsToday = prefs.getInt('${key}_steps') ?? 0; // И ВОТ ЭТУ ТОЖЕ
    proteinToday = prefs.getDouble('${key}_protein') ?? 0.0;
    carbsToday = prefs.getDouble('${key}_carbs') ?? 0.0;
    fatsToday = prefs.getDouble('${key}_fats') ?? 0.0;
    isWorkoutFinishedToday = prefs.getBool('${key}_workout_done') ?? false;
    activeMinutesToday = prefs.getInt('${key}_active_mins') ?? 0;
    todayXP = prefs.getInt('${key}_todayXP') ?? 0;

    // 2. Загружаем общие данные профиля
    userName = prefs.getString('userName') ?? "_";
    userAge = prefs.getInt('userAge') ?? 0;
    userHeight = prefs.getDouble('userHeight') ?? 0.0;
    _userAvatar = prefs.getString('userAvatar') ?? '';
    totalXP = prefs.getInt('totalXP') ?? 0;
    userLevel = prefs.getInt('userLevel') ?? 1;
// --- ДОБАВЬ ЭТУ СТРОЧКУ ЗДЕСЬ ---
   _isMale = prefs.getBool('isMale'); // Если данных нет, вернет null (это нам и нужно)
    // 3. Загружаем ВЕСА (Самое важное!)
    currentWeight = prefs.getDouble('currentWeight') ?? 0.0;
    targetWeight = prefs.getDouble('targetWeight') ?? 0.0;
    startWeight = prefs.getDouble('startWeight') ?? 0.0; 

    // 4. Загружаем цели из калькулятора
    dailyCaloriesLimit = prefs.getInt('dailyCaloriesLimit') ?? 0;
    targetWater = prefs.getDouble('targetWater') ?? 0.0;
    targetProtein = prefs.getDouble('targetProtein') ?? 0.0;
    targetCarbs = prefs.getDouble('targetCarbs') ?? 0.0;
    targetFats = prefs.getDouble('targetFats') ?? 0.0;

    // 5. Показатели состава тела и замеры
    bmi = prefs.getDouble('bmi') ?? 0.0;
    tanitaFat = prefs.getDouble('tanitaFat') ?? 0.0;
    tanitaMuscle = prefs.getDouble('tanitaMuscle') ?? 0.0;
    tanitaWater = prefs.getDouble('tanitaWater') ?? 0.0;
    tanitaBoneMass = prefs.getDouble('tanitaBoneMass') ?? 0.0;
    tanitaVisceral = prefs.getInt('tanitaVisceral') ?? 0;
    tanitaProtein = prefs.getDouble('tanitaProtein') ?? 0.0;
    tanitaMetabolicAge = prefs.getInt('tanitaMetabolicAge') ?? 0;
    
    chest = prefs.getDouble('chest') ?? 0.0;
    waist = prefs.getDouble('waist') ?? 0.0;
    hips = prefs.getDouble('hips') ?? 0.0;
    neck = prefs.getDouble('neck') ?? 0.0;
    biceps = prefs.getDouble('biceps') ?? 0.0;
    forearm = prefs.getDouble('forearm') ?? 0.0;
    thigh = prefs.getDouble('thigh') ?? 0.0;
    calf = prefs.getDouble('calf') ?? 0.0;

    await loadWeeklyHistory();
    notifyListeners();
  }

void addMealData({
  required String mealName, 
  required String foodName, 
  required double kcal, 
  required double p, 
  required double f, 
  required double c,
  String? imagePath, // <--- ДОБАВЛЯЕМ ЭТУ СТРОЧКУ (с вопросительным знаком)
}) async {
  String name = mealName.toUpperCase();
  
  // ТЕПЕРЬ ЗАПИСЫВАЕМ ВСЁ:
  final record = FoodRecord(
    name: foodName, 
    kcal: kcal, 
    p: p, 
    f: f, 
    c: c, 
    time: DateTime.now(),
    imagePath: imagePath, // <--- ДОБАВЬ ЭТУ СТРОЧКУ ВНУТРЬ FoodRecord
  );

  // ... (дальше твой код с if-else и _list.add(record) остается без изменений)

    // 1. Плюсуем в конкретную карточку и в список
    if (name == 'BREAKFAST') { 
      breakfastKcal += kcal; breakfastP += p; breakfastF += f; breakfastC += c; 
      _breakfastList.add(record); // <--- Добавляем в историю
    } else if (name == 'SNACK 1') { 
      snack1Kcal += kcal; snack1P += p; snack1F += f; snack1C += c; 
      _snack1List.add(record);
    } else if (name == 'LUNCH') { 
      lunchKcal += kcal; lunchP += p; lunchF += f; lunchC += c; 
      _lunchList.add(record);
    } else if (name == 'SNACK 2') { 
      snack2Kcal += kcal; snack2P += p; snack2F += f; snack2C += c; 
      _snack2List.add(record);
    } else if (name == 'DINNER') { 
      dinnerKcal += kcal; dinnerP += p; dinnerF += f; dinnerC += c; 
      _dinnerList.add(record);
    }

    // 2. Плюсуем в ОБЩИЙ монитор наверху
    eatenToday += kcal;
    proteinToday += p;
    fatsToday += f;
    carbsToday += c;

    // --- А ВОТ СЮДА МЫ ДОПИСЫВАЕМ СОХРАНЕНИЕ В ПАМЯТЬ ---
    // Чтобы данные долетели до Аналитики и Боди-Архива
    _saveToMemory();

    notifyListeners();
  }

  // Вспомогательный метод (добавь его ниже, после метода addMealData)
  Future<void> _saveToMemory() async {
    final prefs = await SharedPreferences.getInstance();
    String key = DateFormat('yyyy-MM-dd').format(DateTime.now());

    await prefs.setDouble('${key}_eaten', eatenToday);
    await prefs.setDouble('${key}_protein', proteinToday);
    await prefs.setDouble('${key}_fats', fatsToday);
    await prefs.setDouble('${key}_carbs', carbsToday);
    
    // Обновляем историю, чтобы графики в Аналитике сразу выросли
    await loadWeeklyHistory();
  }

// --- МЕТОД ДЛЯ УДАЛЕНИЯ ЕДЫ ИЗ СПИСКА (УРНА) ---
void removeFoodFromMeal(String mealName, int index) {
  String name = mealName.toUpperCase();
  FoodRecord? recordToRemove;

  // 1. Находим продукт и список
  if (name == 'BREAKFAST') recordToRemove = _breakfastList[index];
  else if (name == 'SNACK 1') recordToRemove = _snack1List[index];
  else if (name == 'LUNCH') recordToRemove = _lunchList[index];
  else if (name == 'SNACK 2') recordToRemove = _snack2List[index];
  else if (name == 'DINNER') recordToRemove = _dinnerList[index];

  if (recordToRemove != null) {
    // 2. ВЫЧИТАЕМ калории из общего монитора (чтобы цифра на главной уменьшилась)
    eatenToday -= recordToRemove.kcal;
    
    // Если у тебя в FoodRecord есть БЖУ, вычитай и их:
     proteinToday -= recordToRemove.p; 
     fatsToday -= recordToRemove.f;
     carbsToday -= recordToRemove.c;

    // 3. Вычитаем из конкретной карточки (BreakfastKcal и т.д.)
    if (name == 'BREAKFAST') {
       breakfastKcal -= recordToRemove.kcal;
       _breakfastList.removeAt(index);
    } else if (name == 'SNACK 1') {
       snack1Kcal -= recordToRemove.kcal;
       _snack1List.removeAt(index);
    } else if (name == 'LUNCH') {
       lunchKcal -= recordToRemove.kcal;
       _lunchList.removeAt(index);
    } else if (name == 'SNACK 2') {
       snack2Kcal -= recordToRemove.kcal;
       _snack2List.removeAt(index);
    } else if (name == 'DINNER') {
       dinnerKcal -= recordToRemove.kcal;
       _dinnerList.removeAt(index);
    }
  }

  notifyListeners(); // Теперь и Листик, и Главный монитор обновятся одновременно!
}

  Future<void> updateEaten(double kcal) async {
    eatenToday = kcal;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_dateKey}_eaten', eatenToday);
    await loadWeeklyHistory();
    notifyListeners();
  }

  Future<void> updateBurned(double kcal) async {
    burnedToday += kcal; // ИСПРАВЛЕНО: теперь тоже суммирует
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('${_dateKey}_burned', burnedToday);
    await loadWeeklyHistory();
    notifyListeners();
  }

  Future<void> updateActiveMinutes(int minutes) async {
    activeMinutesToday = minutes;
    final prefs = await SharedPreferences.getInstance();
    // Сохраняем минуты именно за выбранный день
    await prefs.setInt('${_dateKey}_active_mins', activeMinutesToday);
    notifyListeners();
  }

  Future<void> updateMacros({double? protein, double? carbs, double? fats, double? water}) async {
    final prefs = await SharedPreferences.getInstance();
    if (protein != null) { proteinToday = protein; await prefs.setDouble('${_dateKey}_protein', proteinToday); }
    if (carbs != null) { carbsToday = carbs; await prefs.setDouble('${_dateKey}_carbs', carbsToday); }
    if (fats != null) { fatsToday = fats; await prefs.setDouble('${_dateKey}_fats', fatsToday); }
    if (water != null) { waterToday = water; await prefs.setDouble('${_dateKey}_water', waterToday); }
    notifyListeners();
  }

  Future<void> updateWeight(double val, {bool isTarget = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (isTarget) { targetWeight = val; await prefs.setDouble('targetWeight', val); }
    else { 
      currentWeight = val; await prefs.setDouble('currentWeight', val); 
      double hMeter = userHeight / 100;
      if (hMeter > 0) bmi = currentWeight / (hMeter * hMeter);
    }
    notifyListeners();
  }

  Future<void> updateProfile(String name, int age, double height) async {
    final prefs = await SharedPreferences.getInstance();
    userName = name; userAge = age; userHeight = height;
    await prefs.setString('userName', name);
    await prefs.setInt('userAge', age);
    await prefs.setDouble('userHeight', height);
    notifyListeners();
  }

Future<void> updateAvatar(String newPath) async {
    final prefs = await SharedPreferences.getInstance();
    _userAvatar = newPath; // Меняем путь (например, на 'avatars/woman1.jpg')
    
    // Сохраняем этот путь в память телефона навсегда
    await prefs.setString('userAvatar', newPath);
    
    notifyListeners(); // Даем команду экрану перерисоваться
  }

  Future<void> updateStartWeight(double val) async {
    final prefs = await SharedPreferences.getInstance();
    startWeight = val;
    await prefs.setDouble('startWeight', val);
    notifyListeners();
  }

  Future<void> updateBodyMetrics({
    double? muscle, int? visceral, double? bone, int? metAge,
    double? c, double? w, double? h,
    double? nk, double? bic, double? forarm, double? thgh, double? clf, // Новые сокращения
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (muscle != null) { tanitaMuscle = muscle; await prefs.setDouble('tanitaMuscle', muscle); }
    if (visceral != null) { tanitaVisceral = visceral; await prefs.setInt('tanitaVisceral', visceral); }
    if (bone != null) { tanitaBoneMass = bone; await prefs.setDouble('tanitaBoneMass', bone); }
    if (metAge != null) { tanitaMetabolicAge = metAge; await prefs.setInt('tanitaMetabolicAge', metAge); }
    
    // Замеры
    if (c != null) { chest = c; await prefs.setDouble('chest', c); }
    if (w != null) { waist = w; await prefs.setDouble('waist', w); }
    if (h != null) { hips = h; await prefs.setDouble('hips', h); }
    if (nk != null) { neck = nk; await prefs.setDouble('neck', nk); }
    if (bic != null) { biceps = bic; await prefs.setDouble('biceps', bic); }
    if (forarm != null) { forearm = forarm; await prefs.setDouble('forearm', forarm); }
    if (thgh != null) { thigh = thgh; await prefs.setDouble('thigh', thgh); }
    if (clf != null) { calf = clf; await prefs.setDouble('calf', clf); }
    
    notifyListeners();
  }

  Future<void> updateFromCalculator(CalcData data) async {
    final prefs = await SharedPreferences.getInstance();

    // 1. ПРИСВАИВАЕМ ЗНАЧЕНИЯ ПЕРЕМЕННЫМ
    currentWeight = double.tryParse(data.currentWeight) ?? currentWeight;
    targetWeight = double.tryParse(data.idealWeight) ?? targetWeight;
    dailyCaloriesLimit = int.tryParse(data.dailyCalories) ?? dailyCaloriesLimit;
    targetWater = double.tryParse(data.water) ?? targetWater;
    targetProtein = double.tryParse(data.protein) ?? targetProtein;
    targetCarbs = double.tryParse(data.dailyCarbs) ?? targetCarbs;
    targetFats = double.tryParse(data.dailyFats) ?? targetFats;
    tanitaFat = double.tryParse(data.bfNavy) ?? tanitaFat;

    // --- НОВАЯ ВСТАВКА (ЗАМЕРЫ) ---
    neck = double.tryParse(data.neck) ?? neck;
    waist = double.tryParse(data.waist) ?? waist;
    hips = double.tryParse(data.hips) ?? hips;
    // ------------------------------

    double hMeter = userHeight / 100;
    if (hMeter > 0) bmi = currentWeight / (hMeter * hMeter);

    // 2. СОХРАНЯЕМ ФИЗИЧЕСКИ В ПАМЯТЬ ТЕЛЕФОНА
    await prefs.setDouble('currentWeight', currentWeight);
    await prefs.setDouble('targetWeight', targetWeight);
    await prefs.setInt('dailyCaloriesLimit', dailyCaloriesLimit);
    await prefs.setDouble('targetWater', targetWater);
    await prefs.setDouble('targetProtein', targetProtein);
    await prefs.setDouble('targetCarbs', targetCarbs);
    await prefs.setDouble('targetFats', targetFats);
    await prefs.setDouble('tanitaFat', tanitaFat);
    await prefs.setDouble('bmi', bmi);
    
    // --- НОВАЯ ВСТАВКА (СОХРАНЕНИЕ ЗАМЕРОВ) ---
    await prefs.setDouble('neck', neck);
    await prefs.setDouble('waist', waist);
    await prefs.setDouble('hips', hips);
    // -----------------------------------------
    
    notifyListeners();
  }

// --- СИСТЕМА ОПЫТА (XP) ДЛЯ ЗОЛОТЫХ КРИСТАЛЛОВ ---
  Future<void> addExperience(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    String key = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Добавляем к общему счету
    totalXP += xp;
    // 2. Добавляем к сегодняшнему результату
    todayXP += xp;

    // 3. Рассчитываем уровень (например, каждый уровень = 1000 XP)
    userLevel = (totalXP / 1000).floor() + 1;

    // 4. Сохраняем всё в память
    await prefs.setInt('totalXP', totalXP);
    await prefs.setInt('userLevel', userLevel);
    await prefs.setInt('${key}_todayXP', todayXP); // Сохраняем опыт именно за СЕГОДНЯ

    notifyListeners();
  }

  Future<void> loadWeeklyHistory() async {
    final prefs = await SharedPreferences.getInstance();
    weeklyHistory.clear();
    for (int i = 0; i < 7; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String key = DateFormat('yyyy-MM-dd').format(date);
      weeklyHistory[key] = {
        'eaten': prefs.getDouble('${key}_eaten') ?? 0.0,
        'burned': prefs.getDouble('${key}_burned') ?? 0.0,
      };
    }
  }

  // --- ДОБАВЛЕНО ДЛЯ УСТРАНЕНИЯ ОШИБОК В PROGRESS SCREEN ---
  double get totalWeightLost => startWeight - currentWeight;
  bool get isYearPassed => false; 

  void setPeriod(String period) { selectedPeriod = period; notifyListeners(); }
  
  // --- НОВЫЙ МЕТОД ДЛЯ СОХРАНЕНИЯ ПОЛА ---
  Future<void> updateGender(bool? male) async {
    final prefs = await SharedPreferences.getInstance();
    _isMale = male;
    if (male == null) {
      await prefs.remove('isMale'); // Если сбрасываем — удаляем ключ из памяти
    } else {
      await prefs.setBool('isMale', male);
    }
    notifyListeners();
  }

  Future<void> resetDailyMetrics() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    await _init(); 
    notifyListeners();
  }
  // Метод для золотых кристаллов: отмечаем успех
  Future<void> completeWorkout() async {
    final prefs = await SharedPreferences.getInstance();
    isWorkoutFinishedToday = true;
    await prefs.setBool('${_dateKey}_workout_done', true);
    notifyListeners(); 
  }
  // --- ТОТ САМЫЙ МЕТОД ДЛЯ ОБНОВЛЕНИЯ УРОВНЯ (ЧТОБЫ РАБОТАЛА КНОПКА ТЕСТА) ---
  Future<void> updateLevel(int newLevel) async {
    final prefs = await SharedPreferences.getInstance();
    userLevel = newLevel; // Ставим уровень (например, 4)
    
    // Сохраняем в память телефона, чтобы не пропало при перезагрузке
    await prefs.setInt('userLevel', userLevel);
    
    notifyListeners(); // ГОВОРИМ ЭКРАНУ: "ЭЙ, У НАС 4 УРОВЕНЬ! НАДЕВАЙ АРТЕФАКТЫ!"
  }
  // --- МЕТОД ДЛЯ ВОДЫ (ПРИБАВЛЕНИЕ) ---
  Future<void> addWater(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Прибавляем к текущему значению
    waterToday += amount;
    
    // Сохраняем в память телефона по ключу текущей даты
    await prefs.setDouble('${_dateKey}_water', waterToday);
    
    // Важно: это заставит Эволюцию пересчитать XP, так как сработает notifyListeners
    notifyListeners(); 
  }

  // --- МЕТОД ДЛЯ ШАГОВ (ПРИБАВЛЕНИЕ) ---
  Future<void> addSteps(int steps) async {
    final prefs = await SharedPreferences.getInstance();
    stepsToday += steps;
    await prefs.setInt('${_dateKey}_steps', stepsToday);
    notifyListeners();
  }
}