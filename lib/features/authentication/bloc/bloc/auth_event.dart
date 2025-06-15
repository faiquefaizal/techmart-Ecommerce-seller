part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class LoginAuth extends AuthEvent {
  final String email;
  final String password;
  LoginAuth(this.email, this.password);
}

final class SignUpAuth extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String businessname;
  final String phonenumber;
  SignUpAuth(
    this.email,
    this.password,
    this.name,
    this.businessname,
    this.phonenumber,
  );
}

class CheckVerificationStatus extends AuthEvent {
  final String userId;
  CheckVerificationStatus(this.userId);
}
