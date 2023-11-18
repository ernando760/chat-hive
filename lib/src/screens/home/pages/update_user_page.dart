import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/shared/controllers/avartar_user_controller.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:chat_hive/src/screens/auth/validator/form_validator.dart';
import 'package:chat_hive/src/screens/home/store/bloc/home_bloc.dart';
import 'package:chat_hive/src/screens/home/widgets/form_update_user_widget.dart';
import 'package:chat_hive/src/shared/widgets/avartar_user_widget.dart';
import 'package:chat_hive/src/shared/widgets/button_custom_widget.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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

  @override
  void initState() {
    super.initState();
    _formUpdateUserKey = GlobalKey<FormState>();
    _nameController = TextEditingController(text: widget.user.name);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);

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
    } else if (state is FailureHomeState) {
      final snackBar = SnackBar(content: Text(state.errorMessage!));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void _updateUser() async {
    if (_formUpdateUserKey.currentState!.validate()) {
      if (widget.user.uuid != null) {
        final photoAvartarUser =
            context.read<AvartarUserController>().photoFile?.path;
        Modular.get<HomeBloc>().add(UpdateUserEvent(
            userUuid: widget.user.uuid!,
            name: _nameController.text,
            lastname: _lastnameController.text,
            email: _emailController.text,
            photoUrl: photoAvartarUser,
            password: _passwordController.text));
      }
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

  Widget _buildFormRegisterWidget() {
    final photoFile = context.read<AvartarUserController>().photoFile;
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          children: [
            AvartarUserWidget(
              avartarUser:
                  photoFile == null ? widget.user.photoUrl : photoFile.path,
              onAddPressed: () =>
                  context.read<AvartarUserController>().updatePhotoAvartar(),
              onDeletePressed: () =>
                  context.read<AvartarUserController>().removePhotoFile(),
            ),
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
                ButtonCustomWidget(
                  label: "Atualizar",
                  onPressed: _updateUser,
                ),
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
