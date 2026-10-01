import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Banking App',

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F9FF),
        fontFamily: 'Inter',
      ),

      home: const HomeScreen(),
    );
  }
}
