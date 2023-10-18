import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/shared/extensions/app_theme_extensions.dart';
import 'package:chat_hive/src/shared/widgets/text_form_field_custom_widget.dart';
import 'package:chat_hive/src/screens/chat/store/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.senderUuid, this.userReceiver});
  final String? senderUuid;

  final UserModel? userReceiver;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController _messageController;
  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();

    Future(() => context.read<ChatCubit>().getAllMessages(
        senderUuid: widget.senderUuid!,
        receiverUuid: widget.userReceiver!.uuid!));

    print("Uuid chat: ${widget.senderUuid}-${widget.userReceiver?.uuid}");
    print("photoUrl: ${widget.userReceiver?.photoUrl}");
  }

  Widget _buildListMessages(ChatCubit chatStore) {
    return Expanded(
      child: StreamBuilder<ChatState>(
        stream: chatStore.stream,
        builder: (context, snapshot) {
          final chatState = snapshot.data;
          if (chatState != null) {
            if (chatState is LoadedChatState) {
              return StreamBuilder(
                stream: chatState.messages,
                builder: (context, snapshot) {
                  final messages = snapshot.data;
                  return SizedBox(
                    height: context.fullHeight * .75,
                    child: ListView.builder(
                      itemCount: messages?.length ?? 0,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        return Align(
                          alignment:
                              messages?[index].senderUuid == widget.senderUuid!
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: messages?[index].senderUuid ==
                                        widget.senderUuid!
                                    ? context.backgroundColor
                                    : context.backgroundColorMessageReceiver,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                messages?[index].message ?? "title",
                                style: const TextStyle(fontSize: 18),
                              )),
                        );
                      },
                    ),
                  );
                },
              );
            } else if (chatState is FailureChatState) {
              return Center(
                child: Text(chatState.errorMessage!),
              );
            }
          }

          return const SizedBox(
            child: Text("error"),
          );
        },
      ),
    );
  }

  Widget _buildTextFieldAndSendButton() {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.fullWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: TextFormFieldCustomWidget(
                  padding: const EdgeInsets.all(0),
                  label: "Messagens",
                  controller: _messageController)),
          const SizedBox(
            width: 5,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: BorderRadius.circular(10)),
            child: IconButton(
                onPressed: () {
                  Modular.get<ChatCubit>().sendMessage(
                      receiverUuid: widget.userReceiver!.uuid!,
                      senderUuid: widget.senderUuid!,
                      message: _messageController.text);

                  _messageController.text = "";
                },
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatStore = context.watch<ChatCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        title: SizedBox(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: widget.userReceiver?.photoUrl != null
                    ? NetworkImage(widget.userReceiver!.photoUrl!)
                    : const AssetImage("assets/user.png")
                        as ImageProvider<Object>?,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                widget.userReceiver?.name ?? "User",
                style:
                    context.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          _buildListMessages(chatStore),
          _buildTextFieldAndSendButton()
        ],
      ),
    );
  }
}
