import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/auth/auth_module.dart';
import 'package:chat_hive/src/screens/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), AuthModule()];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const HomePage(),
    );
    r.module("/auth", module: AuthModule());
  }
}
