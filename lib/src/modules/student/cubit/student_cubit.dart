import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/student/data/repositories/account_repository.dart';

import '../data/models/student.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _repository;

  StudentCubit(this._repository) : super(StudentInitial());

  void getProfile() async {
    emit(GetProfileLoading());
    var result = await _repository.getProfile();
    result.fold((exception) => emit(StudentError(exception)),
        (student) => emit(GetProfileSuccess(student)));
  }

  void updateProfile(
      {String? name,
      String? phoneNumber,
      String? gender,
      String? birthDate}) async {
    emit(UpdateProfileLoading());
    var result = await _repository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        gender: gender,
        birthDate: birthDate);
    result.fold((exception) => emit(StudentError(exception)),
        (student) => emit(UpdateProfileSuccess(student)));
  }

  void deleteAccount() async {
    emit(DeleteProfileLoading());
    var result = await _repository.deleteAccount();
    result.fold((exception) => emit(StudentError(exception)),
        (student) => emit(DeleteProfileSuccess()));
  }
}
