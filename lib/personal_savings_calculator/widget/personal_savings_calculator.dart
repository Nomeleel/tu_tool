import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../personal_savings_calculator_controller.dart';
import '../widget/personal_savings_calculator_fields.dart';

class PersonalSavingsCalculator extends StatefulWidget {
  const PersonalSavingsCalculator({super.key, this.label});

  final String? label;

  @override
  State<PersonalSavingsCalculator> createState() => _PersonalSavingsCalculatorState();
}

class _PersonalSavingsCalculatorState extends State<PersonalSavingsCalculator> {
  final PersonalSavingsCalculatorController _controller = PersonalSavingsCalculatorController();

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
          Total(controller: _controller.total, copyTotal: _controller.copyTotal),
        ],
      ),
    );
  }

  List<Widget> _buildFormFieldList() {
    return [
      InitAmount(controller: _controller.initAmount, additionController: _controller.initAmountAddition),
      AnnualInterestRate(controller: _controller.air),
    ];
  }

  Widget _buildCalculatorBtn() {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller.initAmount, _controller.air]),
      builder: (ctx, child) {
        return Center(
          heightFactor: 1.5,
          child: IconButton(
            icon: child!,
            onPressed: _controller.isAllNotEmpty()
                ? (() => (Form.of(ctx)?.validate() ?? false) ? _controller.calculator() : null)
                : null,
          ),
        );
      },
      child: const Icon(Icons.calculate),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
