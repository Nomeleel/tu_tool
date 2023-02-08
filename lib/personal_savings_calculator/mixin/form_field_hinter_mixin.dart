mixin FormFieldHinterMixin {
  String? amountHinter(String? value) {
    if ((value?.isNotEmpty ?? false)) {
      int amountLength = num.tryParse(value!)?.abs().toInt().toString().length ?? 0;
      if (amountLength > 0 && amountLength < 10) {
        return amountLowUnitMap[(amountLength - 1) % 4 + 1]! + amountHightUnitMap[(amountLength / 4).ceil()]!;
      }
    }
    return null;
  }
}

const amountHightUnitMap = {
  1: '',
  2: '万',
  3: '亿',
  4: '兆',
};

const amountLowUnitMap = {
  1: '',
  2: '十',
  3: '百',
  4: '千',
};
