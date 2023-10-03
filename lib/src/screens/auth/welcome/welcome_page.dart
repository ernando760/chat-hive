import 'package:chat_hive/src/screens/auth/register/register_page.dart';
import 'package:chat_hive/src/screens/auth/store/cubit/auth_cubit.dart';
import 'package:chat_hive/src/screens/home/home_page.dart';
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
    context.read<AuthCubit>().authChangeState();
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthCubit>();
    return StreamBuilder<bool?>(
      stream: authStore.stream.map((event) => event.isLogged),
      builder: (context, snapshotIsLogged) {
        final isLogged = snapshotIsLogged.data;
        if (isLogged == null) {
          return _loadingPage;
        } else if (isLogged) {
          return const HomePage();
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
