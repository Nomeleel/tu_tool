import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mixin/form_field_hinter_mixin.dart';
import '../mixin/form_field_validator_mixin.dart';
import 'text_form_field_row.dart';

const textFormFieldRowPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 6);

/// ----------Field----------
abstract class TextField extends StatelessWidget {
  const TextField({super.key, required this.controller});

  final TextEditingController controller;
}

class InitAmount extends TextField with FormFieldValidatorMixin, FormFieldHinterMixin {
  const InitAmount({super.key, required super.controller, required this.additionController});

  final TextEditingController additionController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormFieldRow(
            controller: controller,
            padding: textFormFieldRowPadding.copyWith(right: 0),
            prefix: const FormFieldLabel(label: '初始金额'),
            textFieldPrefix: const AmountPrefix(),
            textFieldSuffix: ValueListenableBuilder(
              valueListenable: additionController,
              builder: (context, value, child) => Text((num.tryParse(value.text) ?? 0) >= 0 ? '追加' : '提取'),
            ),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.always,
            validator: positiveNumberValidator,
            hinter: amountHinter,
            hintBuilder: _amountHinterBuilder,
          ),
        ),
        Expanded(
          child: TextFormFieldRow(
            controller: additionController,
            padding: textFormFieldRowPadding.copyWith(left: 7),
            textFieldPrefix: const AmountPrefix(),
            textFieldSuffix: ValueListenableBuilder(
              valueListenable: additionController,
              builder: (context, value, child) => value.text.isEmpty ? const SizedBox.shrink() : child!,
              child: IconButton(
                padding: EdgeInsets.zero,
                visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                iconSize: 16,
                icon: const Icon(Icons.close_sharp),
                onPressed: additionController.clear,
              ),
            ),
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.always,
            validator: numberValidator,
            hinter: amountHinter,
            hintBuilder: _amountHinterBuilder,
          ),
        ),
      ],
    );
  }

  Widget _amountHinterBuilder(BuildContext context, String hintText) => AmountHinter(hintText: hintText);
}

class AnnualInterestRate extends TextField with FormFieldValidatorMixin {
  const AnnualInterestRate({super.key, required super.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormFieldRow(
      controller: controller,
      padding: textFormFieldRowPadding,
      prefix: const FormFieldLabel(label: '年利率'),
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.always,
      validator: positiveNumberValidator,
      textFieldSuffix: const PercentageSuffix(),
    );
  }
}

class Total extends TextField with FormFieldValidatorMixin {
  const Total({super.key, required super.controller, required this.copyTotal});

  final VoidCallback copyTotal;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldRow(
      controller: controller,
      padding: textFormFieldRowPadding,
      prefix: const FormFieldLabel(label: '本息合计'),
      readOnly: true,
      textFieldPrefix: const AmountPrefix(),
      textFieldSuffix: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, value, child) {
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: value.text.isNotEmpty ? copyTotal : null,
            child: child!,
          );
        },
        child: const Text('复制', style: TextStyle(fontSize: 13)),
      ),
    );
  }
}

/// ----------Widget----------
class FormFieldLabel extends StatelessWidget {
  const FormFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: Text(label),
    );
  }
}

class PercentageSuffix extends StatelessWidget {
  const PercentageSuffix({super.key});

  @override
  Widget build(BuildContext context) => const Text('%');
}

class AmountPrefix extends StatelessWidget {
  const AmountPrefix({super.key});

  @override
  Widget build(BuildContext context) => const Text('¥');
}

class AmountHinter extends StatelessWidget {
  const AmountHinter({super.key, required this.hintText});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 18,
      top: -16,
      child: Container(
        height: 16,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: CupertinoColors.placeholderText,
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: Text(hintText, style: Theme.of(context).textTheme.labelSmall),
      ),
    );
  }
}
