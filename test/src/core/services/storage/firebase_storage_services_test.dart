import 'package:chat_hive/src/core/services/errors/storage_error.dart';
import 'package:chat_hive/src/core/services/storage/firebase_storage_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class MockFirebaseStorageServices extends Mock
    implements FirebaseStorageServices {}

void main() {
  group("Success test", () {
    final MockFirebaseStorageServices mockFirebaseStorageServices =
        MockFirebaseStorageServices();
    test("Should be return [Success] when add photo", () async {
      when(
        () => mockFirebaseStorageServices.addPhotoAvartar(
            userUuid: "nameUser", photoPathLocalAvartar: "photoPath"),
      ).thenAnswer((_) async => const Success("photoPath"));

      final res = await mockFirebaseStorageServices.addPhotoAvartar(
          userUuid: "nameUser", photoPathLocalAvartar: "photoPath");

      expect(res, equals(const Success<String, StorageError>("photoPath")));

      verify(
        () => mockFirebaseStorageServices.addPhotoAvartar(
            userUuid: "nameUser", photoPathLocalAvartar: "photoPath"),
      ).called(1);
    });

    test("Should be return [Success] when delete photo", () async {
      when(
        () => mockFirebaseStorageServices.deletePhotoAvartar(
          userUuid: "userUuid",
        ),
      ).thenAnswer((_) async => Success.unit());

      final res = await mockFirebaseStorageServices.deletePhotoAvartar(
        userUuid: "userUuid",
      );

      expect(res, equals(Success.unit<StorageError>()));

      verify(
        () => mockFirebaseStorageServices.deletePhotoAvartar(
          userUuid: "userUuid",
        ),
      ).called(1);
    });
    test("Should be return [Success] when update photo", () async {
      when(
        () => mockFirebaseStorageServices.updatePhotoAvartar(
            userUuid: "nameUser", newPhotoPath: "newPhotoPath"),
      ).thenAnswer((_) async => const Success("updatePhoto"));

      final res = await mockFirebaseStorageServices.updatePhotoAvartar(
          userUuid: "nameUser", newPhotoPath: "newPhotoPath");

      expect(res, equals(const Success("updatePhoto")));

      verify(
        () => mockFirebaseStorageServices.updatePhotoAvartar(
            userUuid: "nameUser", newPhotoPath: "newPhotoPath"),
      ).called(1);
    });
  });

  group("Failure test", () {
    final MockFirebaseStorageServices mockFirebaseStorageServices =
        MockFirebaseStorageServices();
    test("Should be return [Failure] when add photo", () async {
      when(
        () => mockFirebaseStorageServices.addPhotoAvartar(
            userUuid: "", photoPathLocalAvartar: ""),
      ).thenAnswer((_) async =>
          Failure(StorageError(errorMessage: "Error ao adicionar o arquivo")));

      final res = await mockFirebaseStorageServices.addPhotoAvartar(
          userUuid: "", photoPathLocalAvartar: "");

      expect(
          res.exceptionOrNull()?.errorMessage,
          equals(Failure<String, StorageError>(
                  StorageError(errorMessage: "Error ao adicionar o arquivo"))
              .exceptionOrNull()
              .errorMessage));

      verify(
        () => mockFirebaseStorageServices.addPhotoAvartar(
            userUuid: "", photoPathLocalAvartar: ""),
      ).called(1);
    });

    test("Should be return [Failure] when delete photo", () async {
      when(
        () => mockFirebaseStorageServices.deletePhotoAvartar(
          userUuid: "",
        ),
      ).thenAnswer((_) async => Failure(StorageError(
          errorMessage: "Error ao deletar a foto -> caminho vazio")));

      final res = await mockFirebaseStorageServices.deletePhotoAvartar(
        userUuid: "",
      );

      expect(
          res.exceptionOrNull()?.errorMessage,
          equals(Failure<Unit, StorageError>(StorageError(
                  errorMessage: "Error ao deletar a foto -> caminho vazio"))
              .exceptionOrNull()
              .errorMessage));

      verify(
        () => mockFirebaseStorageServices.deletePhotoAvartar(
          userUuid: "",
        ),
      ).called(1);
    });

    test(
        "Should be return [Failure] when newPhotoPath parameter is empty at the updatePhoto method",
        () async {
      when(
        () => mockFirebaseStorageServices.updatePhotoAvartar(
            userUuid: "nameUser", newPhotoPath: ""),
      ).thenAnswer((_) async => Failure(StorageError(
          errorMessage: "Error ao atualizar a foto -> newPhotoPath is empty")));

      final res = await mockFirebaseStorageServices.updatePhotoAvartar(
          userUuid: "nameUser", newPhotoPath: "");

      expect(
          res.exceptionOrNull()?.errorMessage,
          equals(Failure<String, StorageError>(StorageError(
                  errorMessage:
                      "Error ao atualizar a foto -> newPhotoPath is empty"))
              .exceptionOrNull()
              .errorMessage));

      verify(
        () => mockFirebaseStorageServices.updatePhotoAvartar(
            userUuid: "nameUser", newPhotoPath: ""),
      ).called(1);
    });
  });
}
