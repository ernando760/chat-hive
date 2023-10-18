import 'dart:developer';
import 'dart:io';

import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/home/store/bloc/home_bloc.dart';
import 'package:chat_hive/src/screens/home/widgets/form_update_user_widget.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key, required this.user});

  final UserModel user;

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  late final TextEditingController _nameController;

  late final TextEditingController _lastnameController;

  late final TextEditingController _emailController;

  late final TextEditingController _passwordController;

  late final GlobalKey<FormState> _formUpdateUserKey;

  late final ValueNotifier<File?> _photoFileAvartar;

  String? _photoPathAvartar;

  @override
  void initState() {
    super.initState();
    _formUpdateUserKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.user.name);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
    _photoFileAvartar = ValueNotifier<File?>(null);

    Modular.get<HomeBloc>().stream.asBroadcastStream().listen(_listenHomeState);
  }

  _listenHomeState(HomeState state) {
    if (state is LoadedAuthState) {
      Modular.to.pushReplacementNamed("/",
          arguments: state.user?.uuid ?? widget.user);

      _nameController.text = "";
      _lastnameController.text = "";
      _emailController.text = "";
      _passwordController.text = "";
      _photoFileAvartar.value = null;
    } else if (state is FailureHomeState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));
      _photoFileAvartar.value = null;

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _updateUser() async {
    if (_formUpdateUserKey.currentState!.validate()) {
      if (widget.user.uuid != null) {
        Modular.get<HomeBloc>().add(UpdateUserEvent(
            userUuid: widget.user.uuid!,
            name: _nameController.text,
            lastname: _lastnameController.text,
            email: _emailController.text,
            photoUrl: _photoPathAvartar,
            password: _passwordController.text));
      }
    }
  }

  void updatePhotoAvartar() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();

        final newFile = await File.fromUri(Uri.file(image.path.trim())).create()
          ..writeAsBytes(bytes);

        _photoFileAvartar.value = newFile;
        _photoPathAvartar = newFile.path;

        log(_photoFileAvartar.value!.path, name: "path photo");
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _photoFileAvartar.dispose();
    super.dispose();
  }

  bool isObscure = true;
  void _showPassword() {
    isObscure = !isObscure;
    setState(() {});
  }

  Widget _buildTitlePage(HomeState homeState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Modular.to.navigate("/",
                  arguments: homeState.user?.uuid ?? widget.user.uuid),
              icon: const Icon(Icons.arrow_back)),
          const Text(
            "Update User",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ],
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
              ValueListenableBuilder<File?>(
                  valueListenable: _photoFileAvartar,
                  builder: (context, photoFile, _) {
                    return CircleAvatar(
                      radius: radius + 4,
                      backgroundColor: context.backgroundColor,
                      child: CircleAvatar(
                        radius: radius + 2,
                        backgroundImage: photoFile != null
                            ? FileImage(photoFile)
                            : widget.user.photoUrl != null
                                ? NetworkImage(widget.user.photoUrl!)
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
                          onPressed: updatePhotoAvartar,
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
            FormUpdateUserWidget(
              formUpdateUserKey: _formUpdateUserKey,
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
                    onPressed: _updateUser,
                    child: Text(
                      "Atualizar",
                      style: context.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    )),
                // fontWeight: FontWeight.w600
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeStore = context.watch<HomeBloc>(
      (bind) => bind.stream,
    );
    return Scaffold(
        body: StreamBuilder<HomeState>(
      stream: homeStore.stream,
      builder: (context, snapshot) {
        if (snapshot.data is LoadingHomeState) {
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
                _buildTitlePage(homeStore.state),
                _buildFormRegisterWidget(),
              ],
            ),
          ),
        );
      },
    ));
  }
}
