import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart'; // Import Login Screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginScreen(), // Set to LoginScreen
    );
  }
}
