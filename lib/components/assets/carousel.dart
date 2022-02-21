import 'dart:io';

import 'package:campi/components/assets/upload.dart';
import 'package:campi/components/geo/dot.dart';
import 'package:campi/modules/posts/feed/cubit.dart';
import 'package:campi/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

// https://github.com/serenader2014/flutter_carousel_slider/blob/master/lib/carousel_options.dart
final pyCarouselOption = CarouselOptions(
  enlargeCenterPage: true,
  viewportFraction: 1.0,
  aspectRatio: 1.0,
  enableInfiniteScroll: false,
);

class PiCarousel extends StatelessWidget {
  final List<PiFile> fs;
  const PiCarousel({Key? key, required this.fs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
        itemCount: fs.length,
        itemBuilder: (BuildContext context, int idx, int pageViewIndex) {
          var f = fs[idx];
          return loadFile(f: f, context: context);
        },
        options: pyCarouselOption);
  }
}

class PiAssetCarousel extends StatelessWidget {
  PiAssetCarousel({Key? key}) : super(key: key);
  final CarouselController buttonCarouselController = CarouselController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final fs = context.select((FeedCubit c) => c.state.files);
    return CarouselSlider.builder(
        itemCount: fs.length + 1,
        itemBuilder: (BuildContext context, int idx, int pageViewIndex) {
          if (idx == fs.length) {
            return AssetUploadCard(
                photoPressed: () => _pressAssetButton(false, fs, context),
                videoPressed: () => _pressAssetButton(true, fs, context));
          }
          var f = fs[idx];
          return loadFile(f: f, context: context);
        },
        options: pyCarouselOption);
  }

  _pressAssetButton(bool isVideo, List<PiFile> fs, BuildContext context) async {
    List<PiFile> files = [...fs];
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      if (asset != null) {
        files.add(PiFile.fromXfile(f: asset, ftype: PiFileType.video));
        context.read<FeedCubit>().changeFs(files);
      }
      return null;
    }
    final imgs = await _picker.pickMultiImage();
    if (imgs != null) {
      showDialog(
          context: context,
          builder: (BuildContext nestedcontext) {
            return CarouselSlider.builder(
                itemCount: imgs.length,
                itemBuilder:
                    (BuildContext context, int idx, int pageViewIndex) {
                  final xImg = imgs[idx];
                  var file = File(xImg.path);
                  return AdjRatioImgW(file: file);
                },
                options: pyCarouselOption);
          });
      for (var i in imgs) {
        files.add(PiFile.fromXfile(f: i, ftype: PiFileType.image));
      }
      context.read<FeedCubit>().changeFs(files);
    }
  }
}

class PiDotCorousel extends StatefulWidget {
  final List<Image> imgs;
  const PiDotCorousel({Key? key, required this.imgs}) : super(key: key);

  @override
  _PiDotCorouselState createState() => _PiDotCorouselState();
}

class _PiDotCorouselState extends State<PiDotCorousel> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      CarouselSlider.builder(
        itemCount: widget.imgs.length,
        carouselController: _controller,
        itemBuilder: (BuildContext context, int idx, int pageViewIndex) =>
            widget.imgs[idx],
        options: CarouselOptions(
            autoPlay: true,
            // enlargeCenterPage: true,
            aspectRatio: 1.3,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
      Positioned(
        bottom: 10,
        right: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imgs.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: DotCircle(
                  width: 12.0,
                  height: 12.0,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            );
          }).toList(),
        ),
      ),
    ]);
  }
}

class AdjRatioImgW extends StatefulWidget {
  final File file;
  const AdjRatioImgW({Key? key, required this.file}) : super(key: key);

  @override
  _AdjRatioImgWState createState() => _AdjRatioImgWState();
}

class _AdjRatioImgWState extends State<AdjRatioImgW> {
  // double scale = 0.0;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;
  Offset _dy = const Offset(0, 0);
  // TODO: https://stackoverflow.com/questions/60924384/creating-resizable-view-that-resizes-when-pinch-or-drag-from-corners-and-sides-i
  @override
  Widget build(BuildContext context) {
    var f = widget.file;
    List<int> bytes = f.readAsBytesSync();
    img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      debugPrint("decodeImage is Null: ${f.path}");
    }
    List<int> trimRect = img.findTrim(image!,
        mode: img.TrimMode.transparent); // x, y, width, height
    final ratio = trimRect[2] / trimRect[3];
    final mq = MediaQuery.of(context);
    final stackWidth = mq.size.width * ratio;
    final stackHeight = stackWidth / ratio;
    final marginV = (mq.size.height - stackHeight) / 2;
    debugPrint("MediaQuery Size: ${mq.size}");
    debugPrint(
        "trimRect: $trimRect, squareSide: $ratio, stackHeight: $stackHeight, stackWidth: $stackWidth marginV: $marginV");
    return SizedBox(
      width: stackWidth,
      height: mq.size.height * ratio, // equal to mq.size.width
      child: Stack(children: [
        Transform.scale(
            scale: _scaleFactor, child: Image.file(f, fit: BoxFit.cover)),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
            debugPrint("_baseScaleFactor: $_baseScaleFactor");
            debugPrint("start Position: ${details.focalPoint}");
          },
          onScaleUpdate: (details) {
            setState(() {
              _scaleFactor = _baseScaleFactor * details.scale;
              debugPrint(
                  "focalPoint: ${details.focalPoint} dx: ${details.focalPoint.dx} dy: ${details.focalPoint.dy}");
              debugPrint("focalPointDelta: ${details.focalPointDelta}");
              debugPrint("before dy = : $_dy");

              // if (mq.size.height + marginV > details.focalPoint.dy &&
              //     mq.size.height - details.focalPoint.dy > marginV) {
              //   _dy = Offset(0, _dy.dy + details.focalPointDelta.dy);
              // }
              _dy = Offset(0, _dy.dy + details.focalPointDelta.dy);
              // 여기도 좌표 없누..
              final temp = Transform.translate(offset: _dy).transform;

              debugPrint(
                  "After set State -->  _scaleFactor: $_scaleFactor, _dy: $_dy");
            });
          },
          child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedContainer(
                  transform: Transform.translate(offset: _dy).transform,
                  curve: Curves.bounceInOut,
                  duration: const Duration(microseconds: 500),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 5)))),
        )
      ]),
    );
  }
}
