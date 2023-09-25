import 'package:chat_hive/src/core/models/user_model.dart';
import 'package:chat_hive/src/core/services/auth/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:result_dart/result_dart.dart';

class FirebaseAuthServices extends AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Result<String, String>> signIn(
      {required String email, required String password}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        return Success(userCredential.user!.uid);
      }

      return const Failure("Error ao fazer o login");
    }

    return const Failure("Error ao fazer o login");
  }

  @override
  Future<Result<UserModel, String>> signUp(
      {required String name,
      required String lastname,
      required String email,
      required String password}) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (_firebaseAuth.currentUser != null) {
        _firebaseAuth.currentUser!.updateDisplayName(name);
        final user = UserModel(
            uuid: userCredential.user!.uid,
            name: name,
            lastname: lastname,
            email: email,
            password: password);
        return Success(user);
      }

      return const Failure("Error ao fazer o cadastro");
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
}
