part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({required this.email, required this.password});
}

final class SignUpEvent extends AuthEvent {
  final String name;
  final String lastname;
  final String? photoUrl;
  final String email;
  final String password;

  const SignUpEvent(
      {required this.name,
      required this.lastname,
      this.photoUrl,
      required this.email,
      required this.password});
}

final class SignOutEvent extends AuthEvent {}

final class CheckUserIsLoggedEvent extends AuthEvent {}
