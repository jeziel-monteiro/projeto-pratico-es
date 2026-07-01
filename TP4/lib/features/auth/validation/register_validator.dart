class RegisterFormInput {
  const RegisterFormInput({
    required this.fullName,
    required this.cpf,
    required this.birthDate,
    required this.email,
    this.phone = '',
    required this.password,
    required this.confirmPassword,
  });

  final String fullName;
  final String cpf;
  final String birthDate;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
}

class RegisterValidationResult {
  const RegisterValidationResult(this.errors);

  final Map<String, String> errors;

  bool get isValid => errors.isEmpty;
}

class RegisterValidator {
  static const minimumAge = 18;
  static final _validFullNamePattern = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s'.-]+$");
  static final _validEmailPattern = RegExp(
    r"^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)+$",
  );

  static RegisterValidationResult validate(
    RegisterFormInput input, {
    DateTime? now,
  }) {
    final errors = <String, String>{};
    final normalizedName = input.fullName.trim();
    final birthDate = parseBrazilianDate(input.birthDate);

    if (normalizedName.isEmpty) {
      errors['name'] = 'Nome completo obrigatório.';
    } else if (!_validFullNamePattern.hasMatch(normalizedName)) {
      errors['name'] = 'Use apenas letras e separadores comuns no nome.';
    } else if (normalizedName.split(RegExp(r'\s+')).length < 2) {
      errors['name'] = 'Informe nome e sobrenome.';
    }

    if (input.cpf.replaceAll(RegExp(r'\D'), '').length != 11) {
      errors['cpf'] = 'CPF inválido.';
    }

    if (input.birthDate.trim().isEmpty) {
      errors['birthDate'] = 'Data de nascimento obrigatória.';
    } else if (birthDate == null) {
      errors['birthDate'] = 'Data de nascimento inválida. Use DD/MM/AAAA.';
    } else if (!isAtLeastMinimumAge(birthDate, now: now)) {
      errors['birthDate'] =
          'Restrição de idade: você precisa ter 18 anos ou mais.';
    }

    if (!_isValidEmail(input.email.trim())) {
      errors['email'] = 'Email inválido.';
    }

    final phoneDigits = input.phone.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.isNotEmpty &&
        (phoneDigits.length < 10 || phoneDigits.length > 11)) {
      errors['phone'] = 'Telefone inválido.';
    }

    if (input.password.length < 8) {
      errors['password'] = 'Senha deve ter no mínimo 8 caracteres.';
    } else if (!_hasRequiredPasswordStrength(input.password)) {
      errors['password'] =
          'Senha deve conter maiúscula, minúscula, número e símbolo.';
    }

    if (input.password != input.confirmPassword) {
      errors['confirm'] = 'As senhas não coincidem.';
    }

    return RegisterValidationResult(errors);
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

  static bool isAtLeastMinimumAge(DateTime birthDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    var age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age >= minimumAge;
  }

  static String toApiDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static bool _isValidEmail(String value) {
    return _validEmailPattern.hasMatch(value);
  }

  static bool _hasRequiredPasswordStrength(String value) {
    return RegExp(r'(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])').hasMatch(value);
  }
}
