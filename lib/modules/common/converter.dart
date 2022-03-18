import 'dart:io';

import 'package:image_picker/image_picker.dart';

List<File> xfilesToFiles(Iterable<XFile> fs) =>
    fs.map((e) => File(e.path)).toList();
