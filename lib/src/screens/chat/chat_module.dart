import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/chat/chat_page.dart';
import 'package:chat_hive/src/screens/chat/store/cubit/chat_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  @override
  void binds(Injector i) {
    i.addSingleton<ChatCubit>(ChatCubit.new,
        config: BindConfig(
          onDispose: (bloc) => bloc.close(),
        ));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => ChatPage(
        senderUuid: r.args.queryParams["userUuidCurrent"],
        userReceiver: r.args.data,
      ),
    );
  }
}
