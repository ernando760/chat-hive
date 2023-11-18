import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AvartarUserController extends ChangeNotifier {
  File? photoFile;

  Future<void> addPhotoAvartarUser() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();

        final newFile = await File.fromUri(Uri.file(image.path)).create()
          ..writeAsBytes(bytes);
        log(newFile.path, name: "path photo url");
        photoFile = newFile;
        notifyListeners();
      }
    }
  }

  void updatePhotoAvartar() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final bytes = await image.readAsBytes();

        final newFile = await File.fromUri(Uri.file(image.path.trim())).create()
          ..writeAsBytes(bytes);

        photoFile = newFile;

        log(photoFile?.path ?? "nenhuma image adicionada", name: "path photo");
        notifyListeners();
      }
    }
  }

  void removePhotoFile() {
    photoFile = null;
    notifyListeners();
  }
}
