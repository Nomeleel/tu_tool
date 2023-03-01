import 'package:flutter/material.dart';

import '/personal_savings_calculator/personal_savings_calculator_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tu Tool',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.purple,
      ),
      home: const PersonalSavingsCalculatorPage(),
    );
  }
}
