part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthLoading extends AuthState {
  @override
  List<Object> get props => [];
}

final class AuthSuccess extends AuthState {
  const AuthSuccess();

  @override
  List<Object> get props => [];
}

final class AuthError extends AuthState {
  final Exception error;

  const AuthError(this.error);

  @override
  List<Object> get props => [error];
}
