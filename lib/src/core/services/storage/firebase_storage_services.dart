import 'dart:developer';

import 'package:chat_hive/src/core/helper/storage_helper.dart';
import 'package:chat_hive/src/core/services/errors/storage_error.dart';
import 'package:chat_hive/src/core/services/storage/storage_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseStorageServices extends StorageServices {
  late final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<Result<String, StorageError>> addPhotoAvartar(
      {required String userUuid,
      required String? photoPathLocalAvartar}) async {
    try {
      if (photoPathLocalAvartar != null) {
        final storageRef = _firebaseStorage.ref();
        final imagesRef = storageRef.child("usersAvartar");
        final newfilePhoto = await createNewPhotoAvartarFile(
            path: photoPathLocalAvartar, userUuid: userUuid);
        log(newfilePhoto.path, name: "add photo");
        final spaceRef = imagesRef.child("$userUuid.png");
        await spaceRef.putFile(newfilePhoto);
        final url = await spaceRef.getDownloadURL();
        return Success(url);
      }
      return Failure(StorageError(
          errorMessage: "Error ao adicionar a foto $photoPathLocalAvartar"));
    } on FirebaseException catch (e) {
      log("${e.code} => ${e.message}", name: "Error addPhoto");
      return Failure(StorageError.fromCode(e.code));
    } catch (e) {
      log(e.toString(), error: "add photo");
      return Failure(StorageError(
          errorMessage: "Error ao adicionar a foto $photoPathLocalAvartar"));
    }
  }

  @override
  Future<Result<Unit, StorageError>> deletePhotoAvartar(
      {required String? userUuid}) async {
    try {
      if (userUuid != null) {
        final storageRef = _firebaseStorage.ref();
        final userRef = storageRef.child("usersAvartar/$userUuid.png");
        await userRef.delete();
        return Success.unit();
      }
      return Failure(
          StorageError(errorMessage: "foto não encontrado -> $userUuid.png"));
    } on FirebaseException catch (e) {
      log("${e.code} => ${e.message}", name: "Error deletePhoto");
      return Failure(StorageError.fromCode(e.code));
    }
  }

  @override
  Future<Result<String, StorageError>> updatePhotoAvartar(
      {required String userUuid, required String newPhotoPath}) async {
    try {
      if (newPhotoPath.isNotEmpty) {
        final futures = await Future.value([
          await deletePhotoAvartar(userUuid: userUuid),
          await addPhotoAvartar(
              userUuid: userUuid, photoPathLocalAvartar: newPhotoPath)
        ]);
        final resDeletePhotoAvartar = futures[0] as Success<Unit, StorageError>;
        final resAddPhotoAvartar = futures[1] as Success<String, StorageError>;

        final newPhoto = resAddPhotoAvartar.getOrNull();

        final deletePhotoAvartarException =
            resDeletePhotoAvartar.exceptionOrNull();

        if (deletePhotoAvartarException != null) {
          return Failure(deletePhotoAvartarException);
        }

        return Success(newPhoto);
      }
      return Failure(
          StorageError(errorMessage: "Error ao atualizar a foto do usuario"));
    } on FirebaseException catch (e) {
      log("${e.code} => ${e.message}", name: "Error updatePhoto");
      return Failure(StorageError.fromCode(e.code));
    }
  }
}
