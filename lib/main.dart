import 'package:flutter/material.dart';
import 'package:painter_app/core/theme/app_theme.dart';
import 'package:painter_app/feature/drawing_room/presentation/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen() ,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      // initialRoute: AppRouteName.drawingRoom,
      // onGenerateRoute: (settings) => ,
      darkTheme: AppTheme.dark,
      title: 'Flutter Demo',
      theme: AppTheme.light
    );
  }
}
