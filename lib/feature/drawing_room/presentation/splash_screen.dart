
import 'package:flutter/material.dart';
import 'package:painter_app/feature/drawing_room/presentation/drawing_room_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoOpacity = 0.4;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        logoOpacity = 1.0;
      });

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DrawingRoomScreen()),
          (route) => false,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: logoOpacity,
          duration: const Duration(seconds: 1), // Change this duration
          child: const SizedBox(
            width: 200,
            height: 200,
            child: Image(image: AssetImage("assets/app_icon.webp")),
          ),
        ),
      ),
    );
  }
}
