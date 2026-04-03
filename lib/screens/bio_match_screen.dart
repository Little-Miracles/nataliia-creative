import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_body_life/screens/bio_scanner_screen.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class BioMatchScreen extends StatefulWidget {
  final String mealName; 
  final File? imageFile; 

  const BioMatchScreen({
    super.key, 
    required this.mealName, 
    this.imageFile
  });

  @override
  State<BioMatchScreen> createState() => _BioMatchScreenState();
}

class _BioMatchScreenState extends State<BioMatchScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('videos/culinary_lab.mov')
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color accent = Color(0xFF7E4AAF);
    const Color gold = Color(0xFFC0A060);

    return Scaffold(
      backgroundColor: const Color(0xFF05100A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFEDE6D6), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CULINARY LAB', 
          style: TextStyle(color: accent, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: gold.withOpacity(0.5), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack( 
                  alignment: Alignment.center,
                  children: [
                    if (_isInitialized)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                          });
                        },
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    else
                      const CircularProgressIndicator(color: Color(0xFFC0A060)),
                    
                    if (_isInitialized && !_controller.value.isPlaying)
                      IconButton(
                        icon: Icon(Icons.play_circle_fill, color: gold.withOpacity(0.8), size: 60),
                        onPressed: () {
                          setState(() {
                            _controller.play();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),
            
            const Text(
              "CREATE YOUR SIGNATURE DISH",
              style: TextStyle(color: gold, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              "Every great recipe starts with a photo. Capture your culinary masterpiece or upload it from your gallery. \n\nAnalyze nutrients with AI or build your dish manually. Save it to your library and share your results!",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
            ),

            const SizedBox(height: 35),

            Row(
              children: [
                _buildActionCard(context, Icons.camera_enhance_outlined, "TAKE PHOTO", accent, () {
                  // Передаем mealName ('BIO-SCAN') в сканер
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BioScannerScreen(mealName: widget.mealName)));
                }),
                const SizedBox(width: 15),
                // ИСПРАВЛЕНО: Убрал старый комментарий
                _buildActionCard(context, Icons.photo_library_outlined, "GALLERY", const Color(0xFF1E0433), () {
                  _pickFromGallery(context); 
                }),
              ],
            ),
            const SizedBox(height: 25), 
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, 
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.4)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 35),
              const SizedBox(height: 10),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  // ФУНКЦИЯ ДЛЯ ВЫБОРА ИЗ ГАЛЕРЕИ
  Future<void> _pickFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (!context.mounted) return;
      // ПЕРЕХОДИМ В СКАНЕР И ПЕРЕДАЕМ ФАЙЛ + mealName
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => BioScannerScreen(
            imageFile: File(image.path),
            mealName: widget.mealName,
          )
        )
      );
    }
  }
}