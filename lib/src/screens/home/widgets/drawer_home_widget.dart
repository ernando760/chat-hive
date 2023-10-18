import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/auth/store/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DrawerHomeWidget extends StatelessWidget {
  const DrawerHomeWidget({
    super.key,
    this.userInfo,
  });
  final UserModel? userInfo;

  void _signOut() async {
    Modular.get<AuthBloc>().add(SignOutEvent());
    await Future.delayed(const Duration(seconds: 2));
    Modular.to.pushReplacementNamed("/auth/register");
  }

  Widget _buildDrawerHeader(BuildContext context) {
    const double radius = 40;
    return DrawerHeader(
        decoration: BoxDecoration(color: context.backgroundColor),
        padding: const EdgeInsets.only(left: 10, bottom: 10),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  child: CircleAvatar(
                    radius: radius,
                    backgroundColor: Colors.grey,
                    backgroundImage: userInfo?.photoUrl != null
                        ? NetworkImage(
                            userInfo!.photoUrl!,
                          )
                        : const AssetImage("assets/user.png")
                            as ImageProvider<Object>?,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                child: Text(userInfo!.fullName,
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              SizedBox(
                child: Text(
                  userInfo!.email,
                  style: context.titleSmall,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCardDrawer(
    BuildContext context, {
    required String title,
    required IconData icon,
    void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(
              width: 15,
            ),
            Text(
              title,
              style: context.titleMedium?.copyWith(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsDrawer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            _buildCardDrawer(
              context,
              title: "Atualizar o perfil",
              icon: Icons.person_2_outlined,
              onTap: () =>
                  Modular.to.navigate("/updateUser", arguments: userInfo),
            ),
            const Divider(
              height: 2,
              thickness: 2,
            ),
          ],
        ),
        _buildCardDrawer(context,
            title: "Logout", icon: Icons.logout, onTap: _signOut),
        const Divider(
          height: 2,
          thickness: 2,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context),
          _buildActionsDrawer(context),
        ],
      ),
    );
  }
}
