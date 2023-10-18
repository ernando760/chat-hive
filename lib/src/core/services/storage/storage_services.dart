import 'package:chat_hive/src/core/services/errors/storage_error.dart';
import 'package:result_dart/result_dart.dart';

abstract class StorageServices {
  Future<Result<String, StorageError>> addPhotoAvartar(
      {required String userUuid, required String? photoPathLocalAvartar});
  Future<Result<String, StorageError>> updatePhotoAvartar(
      {required String userUuid, required String newPhotoPath});
  Future<Result<Unit, StorageError>> deletePhotoAvartar({
    required String? userUuid,
  });
}
