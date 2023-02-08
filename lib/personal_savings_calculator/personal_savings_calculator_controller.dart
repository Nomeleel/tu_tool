import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PersonalSavingsCalculatorController {
  final TextEditingController initAmount = TextEditingController();
  final TextEditingController initAmountAddition = TextEditingController();
  final TextEditingController air = TextEditingController();
  final TextEditingController total = TextEditingController();

  bool isAllNotEmpty() => [initAmount, air].every(((e) => e.text.isNotEmpty));

  void copyTotal() => Clipboard.setData(ClipboardData(text: total.text));

  void calculator() =>
      total.text = ((initAmount.number! + (initAmountAddition.number ?? 0)) * (1 + air.number! / 100)).toString();

  void dispose() {
    initAmount.dispose();
    initAmountAddition.dispose();
    air.dispose();
    total.dispose();
  }
}

extension on TextEditingController {
  num? get number => num.tryParse(text);
}
