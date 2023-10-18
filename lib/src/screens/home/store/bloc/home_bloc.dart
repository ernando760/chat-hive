import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:chat_hive/src/core/services/storage/storage_services.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final AuthServices _authServices;
  late final DbServices _dbServices;
  late final StorageServices _storageServices;
  HomeBloc(AuthServices authServices, DbServices dbServices,
      StorageServices storageServices)
      : super(HomeInitial()) {
    _authServices = authServices;
    _dbServices = dbServices;
    _storageServices = storageServices;
    on<GetAllUsersEvent>((event, emit) async {
      emit(LoadingHomeState());
      final res = await _dbServices.getAllUsers();
      final homeState = res
          .map((users) => LoadedHomeState(users: users, user: state.user))
          .mapError(
              (errorMessage) => FailureHomeState(errorMessage: errorMessage));

      homeState.fold((success) => emit(success), (failure) => emit(failure));
    });
    on<GetUserEvent>((event, emit) async {
      emit(LoadingHomeState());
      final res = await _dbServices.getUser(uuid: event.userUuid);

      final resGetAllUser = await _dbServices.getAllUsers();

      final getAllusersException = resGetAllUser.exceptionOrNull();

      if (getAllusersException != null) {
        emit(FailureHomeState(errorMessage: getAllusersException));
        return;
      }
      final users = resGetAllUser.getOrNull();

      final homeState = res
          .map((user) => LoadedHomeState(users: users ?? [], user: user))
          .mapError(
              (errorMessage) => FailureHomeState(errorMessage: errorMessage));

      homeState.fold((success) => emit(success), (failure) => emit(failure));
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(LoadingHomeState());

      final resUser = await _dbServices.getUser(uuid: event.userUuid);

      final user = resUser.getOrNull();

      if (user != null) {
        if (user.email != event.email) {
          final resUpdateEmail =
              await _authServices.updateEmail(email: event.email);
          final updateEmailException = resUpdateEmail.exceptionOrNull();
          if (updateEmailException != null) {
            log("${updateEmailException.errorMessage}",
                name: "Error update email");
            emit(FailureHomeState(
                errorMessage: updateEmailException.errorMessage!));
          }
        }

        if (user.password != event.password) {
          final resUpdatePassword =
              await _authServices.updatePassword(password: event.password);
          final updatePasswordException = resUpdatePassword.exceptionOrNull();
          if (updatePasswordException != null) {
            log("${updatePasswordException.errorMessage}",
                name: "Error update password");
            emit(FailureHomeState(
                errorMessage: updatePasswordException.errorMessage!));
          }
        }
        String? photoUser = user.photoUrl;
        if (photoUser != event.photoUrl) {
          final resUpdatePhoto = await _storageServices.updatePhotoAvartar(
              userUuid: event.userUuid, newPhotoPath: event.photoUrl!);

          final updatePhoto = resUpdatePhoto.getOrNull();
          if (updatePhoto != null) {
            photoUser = updatePhoto;
            log(photoUser, name: "update photo home bloc");
          } else {
            final updatePhotoException = resUpdatePhoto.exceptionOrNull();
            emit(FailureHomeState(
                errorMessage: updatePhotoException!.errorMessage));

            log(updatePhotoException.errorMessage, name: "Error update photo");
          }
        }

        UserModel? updateUser;
        final resUpdateUser = await _dbServices.updateUser(
            uuid: event.userUuid,
            name: event.name,
            lastname: event.lastname,
            email: event.email,
            password: event.password,
            photoUrl: photoUser);

        updateUser = resUpdateUser.getOrNull();

        if (updateUser != null) {
          final resGetAllUser = await _dbServices.getAllUsers();
          final users = resGetAllUser.getOrNull();
          if (users != null) {
            updateUser = resUpdateUser.getOrNull()!;
            emit(LoadedHomeState(users: users, user: updateUser));
          } else {
            final getAllusersException = resGetAllUser.exceptionOrNull();
            emit(FailureHomeState(errorMessage: getAllusersException!));
            log(getAllusersException, name: "Error get all user");
          }
        } else {
          final updateUserException = resUpdateUser.exceptionOrNull();
          emit(FailureHomeState(errorMessage: updateUserException!));
        }
      } else {
        final userException = resUser.exceptionOrNull();
        emit(FailureHomeState(errorMessage: userException!));

        log(userException, name: "Error get user");
      }
    });
  }
}
