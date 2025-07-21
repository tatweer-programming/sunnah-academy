import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sunnah_academy/src/core/debugging/loggable.dart';
import 'package:sunnah_academy/src/modules/auth/data/models/student_creation_form.dart';
import 'package:sunnah_academy/src/modules/auth/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

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
      (success) => emit(AuthSuccess()),
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
