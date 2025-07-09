class StudentCreationForm {
  String name;
  String email;
  String password;
  String phoneNumber;
  final String gender;
  String birthDate;
  StudentCreationForm(
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
