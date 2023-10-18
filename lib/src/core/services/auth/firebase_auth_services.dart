import 'dart:developer';

import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:chat_hive/src/core/services/errors/auth_error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseAuthServices extends AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  bool get isLogged => _firebaseAuth.currentUser != null;

  @override
  String? get userCurrentUuid => _firebaseAuth.currentUser?.uid;

  @override
  AsyncResult<String, SignInError> signIn(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        return Success(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      return Failure(SignInError.fromCode(e.code));
    }

    return Failure(SignInError("Error ao fazer o login"));
  }

  @override
  AsyncResult<String, SignUpError> signUp(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        return Success(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      return Failure(SignUpError.fromCode(e.code));
    }
    return Failure(SignUpError("Error ao fazer o cadastro"));
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  AsyncResult<Unit, SignUpError> updateEmail({required String email}) async {
    try {
      await _firebaseAuth.currentUser?.updateEmail(email);
      return Success.unit();
    } on FirebaseAuthException catch (e) {
      log("${e.code} -> ${e.message}", name: "Error update email");
      return Failure(SignUpError.fromCode(e.code));
    }
  }

  @override
  AsyncResult<Unit, SignUpError> updatePassword(
      {required String password}) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(password);
      return Success.unit();
    } on FirebaseAuthException catch (e) {
      log("${e.code} -> ${e.message}", name: "Error update password");
      return Failure(SignUpError.fromCode(e.code));
    }
  }
}
