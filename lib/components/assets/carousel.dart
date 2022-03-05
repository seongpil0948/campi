import 'dart:io';

import 'package:campi/components/assets/upload.dart';
import 'package:campi/components/geo/dot.dart';
import 'package:campi/components/gesture/resize_img.dart';
import 'package:campi/modules/posts/feed/cubit.dart';
import 'package:campi/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
        itemBuilder: (BuildContext context, int idx, int _) {
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
        itemBuilder: (BuildContext context, int idx, int _) {
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
    final feedCubit = context.read<FeedCubit>();
    if (imgs != null) {
      await showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            return CarouselSlider.builder(
                itemCount: imgs.length,
                itemBuilder: (BuildContext context, int idx, int _) {
                  final xImg = imgs[idx];
                  var file = File(xImg.path);
                  return AdjRatioImgW(
                      file: file,
                      onCutted: (newFile) {
                        debugPrint("On Cutts");
                        files.add(PiFile.file(
                            file: newFile, ftype: PiFileType.image));
                        debugPrint("changeFs: $files");
                        feedCubit.changeFs(files);
                      });
                },
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  aspectRatio: 1.0,
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height,
                ));
          });
      feedCubit.changeFs(files);
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
        itemBuilder: (BuildContext context, int idx, int _) => widget.imgs[idx],
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
