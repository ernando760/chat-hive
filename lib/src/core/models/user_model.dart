// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String? uuid;
  final String name;
  final String lastname;
  final String? photoUrl;
  final String email;
  final String password;
  const UserModel({
    this.uuid,
    required this.name,
    required this.lastname,
    this.photoUrl,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props {
    return [
      uuid,
      name,
      lastname,
      photoUrl,
      email,
      password,
    ];
  }

  UserModel copyWith({
    String? uuid,
    String? name,
    String? lastname,
    String? photoUrl,
    String? email,
    String? password,
  }) {
    return UserModel(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      lastname: lastname ?? this.lastname,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'name': name,
      'lastname': lastname,
      'photoUrl': photoUrl,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uuid: map['uuid'] != null ? map['uuid'] as String : null,
      name: map['name'] as String,
      lastname: map['lastname'] as String,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String get fullName => "$name $lastname";

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
