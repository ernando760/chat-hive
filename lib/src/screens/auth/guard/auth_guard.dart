import 'dart:async';
import 'dart:developer';

import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: "/auth/login");

  @override
  FutureOr<bool> canActivate(String path, ParallelRoute route) {
    log(path, name: "Path");
    log("${Modular.get<AuthBloc>().isLogged}", name: "isLogged");
    return Modular.get<AuthBloc>().isLogged;
  }
}
