part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState({this.userCurrent, this.errorMessage, this.isLogged});

  final UserModel? userCurrent;
  final String? errorMessage;
  final bool? isLogged;

  @override
  List<Object?> get props => [userCurrent, errorMessage, isLogged];
}

final class AuthInitial extends AuthState {}

final class LoadingAuthState extends AuthState {}

final class LoadedAuthState extends AuthState {
  const LoadedAuthState({required UserModel? userCurrent, bool? isLogged})
      : super(userCurrent: userCurrent, isLogged: isLogged);
}

final class FailureAuthState extends AuthState {
  const FailureAuthState({required String errorMessage})
      : super(errorMessage: errorMessage);
}
