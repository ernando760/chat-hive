// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:chat_hive/src/core/models/message.dart';

class Chat extends Equatable {
  final String? uuidChat;
  final String? senderUuid;
  final String? receiverUuid;
  final List<Message> messages;

  const Chat({
    this.uuidChat,
    required this.senderUuid,
    required this.receiverUuid,
    required this.messages,
  });

  Chat copyWith({
    String? uuidChat,
    String? senderUuid,
    String? receiverUuid,
    List<Message>? messages,
  }) {
    return Chat(
      uuidChat: uuidChat ?? this.uuidChat,
      senderUuid: senderUuid ?? this.senderUuid,
      receiverUuid: receiverUuid ?? this.receiverUuid,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuidChat': uuidChat,
      'senderUuid': senderUuid,
      'receiverUuid': receiverUuid,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      uuidChat: map['uuidChat'] != null ? map['uuidChat'] as String : null,
      senderUuid: map['senderUuid'] as String,
      receiverUuid: map['receiverUuid'] as String,
      messages: List<Message>.from(
        (map['messages'] as List<int>).map<Message>(
          (x) => Message.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [uuidChat, senderUuid, receiverUuid, messages];
}
