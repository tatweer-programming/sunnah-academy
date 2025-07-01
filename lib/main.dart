import 'package:flutter/material.dart';
import 'package:sunnah_academy/src/core/utils/theme_manager.dart';
import 'package:sunnah_academy/test_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Theme Test App',
      theme: AppTheme.lightTheme,
      home: MainTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
