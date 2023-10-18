class StorageError {
  final String errorMessage;

  StorageError({required this.errorMessage});

  factory StorageError.fromCode(String code) {
    switch (code) {
      case "storage/object-not-found":
        return StorageError(errorMessage: "Nenhum Arquivo encontrado.");
      case "storage/unauthenticated":
        return StorageError(
            errorMessage:
                "O usuário não está autenticado. Faça a autenticação e tente novamente.");
      case "storage/unauthorized":
        return StorageError(
            errorMessage:
                "O usuário não está autorizado a executar a ação desejada.");
      case "storage/invalid-checksum":
        return StorageError(
            errorMessage:
                "O arquivo no cliente não corresponde à soma de verificação do arquivo recebido pelo servidor. Envie novamente.");
      case "storage/invalid-url":
        return StorageError(
            errorMessage:
                "URL inválido fornecido para refFromURL(). Precisa estar no formato gs://bucket/object ou https://firebasestorage.googleapis.com/v0/b/bucket/o/object?token=<TOKEN>");
      case "storage/invalid-argument":
        return StorageError(
            errorMessage:
                "O argumento transmitido a put() precisa ser File, Blob ou matriz UInt8. O argumento transmitido a putString() precisa ser uma string bruta, Base64 ou Base64URL.");
      case "storage/cannot-slice-blob":
        return StorageError(
            errorMessage:
                "Error quando o arquivo local é alterado (excluído, salvo novamente etc.). Tente fazer o upload novamente após verificar que o arquivo não foi alterado.");
      case "storage/server-file-wrong-size":
        return StorageError(
            errorMessage:
                "O arquivo no cliente não corresponde ao tamanho do arquivo recebido pelo servidor.Por favor envie novamente");
      case "storage/unknown":
        return StorageError(errorMessage: "Ocorreu um error desconhecido");
      default:
        return StorageError(
            errorMessage:
                "Error no serviço do storage,por favor tente mais tarde");
    }
  }
}
