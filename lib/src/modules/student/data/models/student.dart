class Student {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  final int currentLevel;

  const Student(
      {required this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.gender,
      required this.birthDate,
      required this.currentLevel});
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      birthDate: json['birthDate'],
      currentLevel: json['currentLevel'],
      id: json['id'],
    );
  }
  Student copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? gender,
    String? birthDate,
    int? currentLevel,
  }) {
    return Student(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      currentLevel: currentLevel ?? this.currentLevel,
    );
  }
}
