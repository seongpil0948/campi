part of './index.dart';

class VideoW extends StatelessWidget {
  final VideoPlayerController controller;
  const VideoW({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.done
            ? InkWell(
                onTap: () => controller.value.isPlaying
                    ? controller.pause()
                    : controller.play(),
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              )
            : loadingIndicator;
      },
    );
  }
}
