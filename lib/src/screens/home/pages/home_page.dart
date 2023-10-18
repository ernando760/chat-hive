import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/screens/home/store/bloc/home_bloc.dart';
import 'package:chat_hive/src/screens/home/widgets/drawer_home_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userUuid});
  final String? userUuid;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    if (widget.userUuid != null && context.mounted) {
      Future(
        () => Modular.get<HomeBloc>()
            .add(GetUserEvent(userUuid: widget.userUuid!)),
      );
    }
  }

  Widget _buildListUser(List<UserModel> users) {
    return SizedBox(
      height: context.fullHeight,
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          if (users.isEmpty) {
            return const Center(
              child: Text(
                "Users list is empty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            );
          }
          return widget.userUuid != users[index].uuid
              ? GestureDetector(
                  onTap: () => Modular.to.pushNamed(
                      "/chat/?userUuidCurrent=${widget.userUuid}",
                      arguments: users[index]),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: users[index].photoUrl != null
                          ? NetworkImage(users[index].photoUrl!)
                          : const AssetImage("assets/user.png")
                              as ImageProvider<Object>?,
                    ),
                    title: Text(users[index].name),
                    subtitle: Text(users[index].email),
                  ),
                )
              : Container();
        },
      ),
    );
  }

  Widget _buildBodyHome(HomeState? homeState) {
    return switch (homeState) {
      HomeInitial() => const Center(
          child: CircularProgressIndicator(),
        ),
      LoadingHomeState() => const Center(
          child: CircularProgressIndicator(),
        ),
      LoadedHomeState() => homeState.users != null
          ? _buildListUser(homeState.users!)
          : Container(),
      FailureHomeState() => Center(
          child: Text(homeState.errorMessage!),
        ),
      null => Container()
    };
  }

  Widget _buildAvartarUser(HomeState homeState) {
    return SizedBox(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: homeState.user?.photoUrl != null
                ? NetworkImage(homeState.user!.photoUrl!)
                : const AssetImage("assets/user.png") as ImageProvider<Object>?,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            homeState.user?.name ?? "User",
            style: context.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homeStore = context.watch<HomeBloc>(
      (bind) => bind.stream,
    );
    return StreamBuilder<HomeState>(
        stream: homeStore.stream,
        builder: (context, snapshot) {
          final homeState = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Scaffold(
              endDrawer: DrawerHomeWidget(
                userInfo: homeState!.user,
              ),
              appBar: AppBar(
                backgroundColor: context.backgroundColor,
                title: _buildAvartarUser(homeState),
              ),
              body: _buildBodyHome(homeState));
        });
  }
}
