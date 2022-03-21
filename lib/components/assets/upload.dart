part of './index.dart';

class AssetUploadCard extends StatelessWidget {
  const AssetUploadCard(
      {Key? key, required this.photoPressed, required this.videoPressed})
      : super(key: key);
  final void Function() photoPressed;
  final void Function() videoPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).colorScheme.secondary,
      onTap: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("이미지 혹은 영상 선택"),
                content: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          photoPressed();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.photo_library)),
                    IconButton(
                      onPressed: () {
                        videoPressed();
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.video_library),
                    ),
                  ],
                ),
              )),
      child: Card(
          // shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,
                size: 60, color: Theme.of(context).colorScheme.secondary),
            Text(
              "최대 10장 까지 업로드 가능합니다",
              style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      )),
    );
  }
}
