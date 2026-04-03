import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BioScannerButton extends StatelessWidget {
  final VoidCallback onTap;

  const BioScannerButton({super.key, required this.onTap});

  // --- НАША ПАЛИТРА СТАРОГО ЗОЛОТА ---
  static const Color antiqueGold = Color(0xFFD4AF37);
  static const Color deepEmerald = Color(0xFF001A10);
  static const Color scannerGreen = Color(0xFF003D26);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.heavyImpact(); // Мощный отклик при нажатии
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          // Глубокий градиент как на кнопке Start
          gradient: const LinearGradient(
            colors: [deepEmerald, Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(5), // Строгий радиус
          border: Border.all(color: antiqueGold.withOpacity(0.5), width: 1),
          boxShadow: [
            BoxShadow(
              color: antiqueGold.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Декоративные уголки сканера
            Positioned(top: 5, left: 5, child: _scannerCorner(0)),
            Positioned(top: 5, right: 5, child: _scannerCorner(1)),
            Positioned(bottom: 5, left: 5, child: _scannerCorner(3)),
            Positioned(bottom: 5, right: 5, child: _scannerCorner(2)),
            
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.qr_code_scanner, color: antiqueGold, size: 28),
                  const SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BIO-DATA SCANNER",
                        style: TextStyle(
                          color: antiqueGold,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "INITIATE MOLECULAR ANALYSIS",
                        style: TextStyle(
                          color: antiqueGold.withOpacity(0.6),
                          fontSize: 8,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Рисуем маленькие уголки сканера
  Widget _scannerCorner(int quarter) {
    return RotatedBox(
      quarterTurns: quarter,
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: antiqueGold, width: 2),
            left: BorderSide(color: antiqueGold, width: 2),
          ),
        ),
      ),
    );
  }
}