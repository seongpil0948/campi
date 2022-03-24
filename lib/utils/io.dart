part of './index.dart';

enum PiFileType { video, image }

extension ParseToString on PiFileType {
  String toCustomString() {
    return toString().split('.').last;
  }
}

PiFileType fileTypeFromString(String ftype) {
  switch (ftype) {
    case "video":
      return PiFileType.video;
    case "image":
      return PiFileType.image;
    default:
      return PiFileType.image;
  }
}

class PiFile {
  File? file;
  String? url;
  late PiFileType ftype;

  PiFile.fromXfile({required XFile f, required this.ftype})
      : file = File(f.path);
  PiFile.fileName({required String fileName, required this.ftype})
      : file = File(fileName);
  PiFile.file({required this.file, required this.ftype});

  PiFile.fromCdn({required String this.url, required String fileType}) {
    switch (fileType) {
      case "image":
        ftype = PiFileType.image;
        break;
      case "video":
        ftype = PiFileType.video;
        break;
    }
  }

  String? get fName => file != null ? file!.path.split("/").last : url;
  bool get isUploaded => url != null;

  Map<String, dynamic> toJson() => {
        'url': url,
        'file': file?.path,
        'ftype': ftype.toCustomString(),
      };

  PiFile.fromJson(j)
      : url = j['url'],
        ftype = fileTypeFromString(j['ftype']);
}

Widget loadFile({required PiFile f, required BuildContext context}) {
  final mq = MediaQuery.of(context);
  switch (f.ftype) {
    case PiFileType.image:
      return f.file != null
          ? Image.file(
              f.file!,
              fit: BoxFit.cover,
              width: mq.size.width,
            )
          : CachedNetworkImage(
              imageUrl: f.url!,
              fit: BoxFit.cover,
              width: mq.size.width,
            );

    case PiFileType.video:
      final c = f.file != null
          ? VideoPlayerController.file(f.file!)
          : VideoPlayerController.network(f.url!);
      return VideoW(controller: c);
  }
}
