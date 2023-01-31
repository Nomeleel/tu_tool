import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mixin/form_field_hinter_mixin.dart';
import '../mixin/form_field_validator_mixin.dart';
import 'text_form_field_row.dart';

class PersonalSavingsCalculator extends StatelessWidget with FormFieldValidatorMixin, FormFieldHinterMixin {
  const PersonalSavingsCalculator({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: () {
        // Form.of(primaryFocus!.context!)?.save();
      },
      child: CupertinoFormSection.insetGrouped(
        header: label != null ? Text(label!) : null,
        children: [
          ..._buildFormFieldList(),
          Builder(
            builder: (ctx) => Center(
              heightFactor: 1.5,
              child: IconButton(
                icon: const Icon(Icons.calculate),
                onPressed: () {
                  if (Form.of(ctx)?.validate() ?? false) {
                    print('calculate');
                  }
                },
              ),
            ),
          ),
          TextFormFieldRow(
            padding: textFormFieldRowPadding,
            prefix: _buildFormFieldLabel('本息合计'),
            readOnly: true,
            initialValue: '123',
            textFieldPrefix: _buildAmountPrefix(),
            textFieldSuffix: CupertinoButton(padding: EdgeInsets.zero, child: const Text('复制'), onPressed: () {}),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormFieldList() {
    return [
      TextFormFieldRow(
        padding: textFormFieldRowPadding,
        prefix: _buildFormFieldLabel('初始金额'),
        textFieldPrefix: _buildAmountPrefix(),
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.always,
        validator: numberValidator,
        hinter: amountHinter,
        hintBuilder: _amountHinterBuilder,
      ),
      TextFormFieldRow(
        padding: textFormFieldRowPadding,
        prefix: _buildFormFieldLabel('年利率'),
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.always,
        validator: numberValidator,
        textFieldSuffix: _buildPercentageSuffix(),
      ),
    ];
  }

  EdgeInsetsGeometry get textFormFieldRowPadding => const EdgeInsets.symmetric(horizontal: 20, vertical: 6);

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
      left: 10,
      top: -20,
      child: Container(
        width: 50,
        height: 20,
        color: CupertinoColors.placeholderText,
        alignment: Alignment.center,
        child: Text(hintText),
      ),
    );
  }
}
