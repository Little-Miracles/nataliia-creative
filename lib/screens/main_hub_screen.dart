import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_body_life/screens/bio_creator_form.dart';
import 'package:smart_body_life/screens/body_screen.dart';
import 'package:smart_body_life/screens/evolution_session_screen.dart';
import 'package:smart_body_life/screens/food_screen.dart';
import 'package:smart_body_life/screens/gym_screen.dart';
import 'package:smart_body_life/screens/laboratory_screen.dart';
import 'package:smart_body_life/screens/progress_screen.dart';
import 'package:smart_body_life/screens/settings_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:smart_body_life/utils/translation_service.dart';
import 'package:google_fonts/google_fonts.dart';

class MainHubScreen extends StatefulWidget {
  const MainHubScreen({super.key});

  @override
  State<MainHubScreen> createState() => _MainHubScreenState();
}

class _MainHubScreenState extends State<MainHubScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  double unit = 0;

  // --- ТЕКСТОВЫЕ ПЕРЕМЕННЫЕ ---
  String title = "EVOLUTION HUB";
  String subtitle = "SYSTEM READY";
  String manualBtn = "READ SYSTEM MANUAL";

  // Названия плиток
  String hubAnalytics = "ANALYTICS";
  String hubBody = "BODY ARCHIVE";
  String hubGym = "GYM ARCADE";
  String hubNutrition = "NUTRITION LAB";
  String hubLaboratory = "BIO-MACHINE DESIGNER";
  String hubFoodDesigner = "BIO-FOOD DESIGNER";
  String hubSettings = "SYSTEM SETTINGS";
  String hubAvatar = "MY EVOLUTION"; // <--- НОВОЕ

  // Переменные для Шторки
  String manualHeader = "MANUAL: EVOLUTION SYSTEM";
  String builderTitle = "BUILDER";
  String builderDesc = "This app is your personal body builder. Training, nutrition, and evolution are combined here.";
  String workoutsTitle = "WORKOUTS";
  String workoutsDesc = "Use ready-made programs or create your own. Every workout has a memory.";
  String labTitle = "BIO-MACHINE DESIGNER";
  String labDesc = "Can't find a machine? Create your own unique equipment in the Bio-Machine Designer.";
  String energyTitle = "ENERGY & AVATAR";
  String energyDesc = "Earn points and crystals. Watch your avatar evolve and unlock rare artifacts.";
  String foodDesignerTitle = "BIO-FOOD DESIGNER";
  String foodDesignerDesc = "Create your own unique dishes. Mix nutrients and save your personal recipes.All product names, logos, and brands are property of their respective owners. All company, product and service names used in this app are for identification purposes only. Use of these names, logos, and brands does not imply endorsement.";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('videos/intro.mov')
      ..initialize().then((_) {
        if (!mounted) return; 
        
        setState(() {
          _isInitialized = true;
        });
        
        _controller.setLooping(false); 
        _controller.setVolume(1.0);    
        _controller.play();            
        
        _controller.addListener(() {
          if (_controller.value.position == _controller.value.duration) {
            setState(() {}); 
          }
        });
      }).catchError((error) {
        debugPrint("Video player error: $error");
      });
  }

  // --- ЛОГИКА ПЕРЕВОДА ---
  Future<void> _translateInterface(String langCode) async {
    final t1 = await TranslationService.translateText("EVOLUTION HUB", langCode);
    final t2 = await TranslationService.translateText("SYSTEM READY", langCode);
    final t3 = await TranslationService.translateText("READ SYSTEM MANUAL", langCode);
    final tAv = await TranslationService.translateText("MY EVOLUTION", langCode);

    final tAna = await TranslationService.translateText("ANALYTICS", langCode);
    final tBod = await TranslationService.translateText("BODY ARCHIVE", langCode);
    final tGym = await TranslationService.translateText("GYM ARCADE", langCode);
    final tNut = await TranslationService.translateText("NUTRITION LAB", langCode);
    final tLab = await TranslationService.translateText("BIO-MACHINE DESIGNER", langCode);
    final tFood = await TranslationService.translateText("BIO-FOOD DESIGNER", langCode);

    
    final tSet = await TranslationService.translateText("SYSTEM SETTINGS", langCode);

    final mHeader = await TranslationService.translateText("MANUAL: EVOLUTION SYSTEM", langCode);
    final mBTitle = await TranslationService.translateText("BUILDER", langCode);
    final mBDesc = await TranslationService.translateText("This app is your personal body builder. Training, nutrition, and evolution are combined here.", langCode);
    final mWTitle = await TranslationService.translateText("WORKOUTS", langCode);
    final mWDesc = await TranslationService.translateText("Use ready-made programs or create your own. Every workout has a memory.", langCode);
    final mETitle = await TranslationService.translateText("ENERGY & AVATAR", langCode);
    final mEDesc = await TranslationService.translateText("Earn points and crystals. Watch your avatar evolve and unlock rare artifacts.", langCode);
    final tFoodTitle = await TranslationService.translateText("BIO-FOOD DESIGNER", langCode);
    final mLabTitle = await TranslationService.translateText("BIO-MACHINE DESIGNER", langCode);
    final mLabDesc = await TranslationService.translateText("Can't find a machine? Create your own unique equipment in the Bio-Machine Designer.", langCode);
    // 1. Переводим первую (живую) часть
    final tFoodDescPart1 = await TranslationService.translateText("Create your own unique dishes. Mix nutrients and save your personal recipes.", langCode);

    // 2. Переводим юридическую часть отдельно (так она точно пройдет через лимит)
    final tFoodDescPart2 = await TranslationService.translateText("All product names, logos, and brands are property of their respective owners. All company, product and service names used in this app are for identification purposes only. Use of these names, logos, and brands does not imply endorsement.", langCode);
   

    if (mounted) {
      setState(() {
        // --- ГЛАВНЫЙ ЭКРАН ---
        title = t1; 
        subtitle = t2; 
        manualBtn = t3; 
        hubAvatar = tAv;
        hubAnalytics = tAna; 
        hubGym = tGym; 
        hubBody = tBod; 
        hubNutrition = tNut; 
        hubLaboratory = tLab; 
        hubSettings = tSet; 
        hubFoodDesigner = tFood;

        // --- ШТОРКА (МАНУАЛ) ---
        manualHeader = mHeader; 
        
        builderTitle = mBTitle; 
        builderDesc = mBDesc; 
        
        workoutsTitle = mWTitle; 
        workoutsDesc = mWDesc; 
        
        energyTitle = mETitle; 
        energyDesc = mEDesc;

        // БИО-МАШИНЫ (Тот самый "беглец")
        labTitle = mLabTitle; 
        labDesc = mLabDesc;

        // БИО-ФУД (Еда)
        foodDesignerTitle = tFoodTitle; 
        
        // СОЕДИНЯЕМ ДВА ПЕРЕВОДА В ОДИН
        foodDesignerDesc = "$tFoodDescPart1\n\n$tFoodDescPart2";
      });
    }
  }


  // --- ПЛИТКА-МАГНИТ ДЛЯ АВАТАРА (ЗОЛОТАЯ) ---
  Widget _avatarVipTile() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: unit * 7, vertical: unit * 2),
      child: GestureDetector(
        onTap: () => Navigator.push(
  context, 
  MaterialPageRoute(builder: (context) => const EvolutionSessionScreen()) // <--- ТВОЙ ПРАВИЛЬНЫЙ АДРЕС
),
        child: Container(
          padding: EdgeInsets.all(unit * 2.5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFD4AF37).withOpacity(0.2), const Color(0xFF1A1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(unit * 3),
            border: Border.all(color: const Color(0xFFD4AF37), width: 1.2),
            boxShadow: [
              BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.1), blurRadius: 10, spreadRadius: 1),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: const Color(0xFFD4AF37), size: unit * 6),
              SizedBox(width: unit * 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // Чтобы колонка не растягивалась вверх
                  children: [
                    Text(hubAvatar, style: GoogleFonts.saira(color: const Color(0xFFD4AF37), fontSize: unit * 4, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    Text("Check artifacts & evolve", style: GoogleFonts.saira(color: Colors.white60, fontSize: unit * 2.8)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: const Color(0xFFD4AF37), size: unit * 4),
            ],
          ),
        ),
      ),
    );
  }

  // --- ДИАЛОГ ВЫБОРА ЯЗЫКА ---
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("CHOOSE LANGUAGE", textAlign: TextAlign.center, style: TextStyle(color: const Color(0xFFD4AF37))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _langOption("Українська", "uk"),
            _langOption("Deutsch", "de"),
            _langOption("Français", "fr"),
            _langOption("Español", "es"),
            _langOption("English", "en"),
          ],
        ),
      ),
    );
  }

  Widget _langOption(String name, String code) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: Colors.white)),
      onTap: () { _translateInterface(code); Navigator.pop(context); },
    );
  }

  void _showInstructions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(unit * 8)),
          border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(margin: EdgeInsets.only(top: unit * 3), height: 4, width: unit * 12, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(unit * 6),
                children: [
                  Text(manualHeader, style: GoogleFonts.saira(color: const Color(0xFFD4AF37), fontSize: unit * 5, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                  SizedBox(height: unit * 4),
                  _infoBlock(builderTitle, builderDesc, Icons.architecture),
                  _infoBlock(workoutsTitle, workoutsDesc, Icons.fitness_center),
                  _infoBlock(energyTitle, energyDesc, Icons.auto_awesome),
                  _infoBlock(labTitle, labDesc, Icons.biotech),
                  _infoBlock(foodDesignerTitle, foodDesignerDesc, Icons.blur_on_outlined),
                  Center(child: TextButton(onPressed: () => Navigator.pop(context), child: Text("I UNDERSTAND", style: GoogleFonts.saira(color: const Color(0xFFD4AF37), fontSize: unit * 3)))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _infoBlock(String t, String s, IconData i) {
  return Padding(
    padding: EdgeInsets.only(bottom: unit * 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Icon(i, color: const Color(0xFFD4AF37), size: unit * 7),
        SizedBox(width: unit * 4),
        Expanded(
          child: Container(
            // ПАРАМЕТР 1: Мы НЕ задаем высоту (height). 
            // Это значит, что Container сам вырастет вниз столько, сколько нужно.
            padding: EdgeInsets.all(unit * 4),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A), 
              borderRadius: BorderRadius.circular(unit * 3), 
              border: Border.all(color: Colors.white10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Важно! Заставляет колонку поджиматься под текст
              children: [
                Text(
                  t, 
                  style: GoogleFonts.saira(color: const Color(0xFFD4AF37), fontSize: unit * 4.2, fontWeight: FontWeight.w700)
                ),
                SizedBox(height: unit * 1),
                
                // ПАРАМЕТР 2: Твоя страховка.
                // Текст сначала пытается занять всё место (хоть 20 строк).
                // Но если он встретит "преграду", он начнет уменьшаться.
                FittedBox(
                  fit: BoxFit.scaleDown, // Страховка: уменьшит шрифт, если текст не лезет по ширине
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    // Ограничиваем только ширину, чтобы текст знал, где переноситься
                    constraints: BoxConstraints(maxWidth: unit * 70), 
                    child: Text(
                      s,
                      softWrap: true,
                      // Мы НЕ ставим maxLines, чтобы окно росло бесконечно вниз.
                      style: GoogleFonts.saira(
                        color: const Color(0xFF757575), 
                        fontSize: unit * 3.6, 
                        height: 1.4
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    unit = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // ВИДЕО
            Container(
              height: unit * 55,
              child: _isInitialized 
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        // Если видео играет — ставим паузу, если нет — запускаем!
                        _controller.value.isPlaying 
                            ? _controller.pause() 
                            : _controller.play();
                      });
                    },
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio, 
                      child: VideoPlayer(_controller),
                    ),
                  ) 
                : Container(),
            ),

// ИНФО-ПАНЕЛЬ (Текст отдельно, иконки отдельно)
Padding(
  padding: EdgeInsets.symmetric(horizontal: unit * 5, vertical: unit * 2),
  child: Row(
    children: [
      // КОМНАТА 1: Весь текст слева
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(subtitle, style: GoogleFonts.saira(color: Colors.white38, fontSize: unit * 3.5)),
            ),
            // Текст заголовка зажат!
            FittedBox(
              fit: BoxFit.scaleDown, // Если не лезет — станет мелким
              child: Text(
                title,
                maxLines: 2,
                style: GoogleFonts.saira(color: const Color(0xFFD4AF37), fontSize: unit * 5, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      
      SizedBox(width: unit * 2), // Забор между текстом и иконками

      // КОМНАТА 2: Иконки глобуса и синхронизации справа
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.language, color: const Color(0xFFD4AF37), size: unit * 6), onPressed: _showLanguageDialog),
          IconButton(icon: Icon(Icons.cloud_sync, color: const Color(0xFFD4AF37), size: unit * 6), onPressed: () {}),
        ],
      ),
    ],
  ),
),
// ИНСТРУКЦИЯ (Теперь реально резиновая под текст!)
Padding(
  padding: EdgeInsets.symmetric(horizontal: unit * 10, vertical: unit * 2),
  child: GestureDetector(
    onTap: () => _showInstructions(context),
    child: Container(
      // Убрали фиксированные отступы, даем контейнеру дышать
      padding: EdgeInsets.symmetric(horizontal: unit * 4, vertical: unit * 2.5),
      decoration: BoxDecoration(
        color: const Color(0xFFD4AF37).withOpacity(0.1),
        borderRadius: BorderRadius.circular(unit * 3),
        border: Border.all(color: const Color(0xFFD4AF37)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, // Центрируем иконку по вертикали, если строк будет много
        children: [
          // Иконка книжки (никуда не делась, стоит слева)
          Icon(Icons.auto_stories, color: const Color(0xFFD4AF37), size: unit * 5),
          
          SizedBox(width: unit * 3),

          // ТЕКСТ: Теперь он РЕЗИНОВЫЙ
          Expanded( 
            child: Text(
              manualBtn,
              textAlign: TextAlign.center,
              // Убрали FittedBox! Теперь буквы будут крупными (unit * 4.2)
              // Если текст длинный, он просто перепрыгнет на новую строку
              softWrap: true, 
              maxLines: 5, // Запас на 5 строк, чтобы влез любой перевод
              style: GoogleFonts.saira(
                color: const Color(0xFFD4AF37), 
                fontWeight: FontWeight.w500,
                fontSize: unit * 4.2, // Твой комфортный размер
                height: 1.1, // Чтобы строки не слипались, но были компактными
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
            // СПИСОК КНОПОК
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // _avatarVipTile(), // <--- НАШ ГЕРОЙ В САМОМ ВЕРХУ
                    _hubTile(hubAnalytics, Icons.analytics_outlined, Colors.amber, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen()))),
                    _hubTile(hubBody, Icons.accessibility_new, const Color(0xFFD4AF37), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BodyScreen()))),
                    _hubTile(hubGym, Icons.fitness_center, Colors.redAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GymScreen()))),
                    _hubTile(hubNutrition, Icons.set_meal, Colors.lightGreenAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FoodScreen()))),
                    _hubTile(hubLaboratory, Icons.biotech, Colors.purpleAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LaboratoryScreen()))),
                    _hubTile(hubFoodDesigner, Icons.blur_on, Colors.orangeAccent, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BioCreatorForm(mealName: 'Designer')))),
                    // --- ВОТ ЗДЕСЬ ТЕПЕРЬ ТВОЯ ЗОЛОТАЯ КНОПКА ---
                    // Ставим её после всех "рабочих" разделов
                    _avatarVipTile(), 
                    SizedBox(height: unit * 1), // Небольшой зазор для ритма
                    _hubTile(hubSettings, Icons.settings, Colors.blueGrey, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()))),
                    SizedBox(height: unit * 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _hubTile(String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: unit * 7, vertical: unit * 1.5),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(unit * 3),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A).withOpacity(0.8), 
            borderRadius: BorderRadius.circular(unit * 3), 
            border: Border.all(color: color.withOpacity(0.2))
          ),
          child: Row(
            children: [
              // Квадрат для иконки
              SizedBox(
                width: unit * 8, 
                child: Icon(icon, color: color, size: unit * 6)
              ),
              SizedBox(width: unit * 3),
              // ТЕКСТ: Теперь он ОБЯЗАН уменьшиться, если не влезает
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Команда на уменьшение размера букв
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title, 
                    style: GoogleFonts.saira(color: Colors.white70, fontSize: unit * 4, letterSpacing: 1.2)
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white10),
            ],
          ),
        ),
      ),
    );
  }
}
