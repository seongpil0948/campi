import 'dart:io';

import 'package:campi/utils/io.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<PiFile?> uploadFilePathsToFirebase(
    {required PiFile f, required String path}) async {
  // /uploads/$p
  var storeRef = FirebaseStorage.instance.ref().child(path);
  SettableMetadata metadata = SettableMetadata(
    // cacheControl: 'max-age=60',
    customMetadata: <String, String>{
      'pymime': f.ftype.toCustomString(),
    },
  );
  var task = storeRef.putFile(File(f.file!.path), metadata);

  task.snapshotEvents.listen((TaskSnapshot snapshot) {
    // debugPrint('Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
  }, onError: (e) {
    // debugPrint(task.snapshot.toString());
  });

  try {
    await task;
    var meta = await storeRef.getMetadata();
    final info = {
      "url": await storeRef.getDownloadURL(),
      "pymime": meta.customMetadata!['pymime']
    };
    if (info.containsKey('url') && info.containsKey('pymime')) {
      return PiFile.fromCdn(url: info['url']!, fileType: info['pymime']!);
    }
  } on FirebaseException catch (e) {
    if (e.code == 'permission-denied') {
      // debugPrint('User does not have permission to upload to this reference.');
    }
    // ...
  }
}
