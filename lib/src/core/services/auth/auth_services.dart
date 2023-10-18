import 'package:chat_hive/src/core/services/errors/auth_error.dart';
import 'package:result_dart/result_dart.dart';

abstract class AuthServices {
  bool get isLogged => false;
  String? get userCurrentUuid => null;
  AsyncResult<String, SignInError> signIn(
      {required String email, required String password});
  AsyncResult<String, SignUpError> signUp(
      {required String email, required String password});
  AsyncResult<Unit, SignUpError> updateEmail({required String email});
  AsyncResult<Unit, SignUpError> updatePassword({required String password});
  Future<void> signOut();
}
