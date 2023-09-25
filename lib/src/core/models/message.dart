// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final String? uuid;
  final String? senderUuid;
  final String message;
  Message({
    this.uuid,
    this.senderUuid,
    required this.message,
  });

  Message copyWith({
    String? uuid,
    String? senderUuid,
    String? message,
  }) {
    return Message(
      uuid: uuid ?? this.uuid,
      senderUuid: senderUuid ?? this.senderUuid,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'senderUuid': senderUuid,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      senderUuid:
          map['senderUuid'] != null ? map['senderUuid'] as String : null,
      message: map['message'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Message(uuid: $uuid, message: $message)';

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.uuid == uuid && other.message == message;
  }

  @override
  int get hashCode => uuid.hashCode ^ message.hashCode;

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [uuid, senderUuid, message];
}
