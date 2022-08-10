import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class CloudStorage {
  Future uploadFile({required PlatformFile platformFile}) async {
    final fileName = platformFile.name;
    final file = File(platformFile.path!);
    final storageRef = FirebaseStorage.instance.ref();
    final firebaseStorageRef = storageRef.child("images/$fileName");

    try {
      await firebaseStorageRef.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      debugPrint("task failed !!!!!!!!!!!!!!!!!!!!!!!!    $e");
    }
  }

  Future<List<Reference>> showFiles() async {
    final fireStorage = FirebaseStorage.instance.ref().child("images");
    var listResult = await fireStorage.list();

    return listResult.items;
  }
}
