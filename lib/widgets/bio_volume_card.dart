import 'package:flutter/material.dart';

class BioVolumeCard extends StatelessWidget {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;

  const BioVolumeCard({
    super.key, 
    required this.title, 
    required this.subTitle, 
    required this.icon, 
    required this.accentColor,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130, 
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFF001A10), Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: accentColor.withOpacity(0.4), width: 1),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: accentColor, size: 30),
              const SizedBox(height: 12),
              Text(title.toUpperCase(), 
                textAlign: TextAlign.center,
                style: TextStyle(color: accentColor, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.5)),
              const SizedBox(height: 4),
              Text(subTitle, 
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 8)),
            ],
          ),
        ),
      ),
    );
  }
}