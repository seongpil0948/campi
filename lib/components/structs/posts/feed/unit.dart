part of './index.dart';

class FeedW extends StatelessWidget {
  const FeedW({Key? key, required this.mq, required this.f}) : super(key: key);

  final MediaQueryData mq;
  final FeedState f;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PiUser>(
        future: f.writer,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? Container(
                  height: mq.size.height / 2.8,
                  padding: const EdgeInsets.all(20),
                  child: FeedThumnail(
                      mq: mq,
                      img: f.files.firstWhere(
                          (element) => element.ftype == PiFileType.image),
                      feedInfo: f,
                      tSize: ThumnailSize.medium,
                      writer: snapshot.data!))
              : Container();
        });
  }
}
