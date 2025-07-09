class StudentCreationForm {
  final String name;
  final String email;
  final String password;
  final String phoneNumber;
  final String gender;
  final String birthDate;
  const StudentCreationForm(
      {required this.name,
      required this.email,
      required this.password,
      required this.phoneNumber,
      required this.birthDate,
      required this.gender});
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "birthDate": birthDate,
    };
  }
}
