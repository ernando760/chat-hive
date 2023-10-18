import 'package:chat_hive/src/shared/extensions/form_validator_extension.dart';

class FormValidator {
  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return "por favor preecha o campo nome";
    } else if (!name.isValidNameLength()) {
      return "O nome deve ter no minimo de 3 caracteres";
    }
    return null;
  }

  static String? validateLastname(String? lastname) {
    if (lastname == null || lastname.isEmpty) {
      return "por favor preecha o campo nome";
    } else if (!lastname.isValidLastnameLength()) {
      return "O nome deve ter no minimo de 3 caracteres";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "por favor preecha o campo nome";
    } else if (!email.isValidEmail()) {
      return "O nome deve ter no minimo de 3 caracteres";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "por favor preecha o campo nome";
    } else if (!password.isValidPasswordLenght()) {
      return "O nome deve ter no minimo de 3 caracteres";
    }
    return null;
  }
}
