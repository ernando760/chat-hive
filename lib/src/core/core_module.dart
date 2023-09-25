import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/auth/firebase_auth_services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    i.addSingleton<AuthServices>(FirebaseAuthServices.new);
  }
}
