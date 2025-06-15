part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthenticatedState extends AuthState {
  final String userId;
  AuthenticatedState(this.userId);
}

final class UnAuthenticatedState extends AuthState {}

final class NotVerifiedState extends AuthState {}

final class ErrorState extends AuthState {
  final String error;
  ErrorState(this.error);
}
