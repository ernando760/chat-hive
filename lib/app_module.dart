import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const HomePage(),
    );
  }
}
