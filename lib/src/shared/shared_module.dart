import 'package:chat_hive/src/shared/controllers/avartar_user_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SharedModule extends Module {
  @override
  void binds(Injector i) {
    i.addSingleton(AvartarUserController.new);
  }
}
