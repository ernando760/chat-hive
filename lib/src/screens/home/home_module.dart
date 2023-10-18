import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/home/pages/home_page.dart';
import 'package:chat_hive/src/screens/home/pages/update_user_page.dart';
import 'package:chat_hive/src/screens/home/store/bloc/home_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];
  @override
  void binds(Injector i) {
    i.addSingleton<HomeBloc>(HomeBloc.new,
        config: BindConfig(
          onDispose: (bloc) => bloc.close(),
        ));
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (_) => HomePage(userUuid: r.args.data),
    );
    r.child(
      "/updateUser",
      child: (_) => UpdateUserPage(user: r.args.data),
    );
  }
}
