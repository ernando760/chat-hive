part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState({this.user, this.users, this.errorMessage});

  final UserModel? user;

  final List<UserModel>? users;
  final String? errorMessage;

  @override
  List<Object?> get props => [user, users, errorMessage];
}

final class HomeInitial extends HomeState {}

final class LoadingHomeState extends HomeState {}

final class LoadedHomeState extends HomeState {
  const LoadedHomeState({required List<UserModel> users, UserModel? user})
      : super(user: user, users: users);
}

final class FailureHomeState extends HomeState {
  const FailureHomeState({required String errorMessage})
      : super(errorMessage: errorMessage);
}
