class SignInError {
  final String? errorMessage;
  SignInError(this.errorMessage);

  factory SignInError.fromCode(String code) {
    switch (code) {
      case "ERROR_USER_NOT_FOUND":
      case "INVALID_LOGIN_CREDENTIALS":
      case "user-not-found":
        return SignInError("Nenhum usuário encontrado com este email.");
      case 'wrong-password':
        return SignInError(
          'Senha incorreta, por favor tente mais tarde.',
        );
      case 'user-disabled':
        return SignInError(
          'Este usuario foi sido desabilitado, por favor contate o suporte.',
        );
      case "auth/internal-error":
        return SignInError(
            "Falha interna oa fazer a solicitação do login do usuario");
      default:
        return SignInError("Falha ao login, por favor tente mais tarde.");
    }
  }
}

class SignUpError {
  final String? errorMessage;
  SignUpError(this.errorMessage);
  factory SignUpError.fromCode(String code) {
    switch (code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        return SignUpError("O Email já é usado. Vai para a página de login.");
      case "ERROR_USER_DISABLED":
      case "user-disabled":
        return SignUpError(
            "Este usuario foi sido desabilitado, por favor contate o suporte.");
      case "ERROR_OPERATION_NOT_ALLOWED":
        return SignUpError("Error no servidor, por favor tente mais tarde.");
      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        return SignUpError("O Email esta invalido.");
      case "auth/internal-error":
        return SignUpError(
            "Falha interna oa fazer a solicitação do Cadastro do usuario");
      default:
        return SignUpError("Falha ao se cadastar, por favor tente mais tarde");
    }
  }
}
