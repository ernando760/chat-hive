import 'dart:developer';
import 'dart:io';

import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/auth/widgets/form_register_widget.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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

  late final ValueNotifier<String?> _photoUrl;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _photoUrl = ValueNotifier<String?>(null);

    Modular.get<AuthBloc>().stream.asBroadcastStream().listen(_listenAuthState);
  }

  _listenAuthState(AuthState state) {
    if (state is LoadedAuthState) {
      Modular.to.pushReplacementNamed("/", arguments: state.userCurrent?.uuid);
    } else if (state is FailureAuthState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));
      _photoUrl.value = null;

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      Modular.get<AuthBloc>().add(SignUpEvent(
          name: _nameController.text,
          lastname: _lastnameController.text,
          email: _emailController.text,
          photoUrl: _photoUrl.value,
          password: _passwordController.text));

      _nameController.text = "";
      _lastnameController.text = "";
      _emailController.text = "";
      _passwordController.text = "";
      _photoUrl.value = null;
    }
  }

  void addPhoto() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();

        final newFile = await File.fromUri(Uri.file(image.path)).create()
          ..writeAsBytes(bytes);
        log(newFile.path, name: "path photo url");
        _photoUrl.value = newFile.path;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _photoUrl.dispose();
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

  Widget _buildAvartar() {
    double radius = 60;
    double width = 40;
    double height = 40;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          Stack(
            children: [
              ValueListenableBuilder<String?>(
                  valueListenable: _photoUrl,
                  builder: (context, photoUrl, _) {
                    return CircleAvatar(
                      radius: radius + 4,
                      backgroundColor: context.backgroundColor,
                      child: CircleAvatar(
                        radius: radius + 2,
                        backgroundImage: photoUrl != null
                            ? FileImage(File(photoUrl))
                            : const AssetImage("assets/user.png")
                                as ImageProvider<Object>,
                        backgroundColor: Colors.grey,
                      ),
                    );
                  }),
              Positioned(
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          color: context.backgroundColor,
                          shape: BoxShape.circle),
                      child: IconButton(
                          style: IconButton.styleFrom(
                              backgroundColor: context.backgroundColor,
                              iconSize: 20,
                              fixedSize: Size(width, height)),
                          splashRadius: radius - 42,
                          onPressed: addPhoto,
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormRegisterWidget() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildAvartar(),
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
