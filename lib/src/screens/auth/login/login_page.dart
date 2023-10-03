import 'package:chat_hive/src/screens/auth/store/cubit/auth_cubit.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/auth/widgets/form_login_widget.dart';
import 'package:chat_hive/src/screens/auth/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  String? messageError;

  late final GlobalKey<FormState> _formLoginKey;

  @override
  void initState() {
    super.initState();
    _formLoginKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    Modular.get<AuthCubit>()
        .stream
        .asBroadcastStream()
        .listen(_listenAuthState);
  }

  _listenAuthState(AuthState state) {
    print("estado: $state");
    if (state is LoadedAuthState) {
      Modular.to.pushReplacementNamed("/");
    } else if (state is FailureAuthState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));
      messageError = state.errorMessage;
      print(messageError);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _signIn() async {
    if (_formLoginKey.currentState!.validate()) {
      await Modular.get<AuthCubit>().signIn(
          email: _emailController.text, password: _passwordController.text);
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  Widget _buildTitlePage() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildFormLogin() {
    return Expanded(
      flex: 3,
      child: FormLoginWidget(
        formLoginKey: _formLoginKey,
        textFormFieldCustoms: [
          TextFormFieldCustomWidget(
            label: "email",
            controller: _emailController,
            validator: FormValidator.validateEmail,
            keyboardType: TextInputType.emailAddress,
          ),
          TextFormFieldCustomWidget(
            label: "password",
            controller: _passwordController,
            validator: FormValidator.validatePassword,
            keyboardType: TextInputType.visiblePassword,
          ),
        ],
        actions: [
          ElevatedButton(onPressed: _signIn, child: const Text("Entrar")),
          TextButton(
              onPressed: () =>
                  Modular.to.pushReplacementNamed("/auth/register"),
              child: const Text("Você já tem uma conta?"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthCubit>(
      (bind) => bind.stream,
    );
    return Scaffold(
        body: StreamBuilder(
      stream: authStore.stream,
      builder: (context, snapshot) {
        if (snapshot.data is LoadingAuthState) {
          return Container(
            color: Colors.black.withOpacity(.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildTitlePage(), _buildFormLogin()],
            ),
          ),
        );
      },
    ));
  }
}
