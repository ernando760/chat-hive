import 'package:chat_hive/src/screens/auth/store/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _signOut() {
    Modular.get<AuthCubit>().signOut();
    Modular.to.pushReplacementNamed("/auth/register");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home page",
        ),
        actions: [
          IconButton(onPressed: _signOut, icon: const Icon(Icons.logout))
        ],
      ),
    );
  }
}
