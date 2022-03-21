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
        if (snapshot.connectionState == ConnectionState.done) {
          // 만약 VideoPlayerController 초기화가 끝나면, 제공된 데이터를 사용하여
          // VideoPlayer의 종횡비를 제한하세요.
          return InkWell(
            onTap: () => controller.value.isPlaying
                ? controller.pause()
                : controller.play(),
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
          );
        } else {
          // 만약 VideoPlayerController가 여전히 초기화 중이라면,
          // 로딩 스피너를 보여줍니다.
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
