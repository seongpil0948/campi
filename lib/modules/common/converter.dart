part of './index.dart';

List<File> xfilesToFiles(Iterable<XFile> fs) =>
    fs.map((e) => File(e.path)).toList();
