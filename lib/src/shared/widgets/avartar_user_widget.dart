import 'package:chat_hive/src/shared/controllers/avartar_user_controller.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AvartarUserWidget extends StatefulWidget {
  const AvartarUserWidget(
      {super.key,
      this.avartarUser,
      this.onAddPressed,
      this.onDeletePressed,
      this.externalRadius = 64,
      this.internalRadius = 62,
      this.width = 40,
      this.height = 40});

  final String? avartarUser;
  final double externalRadius;
  final double internalRadius;
  final double width;
  final double height;
  final void Function()? onAddPressed;
  final void Function()? onDeletePressed;

  @override
  State<AvartarUserWidget> createState() => _AvartarUserWidgetState();
}

class _AvartarUserWidgetState extends State<AvartarUserWidget> {
  bool isSelectedAvartar = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        children: [
          Stack(
            children: [
              AnimatedBuilder(
                animation: context.read<AvartarUserController>(),
                builder: (context, child) {
                  final avartarUserController =
                      context.read<AvartarUserController>();

                  return Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: widget.externalRadius,
                      backgroundColor: context.backgroundColor,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onLongPress: () {
                          if (widget.onDeletePressed != null) {
                            isSelectedAvartar = true;

                            setState(() {});
                          }
                        },
                        child: CircleAvatar(
                          radius: widget.internalRadius,
                          backgroundImage:
                              avartarUserController.photoFile != null
                                  ? FileImage(avartarUserController.photoFile!)
                                  : widget.avartarUser != null
                                      ? NetworkImage(widget.avartarUser!)
                                      : const AssetImage("assets/user.png")
                                          as ImageProvider<Object>,
                          backgroundColor: Colors.grey,
                          child: isSelectedAvartar
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(.7),
                                      shape: BoxShape.circle),
                                  child: IconButton(
                                      onPressed: () {
                                        widget.onDeletePressed!();
                                        isSelectedAvartar = false;
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      )),
                                )
                              : Container(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              isSelectedAvartar == false
                  ? widget.onAddPressed != null
                      ? Positioned(
                          right: 88,
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
                                      fixedSize:
                                          Size(widget.width, widget.height)),
                                  splashRadius: widget.externalRadius - 42,
                                  onPressed: widget.onAddPressed,
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  )),
                            ),
                          ))
                      : Container()
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }
}
