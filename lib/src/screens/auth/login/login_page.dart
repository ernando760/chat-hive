import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/auth/widgets/form_login_widget.dart';
import 'package:chat_hive/src/shared/widgets/avartar_user_widget.dart';
import 'package:chat_hive/src/shared/widgets/button_custom_widget.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
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

  late final GlobalKey<FormState> _formLoginKey;

  @override
  void initState() {
    super.initState();
    _formLoginKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    Modular.get<AuthBloc>().stream.asBroadcastStream().listen(_listenAuthState);
  }

  _listenAuthState(AuthState state) {
    print("estado: $state");
    if (state is LoadedAuthState) {
      Modular.to.pushReplacementNamed("/", arguments: state.userCurrent?.uuid);
    } else if (state is FailureAuthState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  bool isObscure = true;
  void _showPassword() {
    isObscure = !isObscure;
    setState(() {});
  }

  void _signIn() async {
    if (_formLoginKey.currentState!.validate()) {
      Modular.get<AuthBloc>().add(SignInEvent(
          email: _emailController.text, password: _passwordController.text));
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  Widget _buildTitlePage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: const Text(
        "Login",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFormLogin() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AvartarUserWidget(),
            const SizedBox(
              height: 10,
            ),
            FormLoginWidget(
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
                  isObscure: isObscure,
                  showPassword: _showPassword,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ],
              actions: [
                ButtonCustomWidget(
                  label: "Entrar",
                  onPressed: _signIn,
                ),
                TextButton(
                    onPressed: () =>
                        Modular.to.pushReplacementNamed("/auth/register"),
                    child: Text(
                      "Você não tem uma conta?",
                      style:
                          context.titleExtraSmall?.copyWith(color: Colors.grey),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authStore = context.watch<AuthBloc>(
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [_buildTitlePage(), _buildFormLogin()],
              ),
            ),
          ),
        );
      },
    ));
  }
}
