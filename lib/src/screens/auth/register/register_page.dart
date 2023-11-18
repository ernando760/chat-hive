import 'package:chat_hive/src/shared/controllers/avartar_user_controller.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/auth/widgets/form_register_widget.dart';
import 'package:chat_hive/src/shared/widgets/avartar_user_widget.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    Modular.get<AuthBloc>().stream.asBroadcastStream().listen(_listenAuthState);
  }

  _listenAuthState(AuthState state) {
    if (state is LoadedAuthState) {
      Modular.to.pushReplacementNamed("/", arguments: state.userCurrent?.uuid);
    } else if (state is FailureAuthState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final photoAvatarUser =
          context.read<AvartarUserController>().photoFile?.path;
      Modular.get<AuthBloc>().add(SignUpEvent(
          name: _nameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          photoUrl: photoAvatarUser,
          password: _passwordController.text));

      _nameController.text = "";
      _lastnameController.text = "";
      _emailController.text = "";
      _passwordController.text = "";
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

  bool isObscure = true;
  void _showPassword() {
    isObscure = !isObscure;
    setState(() {});
  }

  Widget _buildTitlePage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: const Text(
        "Register",
        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFormRegisterWidget() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AvartarUserWidget(
              onAddPressed: () =>
                  context.read<AvartarUserController>().addPhotoAvartarUser(),
            ),
            const SizedBox(
              height: 10,
            ),
            FormRegisterWidget(
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
                  isObscure: isObscure,
                  showPassword: _showPassword,
                  keyboardType: TextInputType.visiblePassword,
                ),
              ],
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: context.backgroundColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: _signUp,
                    child: Text(
                      "Cadastrar",
                      style: context.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    )),
                TextButton(
                    style: TextButton.styleFrom(),
                    onPressed: () =>
                        Modular.to.pushReplacementNamed("/auth/login"),
                    child: Text(
                      "Você já tem uma conta?",
                      style: context.titleSmall?.copyWith(color: Colors.grey),
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTitlePage(),
                _buildFormRegisterWidget(),
              ],
            ),
          ),
        );
      },
    ));
  }
}
