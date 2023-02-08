import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../mixin/form_field_hinter_mixin.dart';
import '../mixin/form_field_validator_mixin.dart';
import 'text_form_field_row.dart';

class PersonalSavingsCalculator extends StatefulWidget {
  const PersonalSavingsCalculator({super.key, this.label});

  final String? label;

  @override
  State<PersonalSavingsCalculator> createState() => _PersonalSavingsCalculatorState();
}

class _PersonalSavingsCalculatorState extends State<PersonalSavingsCalculator>
    with FormFieldValidatorMixin, FormFieldHinterMixin {
  // Form field controller
  final TextEditingController _initAmountController = TextEditingController();
  final TextEditingController _initAmountAdditionController = TextEditingController();
  final TextEditingController _aprController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () => Form.of(primaryFocus!.context!)?.save(),
      child: CupertinoFormSection.insetGrouped(
        header: widget.label != null ? Text(widget.label!) : null,
        children: [
          ..._buildFormFieldList(),
          _buildCalculatorBtn(),
          _buildTotalRow(),
        ],
      ),
    );
  }

  List<Widget> _buildFormFieldList() {
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextFormFieldRow(
              controller: _initAmountController,
              padding: textFormFieldRowPadding.copyWith(right: 0),
              prefix: _buildFormFieldLabel('初始金额'),
              textFieldPrefix: _buildAmountPrefix(),
              textFieldSuffix: ValueListenableBuilder(
                valueListenable: _initAmountAdditionController,
                builder: (context, value, child) {
                  return Text((num.tryParse(value.text) ?? 0) >= 0 ? '追加' : '提取');
                },
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
              controller: _initAmountAdditionController,
              padding: textFormFieldRowPadding.copyWith(left: 7),
              textFieldPrefix: _buildAmountPrefix(),
              textFieldSuffix: ValueListenableBuilder(
                valueListenable: _initAmountAdditionController,
                builder: (context, value, child) => value.text.isEmpty ? const SizedBox.shrink() : child!,
                child: IconButton(
                  icon: const Icon(Icons.clear_outlined, size: 16),
                  onPressed: _initAmountAdditionController.clear,
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
      ),
      TextFormFieldRow(
        controller: _aprController,
        padding: textFormFieldRowPadding,
        prefix: _buildFormFieldLabel('年利率'),
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.always,
        validator: positiveNumberValidator,
        textFieldSuffix: _buildPercentageSuffix(),
      ),
    ];
  }

  EdgeInsets get textFormFieldRowPadding => const EdgeInsets.symmetric(horizontal: 20, vertical: 6);

  Widget _buildFormFieldLabel(String label) {
    return SizedBox(
      width: 80,
      child: Text(label),
    );
  }

  Widget _buildPercentageSuffix() => const Text('%');

  Widget _buildAmountPrefix() => const Text('¥');

  Widget _amountHinterBuilder(BuildContext context, String hintText) {
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

  Widget _buildCalculatorBtn() {
    return AnimatedBuilder(
      animation: Listenable.merge([_initAmountController, _aprController]),
      builder: (ctx, child) {
        return Center(
          heightFactor: 1.5,
          child: IconButton(
            icon: child!,
            onPressed: _isAllNotEmpty() ? (() => (Form.of(ctx)?.validate() ?? false) ? _calculator() : null) : null,
          ),
        );
      },
      child: const Icon(Icons.calculate),
    );
  }

  Widget _buildTotalRow() {
    return TextFormFieldRow(
      controller: _totalController,
      padding: textFormFieldRowPadding,
      prefix: _buildFormFieldLabel('本息合计'),
      readOnly: true,
      textFieldPrefix: _buildAmountPrefix(),
      textFieldSuffix: ValueListenableBuilder(
        valueListenable: _totalController,
        builder: (context, value, child) {
          return CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: value.text.isNotEmpty ? _copyTotal : null,
            child: child!,
          );
        },
        child: const Text('复制'),
      ),
    );
  }

  @override
  void dispose() {
    _initAmountController.dispose();
    _initAmountAdditionController.dispose();
    _aprController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  bool _isAllNotEmpty() => [_initAmountController, _aprController].every(((e) => e.text.isNotEmpty));

  void _calculator() => _totalController.text =
      ((num.tryParse(_initAmountController.text)! + (num.tryParse(_initAmountAdditionController.text) ?? 0)) *
              (1 + num.tryParse(_aprController.text)! / 100))
          .toString();

  void _copyTotal() => Clipboard.setData(ClipboardData(text: _totalController.text));
}
