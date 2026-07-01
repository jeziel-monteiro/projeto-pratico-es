class TravelerProfile {
  const TravelerProfile({
    required this.id,
    required this.firebaseUid,
    required this.fullName,
    required this.email,
    required this.cpf,
    this.birthDate,
    this.phone,
    required this.highContrast,
  });

  factory TravelerProfile.fromJson(Map<String, Object?> json) {
    final travelerProfile = json['travelerProfile'] as Map<String, Object?>?;

    return TravelerProfile(
      id: json['id'] as String,
      firebaseUid: json['firebaseUid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      birthDate: json['birthDate'] as String?,
      phone: json['phone'] as String?,
      highContrast: travelerProfile?['highContrast'] as bool? ?? false,
    );
  }

  final String id;
  final String firebaseUid;
  final String fullName;
  final String email;
  final String cpf;
  final String? birthDate;
  final String? phone;
  final bool highContrast;
}
