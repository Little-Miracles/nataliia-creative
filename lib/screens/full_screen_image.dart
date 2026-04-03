import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagePath; // Путь к картинке (например, 'assets/images/salad.jpg')

  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Фон всегда черный, чтобы фото выделялось
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Кнопка закрытия в виде крестика
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        // Используем InteractiveViewer, чтобы пользователь мог увеличивать пальцами
        child: InteractiveViewer(
          panEnabled: true, // Разрешить перетаскивание
          minScale: 0.5,
          maxScale: 4.0, // Разрешить сильное увеличение
          child: Hero(
            tag: imagePath, // 🔥 Магия плавной анимации
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain, // Показать картинку целиком
            ),
          ),
        ),
      ),
    );
  }
}