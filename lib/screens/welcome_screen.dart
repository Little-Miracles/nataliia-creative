import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

// Функция для открытия юридических документов
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000), // Черный
              Color(0xFF001A10), // Изумрудный низ
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),

              // --- ЦЕНТР: ЧИСТЫЙ МАГИЧЕСКИЙ КРУГ ---
              Container(
                height: 320, 
                width: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black, // Фон под картинкой
                  border: Border.all(
                    color: const Color(0xFFD4AF37), // Золотая рамка
                    width: 2, // Тонкая и изящная
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x6610B981), // Изумрудное свечение
                      blurRadius: 60, 
                      spreadRadius: 10,
                    ),
                  ],
                  // ВАЖНО: Мы убрали Padding. Картинка теперь часть круга.
                  image: const DecorationImage(
                    image: AssetImage('ui_images/tree.png'),
                    // contain = Вписать картинку целиком, не обрезая буквы
                    fit: BoxFit.contain, 
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // --- НИЗ: ТЕКСТ И КНОПКА ---
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 30.0),
  child: Column(
    children: [
      const Text(
        'YOUR PERSONAL BIO-SYSTEM', // Перевели в ВЕРХНИЙ РЕГИСТР для солидности
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,             // Уменьшили размер для иерархии
          fontWeight: FontWeight.w300, // Тонкое, изящное начертание
          color: Color(0xFFD4AF37),  // Ваше благородное золото
          letterSpacing: 5.0,        // Максимальный «воздух» между буквами
          // fontFamily: 'Courier' — УБРАЛИ, чтобы использовать чистый современный шрифт
        ),
      ),
      
      const SizedBox(height: 40), // Дистанция до кнопки

                    // КНОПКА "ИЗУМРУДНЫЙ МОНОЛИТ" (Радиус 3, Черный текст)
Container(
  width: double.infinity,
  height: 60,
  decoration: BoxDecoration(
    // Радиус 3 — для строгого, профессионального вида
    borderRadius: BorderRadius.circular(3), 
    boxShadow: [
      BoxShadow(
        // Мягкое свечение в тон изумрудному низу экрана
        color: const Color(0xFF001A10).withOpacity(0.5), 
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  ),
  child: ElevatedButton(
    onPressed: () {
      // ЛОГИКА ПЕРЕХОДА (Осталась неизменной)
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );*/
      // ЛОГИКА ПЕРЕХОДА (ТЕПЕРЬ В ХАБ)
Navigator.pushReplacementNamed(context, '/hub');
    },
    style: ElevatedButton.styleFrom(
      // ФОН: Глубокий изумрудный (чуть ярче дна, чтобы кнопка была видна)
      backgroundColor: const Color(0xFF003D26), 
      // ЦВЕТ ТЕКСТА И ИКОНКИ: Теперь черный
      foregroundColor: Colors.black, 
      
      // ГЕОМЕТРИЯ: Строгий прямоугольник со скруглением 3
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3), 
      ),
      
      // ОКАНТОВКА: Тонкое золото (0.8), теперь оно не будет казаться "рамкой"
      side: const BorderSide(color: Color(0xFFD4AF37), width: 0.8),
      
      elevation: 0, // Тень мы настроили через Container выше
    ),
    child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      'START JOURNEY', 
      style: TextStyle(
        fontSize: 16, 
        fontWeight: FontWeight.w900, 
        color: Colors.black, // Сами буквы черные
        letterSpacing: 2.5,
        // --- ВОТ ОНО, ВАШЕ "СВЕЧЕНИЕ" ---
        shadows: [
          Shadow(
            color: const Color(0xFF757575).withOpacity(0.8), // Ваш серый
            offset: const Offset(0.5, 0.5), // Крошечное смещение для объема
            blurRadius: 3.0, // Размытие, чтобы создать эффект ореола
          ),
        ],
      ),
    ),
    const SizedBox(width: 12),
    // Добавляем такую же тень иконке-стрелочке
    Icon(
      Icons.arrow_forward_ios, 
      size: 14, 
      color: Colors.black,
      shadows: [
        Shadow(
          color: const Color(0xFF757575).withOpacity(0.8),
          offset: const Offset(0.5, 0.5),
          blurRadius: 3.0,
        ),
      ],
    ), 
  ],
),  ),
),
const SizedBox(height: 25), // Отступ от кнопки вниз
                    
  // ЮРИДИЧЕСКИЙ БЛОК (3 документа)
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => _launchURL("https://docs.google.com/document/d/1UpywYt9ir7gwUdrHVNyZvusF8WIawe4_sT2XyeL8Jjs/edit?usp=sharing"),
                          child: Text(
                            "PRIVACY POLICY",
                            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 1.0),
                          ),
                        ),
                        Text("  |  ", style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9)),
                        GestureDetector(
                          onTap: () => _launchURL("https://docs.google.com/document/d/19bF_TbqJheMKHpsu0jRHWB18zAJOdnHFN-kSVFrXsHc/edit?usp=sharing"),
                          child: Text(
                            "EULA",
                            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 1.0),
                          ),
                        ),
                        Text("  |  ", style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9)),
                        GestureDetector(
                          onTap: () => _launchURL("https://docs.google.com/document/d/13SpfXwEeclOg03Am-zhLI30-Jd8h9Y4_Rh_dqURuySM/edit?usp=sharing"),
                          child: Text(
                            "DISCLAIMER",
                            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 9, letterSpacing: 1.0),
                          ),
                        ),
                      ],
                    ),          
                    // --- НАША НОВАЯ ФИНАЛЬНАЯ СТРОЧКА ---
                    const SizedBox(height: 15), // Небольшой зазор между ссылками и копирайтом
                    Text(
                      "© 2026 Smart Body Life. All rights reserved.",
                      style: TextStyle(
                        color: Colors.white.withAlpha(80),
                        fontSize: 9,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // УМЕНЬШАЕМ нижний отступ с 40 до 20, чтобы на SE всё влезло!
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
    );
  }
}