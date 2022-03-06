import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:image/image.dart';

typedef OnCuttCallback = void Function(File file);

class AdjRatioImgW extends StatefulWidget {
  /// https://api.flutter.dev/flutter/widgets/AnimatedSize-class.html
  /// https://api.flutter.dev/flutter/widgets/AnimatedWidgetBaseState-class.html
  final File file;
  final OnCuttCallback onCutted;
  const AdjRatioImgW({Key? key, required this.file, required this.onCutted})
      : super(key: key);

  @override
  _AdjRatioImgWState createState() => _AdjRatioImgWState();
}

class _AdjRatioImgWState extends State<AdjRatioImgW> {
  // double scale = 0.0;
  // double _scaleFactor = 1.0;
  // double _baseScaleFactor = 1.0;
  Offset coord = const Offset(0, 0);
  List<int> photoRealRect = [];
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
    photoRealRect =
        findTrim(image!, mode: TrimMode.transparent); // x, y, width, height
  }

  @override
  Widget build(BuildContext context) {
    final imgWidth = photoRealRect[2] - photoRealRect[0]; // 3024
    final imgHeight = photoRealRect[3] - photoRealRect[1]; // 4032
    final isLandScape = imgWidth > imgHeight;
    final aspect =
        isLandScape ? imgHeight / imgWidth : imgWidth / imgHeight; // 0.75
    final mq = MediaQuery.of(context);

    double imgWidgetWidth, imgWidgetHeight, boxWidth, boxHeight;
    if (isLandScape) {
      imgWidgetWidth = mq.size.width;
      imgWidgetHeight = imgWidgetWidth * aspect;
    } else {
      imgWidgetWidth = mq.size.width * aspect;
      imgWidgetHeight = imgWidgetWidth / aspect;
    }

    final multipleW = imgWidth / imgWidgetWidth.round(); // > 1
    final multipleH = imgHeight / imgWidgetHeight.round(); // > 1
    // final marginHorizon = (mq.size.width - imgWidgetWidth) / 2;
    if (isLandScape) {
      boxWidth = imgWidgetHeight; // 0.8 is picture ratio
      boxHeight = imgWidgetHeight;
    } else {
      boxWidth = imgWidgetWidth; // 0.8 is picture ratio
      boxHeight = imgWidgetWidth;
    }

    // final marginVertical = (mq.size.height - boxHeight) / 2;
    final positionRect = // Crop Target
        Rect.fromLTRB(
            coord.dx, coord.dy, coord.dx + boxWidth, coord.dy + boxHeight);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(alignment: Alignment.center, children: [
          // Transform.scale(
          //     scale: _scaleFactor,
          //     child: mat.Image.file(
          //       widget.file,
          //       fit: BoxFit.contain,
          //       width: imgWidgetWidth,
          //       height: imgWidgetHeight,
          //     )),
          mat.Image.file(
            widget.file,
            fit: BoxFit.contain,
            width: imgWidgetWidth,
            height: imgWidgetHeight,
          ),
          Positioned.fromRect(
              rect: positionRect,
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  // onScaleStart: (details) {
                  //   _baseScaleFactor = _scaleFactor;
                  // },
                  onScaleUpdate: (details) {
                    setState(() {
                      // _scaleFactor = _baseScaleFactor * details.scale;
                      debugPrint(
                          "\n before dx: ${coord.dx}, dy: ${coord.dy} delta x: ${details.focalPointDelta.dx} y: ${details.focalPointDelta.dy} ");
                      var newDy = coord.dy + details.focalPointDelta.dy;
                      var newDx = coord.dx + details.focalPointDelta.dx;
                      if (newDy < 0) {
                        newDy = 0;
                      } else if (newDx < 0) {
                        newDx = 0;
                      } else if (positionRect.bottom > imgWidgetHeight) {
                        newDy = imgWidgetHeight - positionRect.height;
                      } else if (positionRect.right > imgWidgetWidth) {
                        newDx = imgWidgetWidth - positionRect.width;
                      }
                      coord = Offset(newDx, newDy);
                      debugPrint(
                          "after setState coord: $coord  rect  $positionRect");
                    });
                  },
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                        width: boxWidth,
                        height: boxHeight,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.blueGrey, width: 5),
                        )),
                  ))),
        ]),
        SizedBox(
          width: mq.size.width / 2.5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              mat.ElevatedButton(
                  child: const Text("확인"),
                  onPressed: () async {
                    // debugPrint("On Dispose, _scaleFactor: $_scaleFactor");
                    final trimed = copyCrop(
                        image!,
                        (positionRect.left * multipleW).round(),
                        (positionRect.top * multipleH).round(),
                        (positionRect.right * multipleW).round(),
                        (positionRect.bottom * multipleH).round());
                    Directory tempDir = await getTemporaryDirectory();
                    // create a new file in temporary path with random file name.
                    File file =
                        File(tempDir.path + (Random().nextInt(100)).toString());
                    final encoded = encodeNamedImage(trimed, file.path) ??
                        encodePng(trimed);
                    file.writeAsBytesSync(encoded);
                    widget.onCutted(file);
                  }),
              mat.ElevatedButton(
                  child: const Text("제출"),
                  onPressed: () => Navigator.of(context).pop())
            ],
          ),
        )
      ],
    );
  }
}
