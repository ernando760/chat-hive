import 'dart:developer';

import 'package:chat_hive/src/screens/auth/login/login_page.dart';
import 'package:chat_hive/src/screens/auth/register/register_page.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    if (context.mounted) Modular.get<AuthBloc>().add(CheckUserIsLoggedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthBloc>(
      (bind) => bind.stream,
    );
    return StreamBuilder<AuthState?>(
      stream: authStore.stream.asBroadcastStream(),
      builder: (context, snapshotAuthState) {
        final state = snapshotAuthState.data;
        if (state is LoadingAuthState) {
          return _loadingPage;
        } else if (state is LoadedAuthState) {
          log("${state.userCurrent?.uuid}");
          if (state.isLogged! && state.userCurrent != null) {
            return HomePage(
              userUuid: state.userCurrent!.uuid!,
            );
          }
          return const LoginPage();
        } else {
          return const RegisterPage();
        }
      },
    );
  }

  final Widget _loadingPage = const Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
