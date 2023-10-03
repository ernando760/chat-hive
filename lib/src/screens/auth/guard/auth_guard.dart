import 'dart:async';

import 'package:chat_hive/src/screens/auth/store/cubit/auth_cubit.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: "/auth/login");

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    print("Path: $path");
    return Modular.get<AuthCubit>().isLogged;
  }
}
