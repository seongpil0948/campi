// import 'dart:io';
// import 'package:campy/components/assets/video.dart';
// import 'package:video_player/video_player.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// enum PiFileType { Video, Image }

// extension ParseToString on PiFileType {
//   String toCustomString() {
//     return this.toString().split('.').last;
//   }
// }

// PiFileType fileTypeFromString(String ftype) {
//   switch (ftype) {
//     case "Video":
//       return PiFileType.Video;
//     case "Image":
//       return PiFileType.Image;
//     default:
//       return PiFileType.Image;
//   }
// }

// class PiFile {
//   File? file;
//   String? url;
//   late PiFileType ftype;

//   PiFile.fromXfile({required XFile f, required this.ftype})
//       : this.file = File(f.path);
//   PiFile.fileName({required String fileName, required this.ftype})
//       : this.file = File(fileName);
//   PiFile.file({required this.file, required this.ftype});

//   PiFile.fromCdn({required String this.url, required String fileType}) {
//     switch (fileType) {
//       case "Image":
//         ftype = PiFileType.Image;
//         break;
//       case "Video":
//         ftype = PiFileType.Video;
//         break;
//     }
//   }

//   String get fName => file!.path.split("/").last;

//   Map<String, dynamic> toJson() => {
//         'url': url,
//         'file': file?.path,
//         'ftype': ftype.toCustomString(),
//       };

//   PiFile.fromJson(j)
//       : url = j['url'],
//         ftype = fileTypeFromString(j['ftype']);
// }

// Widget loadFile({required PiFile f, required BuildContext context}) {
//   final mq = MediaQuery.of(context);
//   switch (f.ftype) {
//     case PiFileType.Image:
//       return f.file != null
//           ? Image.file(
//               f.file!,
//               fit: BoxFit.cover,
//               width: mq.size.width,
//             )
//           : CachedNetworkImage(
//               imageUrl: f.url!,
//               fit: BoxFit.cover,
//               width: mq.size.width,
//             );

//     case PiFileType.Video:
//       final c = f.file != null
//           ? VideoPlayerController.file(f.file!)
//           : VideoPlayerController.network(f.url!);
//       return VideoW(controller: c);
//   }
// }
