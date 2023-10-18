part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class GetAllUsersEvent extends HomeEvent {}

final class GetUserEvent extends HomeEvent {
  final String userUuid;
  const GetUserEvent({required this.userUuid});
}

final class UpdateUserEvent extends HomeEvent {
  final String userUuid;
  final String name;
  final String lastname;
  final String email;
  final String password;
  final String? photoUrl;

  const UpdateUserEvent(
      {required this.userUuid,
      required this.name,
      required this.lastname,
      required this.email,
      required this.password,
      this.photoUrl});
}
