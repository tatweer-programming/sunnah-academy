import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/core/debugging/loggable.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/auth/data/repositories/auth_repository.dart';

import '../../../core/services/dep_injection.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  static AuthCubit? _cubit;
  static AuthCubit get instance {
    if (_cubit == null || _cubit!.isClosed) {
      _cubit = AuthCubit(sl());
    }
    return _cubit!;
  }

  @override
  Future<void> close() {
    _cubit = null;
    return super.close();
  }

  Future<void> register(StudentCreationForm creationForm) async {
    emit(AuthLoading());
    final result = await _authRepository.register(creationForm);
    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(AuthSuccess()),
    );
  }

  Future<void> login(String email, String password) async {
    logLine("Login process started");
    emit(AuthLoading());
    final result = await _authRepository.login(email, password);
    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(AuthSuccess()),
    );
    logLine("Login process ended");
  }

  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());

    final result = await _authRepository.forgotPassword(email);

    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(ForgotPasswordEmailSent(email)),
    );
  }

  Future<void> verifyCode(String code) async {
    emit(AuthLoading());
    final result = await _authRepository.verifyCode(code);
    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(CodeVerificationSuccess()),
    );
  }

  Future<void> resetPassword(String newPassword) async {
    emit(AuthLoading());
    final result = await _authRepository.resetPassword(newPassword);
    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(PasswordResetSuccess()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await _authRepository.logout();

    result.fold(
      (exception) => emit(AuthError(exception)),
      (success) => emit(AuthInitial()),
    );
  }

  void resetToInitial() {
    emit(AuthInitial());
  }
}
