import 'package:chat_hive/src/screens/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
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
