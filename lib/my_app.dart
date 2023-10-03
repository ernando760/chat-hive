import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setInitialRoute("/auth/welcome");
    return MaterialApp.router(
      title: "Chat hive",
      routerConfig: Modular.routerConfig,
    );
  }
}
