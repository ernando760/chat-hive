import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/auth/firebase_auth_services.dart';
import 'package:chat_hive/src/core/services/db/db_services.dart';
import 'package:chat_hive/src/core/services/db/firestore_services.dart';
import 'package:chat_hive/src/core/services/storage/firebase_storage_services.dart';
import 'package:chat_hive/src/core/services/storage/storage_services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addSingleton<AuthServices>(FirebaseAuthServices.new);
    i.addSingleton<DbServices>(FirestoreServices.new);
    i.addSingleton<StorageServices>(FirebaseStorageServices.new);
  }
}
