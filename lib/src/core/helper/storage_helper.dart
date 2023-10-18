import 'dart:io';

Future<File> createNewPhotoAvartarFile(
    {required String path, required String userUuid}) async {
  final filePhoto = await File(path).create();
  final bytes = await filePhoto.readAsBytes();
  final newfilePhoto =
      await File("${filePhoto.parent.path}/$userUuid.png").create()
        ..writeAsBytes(bytes);

  return newfilePhoto;
}
