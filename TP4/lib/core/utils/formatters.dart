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

String onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');
