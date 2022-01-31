import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/utils/io.dart';

Future<List<PiFile>> imgsOfFeed({required FeedState f, int limit = 1}) async {
  List<PiFile> imgs = [];
  for (var i = 0; i < f.files.length; i++) {
    var file = f.files[i];
    if (file.ftype == PiFileType.video) {
      continue;
      // final tempPath = await getTemporaryDirectory();
      // final fileName = await VideoThumbnail.thumbnailFile(
      //   video: file.url!,
      //   thumbnailPath: tempPath.path,
      //   imageFormat: ImageFormat.PNG,
      //   quality: 100,
      // );
      // imgs.add(PiFile.fileName(fileName: fileName!, ftype: PiFileType.image));
    } else {
      // img
      imgs.add(file);
    }

    if ((limit - 1) <= i) break;
  }
  return imgs;
}
