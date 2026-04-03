import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/metrics_provider.dart';
import '../screens/calc_screen.dart';

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  // --- ФИРМЕННАЯ ПАЛИТРА ---
  static const Color gemBackground = Color(0xFF050505);
  static const Color gemSteel = Color(0xFF1C1E20);
  static const Color gemSteelLight = Color(0xFF2A2D31);
  static const Color gemGold = Color(0xFFFFD700);
  static const Color gemEmerald = Color(0xFF00FF9D);
  static const Color gemSapphire = Color(0xFF082567);
  static const Color gemSecondaryText = Color(0xFF9FAFA8);

  // Метод для определения времени суток
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'GOOD MORNING,';
    if (hour < 17) return 'GOOD AFTERNOON,';
    return 'GOOD EVENING,';
  }

  @override
  Widget build(BuildContext context) {
    final metrics = context.watch<MetricsProvider>();

    return Scaffold(
      backgroundColor: gemBackground,
      appBar: AppBar(
        // Наша золотая стрелочка для возврата в Хаб
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFD4AF37), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('BODY PROFILE', 
          style: TextStyle(color: gemGold, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            // 1. ШАПКА
            _buildProfileHeader(context, metrics),
            
            const SizedBox(height: 20),

            // 2. СИНЯЯ ПАНЕЛЬ ВЕСА
            _buildWeightJourney(metrics),
            const SizedBox(height: 20),
            _buildDailyTargetsPanel(metrics),
            const SizedBox(height: 25),

            // 3. ЗАГОЛОВКИ КОЛОНОК (Более понятные)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(child: _columnHeader("MEASUREMENTS (CM)", gemGold)),
                  const SizedBox(width: 15),
                  Expanded(child: _columnHeader("COMPOSITION (TANITA)", gemEmerald)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // 4. КАРТОЧКИ (Систематизированные)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ЛЕВАЯ КОЛОНКА: ЗАМЕРЫ (7 карточек)
                Expanded(
                  child: Column(
                    children: [
                      _buildMetricCard('NECK', '${metrics.neck}', Icons.straighten, gemGold),
                      _buildMetricCard('SHOULDERS', '${metrics.chest}', Icons.architecture, gemGold),
                      _buildMetricCard('WAIST', '${metrics.waist}', Icons.line_weight, gemGold),
                      _buildMetricCard('HIPS', '${metrics.hips}', Icons.accessibility, gemGold),
                      _buildMetricCard('BICEPS', '${metrics.biceps}', Icons.fitness_center, gemGold),
                      _buildMetricCard('THIGH', '${metrics.thigh}', Icons.downhill_skiing, gemGold),
                      _buildMetricCard('CALF', '${metrics.calf}', Icons.directions_run, gemGold),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                
                // ПРАВАЯ КОЛОНКА: СОСТАВ ТЕЛА + КНОПКА (7 карточек)
                Expanded(
                  child: Column(
                    children: [
                      _buildMetricCard('BMI', metrics.bmi.toStringAsFixed(1), Icons.speed, Colors.blueAccent),
                      _buildMetricCard('BODY FAT', '${metrics.tanitaFat}%', Icons.pie_chart, gemEmerald),
                      _buildMetricCard('MUSCLE', '${metrics.tanitaMuscle}kg', Icons.bolt, Colors.orangeAccent),
                      _buildMetricCard('WATER %', '${metrics.tanitaWater}%', Icons.opacity, Colors.blue),
                      _buildMetricCard('VISCERAL', '${metrics.tanitaVisceral}', Icons.warning_amber, Colors.redAccent),
                      _buildMetricCard('MET. AGE', '${metrics.tanitaMetabolicAge}', Icons.auto_awesome, gemGold),
                      
                      // ВОТ ОНА — 7-Я КАРТОЧКА-КНОПКА
                      _buildActionCard(
                        context,
                        'CALCULATOR', 
                        'SCIENTIFIC', 
                        Icons.calculate, 
                        gemGold,
                        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CalcScreen())),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            ElevatedButton.icon(
              onPressed: () => _showUpdateDialog(context, metrics),
              icon: const Icon(Icons.edit_note, color: Colors.black),
              label: const Text('UPDATE ALL METRICS', 
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: gemGold,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ ВИДЖЕТЫ ---

  Widget _columnHeader(String title, Color color) {
    return Text(title, 
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)
    );
  }

  Widget _buildMetricCard(String label, String value, IconData icon, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [gemSteelLight, gemSteel, Color(0xFF0F0F0F)],
        ),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withAlpha(5)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 4, offset: const Offset(2, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(label, style: const TextStyle(color: gemSecondaryText, fontSize: 8, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildActionCard(BuildContext context, String label, String value, IconData icon, Color accentColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [gemGold.withAlpha(30), gemSteel, Colors.black], // Немного золотистого блеска
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: gemGold.withAlpha(50), width: 1), // Выделяем рамкой
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 4, offset: const Offset(2, 2))],
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(color: accentColor, fontSize: 13, fontWeight: FontWeight.bold)),
                  Text(label, style: const TextStyle(color: Colors.white70, fontSize: 8, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 10), // Стрелочка "нажми меня"
          ],
        ),
      ),
    );
  }

 Widget _buildProfileHeader(BuildContext context, MetricsProvider metrics) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: gemSteel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(15)),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(150), blurRadius: 10, offset: const Offset(4, 4)),
        ]
      ),
      // ВОТ ТУТ МЫ ВОЗВРАЩАЕМ ROW:
      child: Row( 
        children: [
          // 1. АВАТАР (Выбор из библиотеки)
          // 1. АВАТАР (Выбор из библиотеки)
          GestureDetector(
            onTap: () => _showPhotoPickerOptions(context, metrics),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: gemSteelLight,
              // ПРОВЕРКА 1: Если путь не пустой, ставим картинку
              backgroundImage: metrics.userAvatar.isNotEmpty 
                  ? AssetImage(metrics.userAvatar) 
                  : null,
              // ПРОВЕРКА 2: Если путь пустой, ставим иконку фотоаппарата
              child: metrics.userAvatar.isEmpty 
                  ? const Icon(Icons.add_a_photo, color: gemGold, size: 24) 
                  : null,
            ), 
          ),
          const SizedBox(width: 15),
          
          // Здесь дальше идет твой код с именем и возрастом...
          
          // 2. ИМЯ + ДАННЫЕ + КАРАНДАШ (Теперь это всё одна кнопка)
          Expanded(
            child: GestureDetector(
              onTap: () => _showEditProfile(context, metrics),
              behavior: HitTestBehavior.opaque, // Чтобы нажатие ловилось везде
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_getGreeting(), style: const TextStyle(color: gemSecondaryText, fontSize: 10, letterSpacing: 1.5)),
                        const SizedBox(height: 2),
                        Text(metrics.userName.toUpperCase(), 
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
                        const SizedBox(height: 2),
                        Text('${metrics.userAge} years • ${metrics.userHeight.toInt()} cm', 
                          style: const TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                  // Карандаш теперь ВНУТРИ GestureDetector
                  const Icon(Icons.edit, color: gemGold, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeightJourney(MetricsProvider metrics) {
    double lost = metrics.startWeight - metrics.currentWeight;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [gemSapphire, gemBackground]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gemSapphire.withAlpha(120)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _weightInfo('START', metrics.startWeight, isStart: true),
          Column(
            children: [
              Text('${lost >= 0 ? "-" : "+"}${lost.abs().toStringAsFixed(1)}', 
                style: const TextStyle(color: gemGold, fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('PROGRESS', style: TextStyle(color: gemGold, fontSize: 8, fontWeight: FontWeight.bold)),
            ],
          ),
          _weightInfo('TARGET', metrics.targetWeight),
        ],
      ),
    );
  }

  Widget _weightInfo(String label, double value, {bool isStart = false}) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: isStart ? gemGold : Colors.white38, fontSize: 10, fontWeight: isStart ? FontWeight.bold : FontWeight.normal)),
        Container(
          padding: isStart ? const EdgeInsets.all(8) : EdgeInsets.zero,
          decoration: isStart ? BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: gemGold.withAlpha(100), width: 1),
          ) : null,
          child: Text('${value.toInt()}', 
            style: TextStyle(color: isStart ? gemGold : Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        const Text('kg', style: TextStyle(color: Colors.white24, fontSize: 10)),
      ],
    );
  }
Widget _buildDailyTargetsPanel(MetricsProvider metrics) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: gemSteel,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: gemGold.withAlpha(40)),
      ),
      child: Column(
        children: [
          const Text("DAILY PLAN (FROM CALCULATOR)", 
            style: TextStyle(color: gemGold, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _targetItem("CALORIES", "${metrics.dailyCaloriesLimit}", Icons.local_fire_department, gemGold),
              _targetItem("WATER", "${metrics.targetWater}L", Icons.water_drop, Colors.blue),
              _targetItem("PROTEIN", "${metrics.targetProtein.toInt()}g", Icons.egg, gemEmerald),
            ],
          ),
        ],
      ),
    );
  }

  Widget _targetItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: gemSecondaryText, fontSize: 8)),
      ],
    );
  }

  void _showEditProfile(BuildContext context, MetricsProvider metrics) {
    final nameCtrl = TextEditingController(text: metrics.userName);
    final ageCtrl = TextEditingController(text: metrics.userAge.toString());
    final heightCtrl = TextEditingController(text: metrics.userHeight.toInt().toString());
    // Контроллер для нашего стартового веса
    final startWeightCtrl = TextEditingController(text: metrics.startWeight.toString()); 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemSteel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('EDIT PROFILE DATA', style: TextStyle(color: gemGold, fontWeight: FontWeight.bold, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dialogField("User Name", nameCtrl, isNumber: false),
            _dialogField("Age", ageCtrl, isNumber: true),
            _dialogField("Height (cm)", heightCtrl, isNumber: true),
            // Выделяем это поле цветом, чтобы не путать с текущим весом
            TextField(
              controller: startWeightCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: gemGold, fontSize: 16, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: "STARTING WEIGHT (POINT A)",
                labelStyle: TextStyle(color: gemGold, fontSize: 11),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gemGold)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL', style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gemGold),
            onPressed: () {
              // Сохраняем все данные
              metrics.updateProfile(
                nameCtrl.text, 
                int.tryParse(ageCtrl.text) ?? metrics.userAge,
                double.tryParse(heightCtrl.text.replaceAll(',', '.')) ?? metrics.userHeight
              );
              // Тот самый важный провод для Стартового веса
              metrics.updateStartWeight(double.tryParse(startWeightCtrl.text.replaceAll(',', '.')) ?? metrics.startWeight);
              
              Navigator.pop(context);
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context, MetricsProvider metrics) {
    final muscleCtrl = TextEditingController(text: metrics.tanitaMuscle.toString());
    final visceralCtrl = TextEditingController(text: metrics.tanitaVisceral.toString());
    final waterCtrl = TextEditingController(text: metrics.tanitaWater.toString());
    final boneCtrl = TextEditingController(text: metrics.tanitaBoneMass.toString());
    final protCtrl = TextEditingController(text: metrics.tanitaProtein.toString());
    final ageCtrl = TextEditingController(text: metrics.tanitaMetabolicAge.toString());

    final bicepsCtrl = TextEditingController(text: metrics.biceps.toString());
    final forearmCtrl = TextEditingController(text: metrics.forearm.toString());
    final thighCtrl = TextEditingController(text: metrics.thigh.toString());
    final calfCtrl = TextEditingController(text: metrics.calf.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: gemSteel,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('MANUAL DATA ENTRY', style: TextStyle(color: gemGold, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            children: [
              const Text("TANITA", style: TextStyle(color: gemEmerald, fontSize: 10, fontWeight: FontWeight.bold)),
              _dialogField("Muscle Mass", muscleCtrl),
              _dialogField("Visceral Fat", visceralCtrl),
              _dialogField("Water %", waterCtrl),
              _dialogField("Bone Mass", boneCtrl),
              _dialogField("Protein %", protCtrl),
              _dialogField("Metabolic Age", ageCtrl),
              const SizedBox(height: 20),
              const Text("EXTRA MEASUREMENTS", style: TextStyle(color: gemGold, fontSize: 10, fontWeight: FontWeight.bold)),
              _dialogField("Biceps", bicepsCtrl),
              _dialogField("Forearm", forearmCtrl),
              _dialogField("Thigh", thighCtrl),
              _dialogField("Calf", calfCtrl),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: gemGold),
            onPressed: () {
              metrics.updateBodyMetrics(
                muscle: double.tryParse(muscleCtrl.text),
                visceral: int.tryParse(visceralCtrl.text),
                bone: double.tryParse(boneCtrl.text),
                metAge: int.tryParse(ageCtrl.text),
                bic: double.tryParse(bicepsCtrl.text),
                forarm: double.tryParse(forearmCtrl.text),
                thgh: double.tryParse(thighCtrl.text),
                clf: double.tryParse(calfCtrl.text),
              );
              Navigator.pop(context);
            },
            child: const Text('SAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController controller, {bool isNumber = true}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: gemSecondaryText, fontSize: 11),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: gemGold)),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
    );
  }

  // --- УПРАВЛЕНИЕ ФОТО ---

  void _showPhotoPickerOptions(BuildContext context, MetricsProvider metrics) {
    showModalBottomSheet(
      context: context,
      backgroundColor: gemSteel,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("PROFILE IMAGE", 
              style: TextStyle(color: gemGold, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            const SizedBox(height: 20),
            
            // ОСТАВЛЯЕМ ТОЛЬКО ЭТОТ ПУНКТ:
            ListTile(
              leading: const Icon(Icons.grid_view, color: gemEmerald),
              title: const Text("Choose from Avatar Library", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _showJpgAvatarPicker(context, metrics); 
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showJpgAvatarPicker(BuildContext context, MetricsProvider metrics) {
    showModalBottomSheet(
      context: context,
      backgroundColor: gemSteel,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              const Text("CHOOSE AVATAR", 
                style: TextStyle(color: gemGold, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: 22,
                  itemBuilder: (context, index) {
                    String name = (index < 11) ? 'man${index + 1}' : 'woman${index - 10}';
                    String path = 'avatars/$name.jpg';
                    return GestureDetector(
                      onTap: () {
                        metrics.updateAvatar(path);
                        Navigator.pop(context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(path, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} // <--- Это самая последняя скобка класса BodyScreen