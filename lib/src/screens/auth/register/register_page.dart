import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/auth/store/cubit/auth_cubit.dart';
import 'package:chat_hive/src/screens/auth/widgets/form_register_widget.dart';
import 'package:chat_hive/src/screens/auth/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _nameController;

  late final TextEditingController _lastnameController;

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  late final GlobalKey<FormState> _formKey;

  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
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
      errorMessage = state.errorMessage;
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      await Modular.get<AuthCubit>().signUp(
          name: _nameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          password: _passwordController.text);

      _nameController.text = "";
      _lastnameController.text = "";
      _emailController.text = "";
      _passwordController.text = "";
    }
  }

  Widget _buildTitlePage() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: const Text(
        "Register",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    ));
  }

  Widget _buildFormRegisterWidget() {
    return Expanded(
      flex: 3,
      child: FormRegisterWidget(
        formKey: _formKey,
        textFormFieldCustoms: [
          TextFormFieldCustomWidget(
            label: "name",
            controller: _nameController,
            validator: FormValidator.validateName,
          ),
          TextFormFieldCustomWidget(
            label: "lastname",
            controller: _lastnameController,
            validator: FormValidator.validateLastname,
          ),
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
          ElevatedButton(onPressed: _signUp, child: const Text("cadastrar")),
          TextButton(
              onPressed: () => Modular.to.pushReplacementNamed("/auth/login"),
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
        body: StreamBuilder<AuthState>(
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
              children: [_buildTitlePage(), _buildFormRegisterWidget()],
            ),
          ),
        );
      },
    ));
  }
}
