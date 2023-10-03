import 'dart:developer';

import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseAuthServices extends AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? errorMessage;

  @override
  AsyncResult<String, String> signIn(
      {required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        log('${userCredential.additionalUserInfo?.profile}',
            name: "profile login");
        log("${userCredential.user?.uid}", name: "user uuid");
        return Success(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = _getMessageFromErrorCode(e.code);
      log(e.code, name: "code");
      log("$errorMessage", name: "errorMessage");
      if (errorMessage != null) {
        return Failure(errorMessage!);
      }
    }

    return const Failure("Error ao fazer o login");
  }

  @override
  AsyncResult<UserModel, String> signUp(
      {required String name,
      required String lastname,
      required String email,
      required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        final userCredential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        userCredential.additionalUserInfo?.profile!["name"] = name;
        userCredential.additionalUserInfo?.profile!["lastname"] = lastname;
        if (_firebaseAuth.currentUser != null) {
          log('${userCredential.additionalUserInfo?.profile}',
              name: "profile register");
          _firebaseAuth.currentUser!.updateDisplayName(name);
          final user = UserModel(
              uuid: userCredential.user!.uid,
              name: name,
              lastname: lastname,
              email: email,
              password: password);
          return Success(user);
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage = _getMessageFromErrorCode(e.code);
      log(e.code, error: "code");
      log("$errorMessage", error: "errorMessage");
      if (errorMessage != null) {
        return Failure(errorMessage!);
      }
    }
    return const Failure("Error ao fazer o cadastro");
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<String?> authStateChanges() {
    return _firebaseAuth
        .authStateChanges()
        .map((event) => event?.uid)
        .distinct();
  }

  String _getMessageFromErrorCode(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return "O Email já é usado. Vai para a página de login.";
      case "ERROR_USER_NOT_FOUND":
      case "INVALID_LOGIN_CREDENTIALS":
      case "user-not-found":
        return "Nenhum usuário encontrado com este email.";
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return "Usuário disabilitado.";
      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Error no servidor, por favor tente mais tarde.";
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return "O Email esta invalido.";
      default:
        return "Falha ao se cadastar, por favor tente mais tarde";
    }
  }
}
