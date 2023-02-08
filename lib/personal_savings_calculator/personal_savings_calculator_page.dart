import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'widget/personal_savings_calculator.dart';

class PersonalSavingsCalculatorPage extends StatefulWidget {
  const PersonalSavingsCalculatorPage({super.key});

  @override
  State<PersonalSavingsCalculatorPage> createState() => _PersonalSavingsCalculatorPageState();
}

class _PersonalSavingsCalculatorPageState extends State<PersonalSavingsCalculatorPage> {
  int _itemCount = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('个人存款计算器'),
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20, bottom: MediaQuery.of(context).padding.bottom + 20),
        itemCount: _itemCount,
        itemBuilder: (context, index) {
          return PersonalSavingsCalculator(
            key: ValueKey(index),
            label: 'NO.${index + 1}',
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => _itemCount++),
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
