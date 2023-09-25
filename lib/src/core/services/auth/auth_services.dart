import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class AuthServices {
  Future<Result<String, String>> signIn(
      {required String email, required String password});
  Future<Result<UserModel, String>> signUp(
      {required String name,
      required String lastname,
      required String email,
      required String password});
  Stream<String?> authStateChanges();
  void signOut();
}
