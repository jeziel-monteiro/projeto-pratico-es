String formatCpf(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length && i < 11; i++) {
    if (i == 3 || i == 6) buffer.write('.');
    if (i == 9) buffer.write('-');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String formatBrazilianDate(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length && i < 8; i++) {
    if (i == 2 || i == 4) buffer.write('/');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

String formatPhone(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  final limitedDigits = digits.length > 11 ? digits.substring(0, 11) : digits;
  final buffer = StringBuffer();

  for (var i = 0; i < limitedDigits.length; i++) {
    if (i == 0) buffer.write('(');
    if (i == 2) buffer.write(') ');
    if (limitedDigits.length <= 10 && i == 6) buffer.write('-');
    if (limitedDigits.length > 10 && i == 7) buffer.write('-');
    buffer.write(limitedDigits[i]);
  }

  return buffer.toString();
}

String onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');
