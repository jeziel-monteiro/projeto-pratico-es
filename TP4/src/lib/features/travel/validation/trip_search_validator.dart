class TripSearchValidationResult {
  const TripSearchValidationResult({this.date, this.message});

  final DateTime? date;
  final String? message;

  bool get isValid => message == null;
}

class TripSearchValidator {
  static final _validPlacePattern = RegExp(r"^[\p{L}\s'./-]+$", unicode: true);

  static TripSearchValidationResult validate({
    required String origin,
    required String destination,
    required String date,
  }) {
    final normalizedOrigin = origin.trim();
    final normalizedDestination = destination.trim();
    final normalizedDate = date.trim();

    if (normalizedOrigin.isEmpty ||
        normalizedDestination.isEmpty ||
        normalizedDate.isEmpty) {
      return const TripSearchValidationResult(
        message: 'Preencha todos os campos para buscar viagens.',
      );
    }

    if (!_isValidPlace(normalizedOrigin) ||
        !_isValidPlace(normalizedDestination)) {
      return const TripSearchValidationResult(
        message: 'Dados inválidos para busca. Use apenas nomes de cidades.',
      );
    }

    final parsedDate = parseBrazilianDate(normalizedDate);
    if (parsedDate == null) {
      return const TripSearchValidationResult(
        message: 'Informe uma data válida.',
      );
    }

    return TripSearchValidationResult(date: parsedDate);
  }

  static DateTime? parseBrazilianDate(String value) {
    final parts = value.trim().split('/');
    if (parts.length != 3) return null;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;

    final date = DateTime(year, month, day);
    if (date.day != day || date.month != month || date.year != year) {
      return null;
    }

    return date;
  }

  static bool _isValidPlace(String value) {
    return _validPlacePattern.hasMatch(value);
  }
}
