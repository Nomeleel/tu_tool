mixin FormFieldValidatorMixin {
  String? numberValidator(String? value) {
    if ((value?.isNotEmpty ?? false) && num.tryParse(value!) == null) {
      return '请输入正确的数值';
    }
    return null;
  }
}
