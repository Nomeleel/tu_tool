import 'package:flutter/widgets.dart';

mixin FormFieldValidatorMixin {
  String? numberValidator(String? value) {
    if ((value?.isNotEmpty ?? false) && num.tryParse(value!) == null) {
      return '请输入正确的数值';
    }
    return null;
  }

  String? positiveValidator(String? value) {
    return (value?.startsWith('-') ?? false) ? '请输入正值' : null;
  }

  String? positiveNumberValidator(String? value) => combineValidator([numberValidator, positiveValidator])(value);

  FormFieldValidator<String> combineValidator(List<FormFieldValidator<String>> validatorList) {
    return (String? value) {
      for (final validator in validatorList) {
        final validation = validator(value);
        if (validation != null) return validation;
      }
      return null;
    };
  }
}
