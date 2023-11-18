import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/auth/auth_module.dart';
import 'package:chat_hive/src/screens/chat/chat_module.dart';
import 'package:chat_hive/src/screens/home/home_module.dart';
import 'package:chat_hive/src/shared/shared_module.dart';

import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports =>
      [CoreModule(), SharedModule(), AuthModule(), HomeModule(), ChatModule()];

  @override
  void routes(r) {
    r.module("/auth", module: AuthModule());
    r.module("/", module: HomeModule());
    r.module("/chat", module: ChatModule());
  }
}
