import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image/image.dart';

typedef OnCuttCallback = void Function(File file);

class AdjRatioImgW extends StatefulWidget {
  /// TODO: https://api.flutter.dev/flutter/widgets/AnimatedSize-class.html
  /// https://api.flutter.dev/flutter/widgets/AnimatedWidgetBaseState-class.html
  /// FIXME: 박스크기가 맞지 않는다 (width).
  /// FIXME: 확대시 박스 를 width height 비율을 _scaleFactor 해서 저장해야한다.
  final File file;
  final OnCuttCallback onCutted;
  const AdjRatioImgW({Key? key, required this.file, required this.onCutted})
      : super(key: key);

  @override
  _AdjRatioImgWState createState() => _AdjRatioImgWState();
}

class _AdjRatioImgWState extends State<AdjRatioImgW> {
  // double scale = 0.0;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  Offset coord = const Offset(0, 0);
  List<int> trimRect = [];
  img.Image? image;

  @override
  void initState() {
    super.initState();
    var f = widget.file;
    List<int> bytes = f.readAsBytesSync();
    image = decodeImage(bytes);
    if (image == null) {
      debugPrint("decodeImage is Null: ${f.path}");
    }
    trimRect =
        findTrim(image!, mode: TrimMode.transparent); // x, y, width, height
  }

  @override
  void dispose() async {
    Future.delayed(Duration.zero, () async {
      debugPrint("On Dispose");
      final trimed = copyCrop(
          image!, trimRect[0], coord.dy.round(), trimRect[2], trimRect[3]);
      Directory tempDir = await getTemporaryDirectory();
      // get temporary path from temporary directory.
      String tempPath = tempDir.path;
      // create a new file in temporary path with random file name.
      File file = File(tempDir.path + (Random().nextInt(100)).toString());
      file.writeAsBytesSync(encodeNamedImage(trimed, widget.file.path)!);
      widget.onCutted(file);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ratio = trimRect[2] / trimRect[3];
    final mq = MediaQuery.of(context);
    //;
    final photoWidth = mq.size.width * ratio;
    final photoHeight = photoWidth / ratio;
    final marginHorizon = (mq.size.width - photoWidth) / 2;
    final boxWidth = photoWidth - marginHorizon; // 0.8 is picture ratio
    final boxHeight = boxWidth;
    // final marginVertical = (mq.size.height - boxHeight) / 2;
    final maxHeight = photoHeight;
    final positionRect = // Crop Target
        Rect.fromLTRB(0, coord.dy, mq.size.width, coord.dy + boxHeight);

    return SizedBox(
      width: photoWidth,
      child: Stack(clipBehavior: mat.Clip.none, children: [
        Transform.scale(
            scale: _scaleFactor,
            child: mat.Image.file(widget.file, fit: BoxFit.cover)),
        Positioned.fromRect(
            rect: positionRect,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleStart: (details) {
                  _baseScaleFactor = _scaleFactor;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    _scaleFactor = _baseScaleFactor * details.scale;
                    debugPrint(
                        "before dy: ${coord.dy} delta y: ${details.focalPointDelta.dy}");
                    var newDy = coord.dy + details.focalPointDelta.dy;
                    if (newDy < 0) {
                      newDy = 0;
                    } else if (positionRect.bottom > maxHeight) {
                      newDy = maxHeight - positionRect.height;
                    }
                    coord = Offset(0, newDy);
                    debugPrint(
                        "after setState coord: $coord maxHeight: $maxHeight, rect bottom: ${positionRect.bottom}");
                  });
                },
                child: Container(
                    width: boxWidth,
                    height: boxHeight,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.blueGrey, width: 5),
                    )))),
        mat.Positioned(
            bottom: 0,
            right: 0,
            child: mat.ElevatedButton(
                child: const Text("이미지 목록 제출"),
                onPressed: () {
                  Navigator.of(context).pop();
                }))
      ]),
    );
  }
}
