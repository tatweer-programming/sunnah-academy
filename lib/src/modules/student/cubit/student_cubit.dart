import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/modules/student/data/repositories/account_repository.dart';

import '../../../core/debugging/loggable.dart';
import '../../../core/services/dep_injection.dart';
import '../data/models/student.dart';

part 'student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  final StudentRepository _repository;

  StudentCubit(this._repository) : super(StudentInitial());

  static StudentCubit? _cubit;

  static StudentCubit get instance {
    _cubit ??= StudentCubit(sl());
    return _cubit!;
  }

  static void resetInstance() {
    _cubit?.close();
    _cubit = null;
  }

  @override
  Future<void> close() async {
    logInfo("StudentCubit is being closed");
    return super.close();
  }

  Future<void> getProfile() async {
    try {
      logLine("Get profile process started");
      emit(GetProfileLoading());

      final result = await _repository.getProfile();

      if (isClosed) return;

      result.fold(
        (exception) {
          if (!isClosed) {
            emit(StudentError(exception));
            logError("Get profile error: ${exception.toString()}");
          }
        },
        (student) {
          if (!isClosed) {
            emit(GetProfileSuccess(student));
            logInfo("Get profile success: ${student.toString()}");
          }
        },
      );

      logLine("Get profile process ended");
    } catch (e) {
      if (!isClosed) {
        logError("Unexpected error in getProfile: $e");
        // Handle unexpected errors gracefully
        emit(StudentError(Exception("حدث خطأ غير متوقع")));
      }
    }
  }

  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? email,
    String? birthDate,
  }) async {
    try {
      logLine("Update profile process started");
      emit(UpdateProfileLoading());

      final result = await _repository.updateProfile(
        name: name,
        phoneNumber: phoneNumber,
        email: email,
        birthDate: birthDate,
      );

      if (isClosed) return;

      result.fold(
        (exception) {
          if (!isClosed) {
            emit(StudentError(exception));
            logError("Update profile error: ${exception.toString()}");
          }
        },
        (student) {
          if (!isClosed) {
            emit(UpdateProfileSuccess(student));
            logInfo("Update profile success: ${student.toString()}");
          }
        },
      );

      logLine("Update profile process ended");
    } catch (e) {
      if (!isClosed) {
        logError("Unexpected error in updateProfile: $e");
        emit(StudentError(Exception("حدث خطأ غير متوقع أثناء تحديث البيانات")));
      }
    }
  }

  Future<void> deleteAccount() async {
    try {
      logLine("Delete account process started");
      emit(DeleteProfileLoading());

      final result = await _repository.deleteAccount();

      if (isClosed) return;

      result.fold(
        (exception) {
          if (!isClosed) {
            emit(StudentError(exception));
            logError("Delete account error: ${exception.toString()}");
          }
        },
        (_) {
          if (!isClosed) {
            emit(DeleteProfileSuccess());
            logInfo("Delete account success");
          }
        },
      );

      logLine("Delete account process ended");
    } catch (e) {
      if (!isClosed) {
        logError("Unexpected error in deleteAccount: $e");
        emit(StudentError(Exception("حدث خطأ غير متوقع أثناء حذف الحساب")));
      }
    }
  }

  void refreshProfile() {
    getProfile();
  }

  void resetToInitial() {
    if (!isClosed) {
      emit(StudentInitial());
    }
  }
}
