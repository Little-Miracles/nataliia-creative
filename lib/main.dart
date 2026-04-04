import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:smart_body_life/providers/custom_workout_provider.dart';
import 'package:smart_body_life/providers/evolution_manager.dart';
import 'package:smart_body_life/providers/workout_library_provider.dart';
import 'package:smart_body_life/providers/metrics_provider.dart';
import 'package:smart_body_life/providers/workout_tracker_provider.dart'; 
import 'package:smart_body_life/providers/workout_provider.dart';
import 'package:smart_body_life/providers/active_session_provider.dart';
import 'package:smart_body_life/screens/main_hub_screen.dart';
import 'package:smart_body_life/screens/welcome_screen.dart';
import 'package:smart_body_life/screens/body_screen.dart';        
import 'package:smart_body_life/screens/food_screen.dart';
import 'package:smart_body_life/screens/gym_screen.dart'; 
import 'package:smart_body_life/screens/settings_screen.dart';
import 'package:smart_body_life/screens/progress_screen.dart';
import 'package:smart_body_life/screens/workout_unified_hub.dart';
import 'package:smart_body_life/utils/storage_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init(); 
  tz.initializeTimeZones();
  
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    defaultPresentAlert: true,
    defaultPresentBadge: true,
    defaultPresentSound: true,
  );
  
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings, // <--- Просто название, без слова settings:
    onDidReceiveNotificationResponse: (NotificationResponse details) {
      if (details.payload == 'artifact_unlocked') {
        navigatorKey.currentState?.pushNamed('/body');
      }
    },
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutLibraryProvider()),
        ChangeNotifierProvider(create: (_) => MetricsProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutTrackerProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => ActiveSessionProvider()),
        ChangeNotifierProvider(create: (_) => CustomWorkoutProvider()),
        ChangeNotifierProvider(create: (_) => EvolutionProvider()),
      ],
      child: const SmartBodyLifeApp(),
    ),
  );
}

class SmartBodyLifeApp extends StatelessWidget {
  const SmartBodyLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Body Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF05100A),
      ),
      initialRoute: '/hub', 
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/hub': (context) => const MainHubScreen(),
        '/body': (context) => const MainScreen(initialIndex: 1),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/workout_hub') {
          final String id = (settings.arguments is String) ? settings.arguments as String : "0";
          return MaterialPageRoute(builder: (context) => WorkoutUnifiedHub(templateId: id));
        }
        return null;
      },
    );
  }
}

// Вспомогательная функция для уведомлений (вызывается из провайдера)
Future<void> showArtifactNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'artifact_channel',
    'Artifact Awards',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    id: DateTime.now().millisecond, 
    title: title, 
    body: body, 
    notificationDetails: platformDetails,
    payload: 'artifact_unlocked', 
  );
}

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const ProgressScreen(),
    const BodyScreen(),
    const FoodScreen(),
    const GymScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFFD4AF37),
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF001100),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.accessibility_new), label: 'BODY'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'FOOD'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'GYM'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'SET'),
        ],
      ),
    );
  }
}
