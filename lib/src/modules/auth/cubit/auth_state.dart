part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final Exception exception;

  const AuthError(this.exception);

  @override
  List<Object> get props => [exception];
}

// States خاصة بعملية نسيان كلمة المرور
class ForgotPasswordEmailSent extends AuthState {
  final String email;

  const ForgotPasswordEmailSent(this.email);

  @override
  List<Object> get props => [email];
}

class CodeVerificationSuccess extends AuthState {}

class PasswordResetSuccess extends AuthState {}
