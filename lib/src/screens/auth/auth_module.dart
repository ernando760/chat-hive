import 'package:chat_hive/src/core/core_module.dart';
import 'package:chat_hive/src/screens/auth/guard/auth_guard.dart';
import 'package:chat_hive/src/screens/auth/login/login_page.dart';
import 'package:chat_hive/src/screens/auth/register/register_page.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/welcome/welcome_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    i.addLazySingleton<AuthBloc>(AuthBloc.new,
        config: BindConfig(
          onDispose: (value) => value.close(),
        ));
  }

  @override
  void routes(RouteManager r) {
    r.child("/welcome",
        child: (context) => const WelcomePage(), guards: [AuthGuard()]);
    r.child(
      "/login",
      child: (context) => const LoginPage(),
    );
    r.child(
      "/register",
      child: (context) => const RegisterPage(),
    );
  }
}
