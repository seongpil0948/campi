part of './index.dart';

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
    final feedCubit = context.read<FeedCubit>();
    if (isVideo) {
      final asset = await _picker.pickVideo(source: ImageSource.gallery);
      if (asset != null) {
        files.add(PiFile.fromXfile(f: asset, ftype: PiFileType.video));
        context.read<FeedCubit>().changeFs(files);
      }
      return null;
    }
    _addFiles(List<File> newFiles) {
      final donePiFs = newFiles
          .map((e) => PiFile.file(file: e, ftype: PiFileType.image))
          .toList();
      feedCubit.changeFs([...feedCubit.state.files, ...donePiFs]);
      Navigator.of(context).pop();
    }

    final imgs = await _picker.pickMultiImage();
    if (imgs != null) {
      await showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            final targetFs = xfilesToFiles(imgs);
            return AdjRatioImgList(
                imgs: targetFs, onDone: _addFiles, onCancel: _addFiles);
          });
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
