import 'package:flutter/material.dart';

class MeasurementsScreen extends StatelessWidget {
  const MeasurementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        title: const Text('MY PARAMETERS', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(label: 'Name', hint: 'Enter name', icon: Icons.person_outline),
              const SizedBox(height: 20),
              _buildInputField(label: 'Height (cm)', hint: '170', icon: Icons.height),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildInputField(label: 'Weight (kg)', hint: '65.0', icon: Icons.monitor_weight)),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)), child: const Icon(Icons.arrow_forward, color: Colors.black)),
              ]),
              const SizedBox(height: 30),
              const Text('TANITA DATA', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _buildInputField(label: 'Fat %', hint: '22%', icon: Icons.opacity)),
                const SizedBox(width: 10),
                Expanded(child: _buildInputField(label: 'Water %', hint: '50%', icon: Icons.water_drop)),
              ]),
              const SizedBox(height: 40),
              SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4AF37)), child: const Text('SAVE DATA', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required String hint, required IconData icon}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      const SizedBox(height: 5),
      TextField(style: const TextStyle(color: Colors.white), decoration: InputDecoration(prefixIcon: Icon(icon, color: const Color(0xFFD4AF37)), hintText: hint, hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)), filled: true, fillColor: const Color(0xFF1E1E1E), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none))),
    ]);
  }
}