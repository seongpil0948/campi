part of './index.dart';

enum ThumnailSize { medium, small }

class FeedThumnail extends StatelessWidget {
  const FeedThumnail({
    Key? key,
    required this.mq,
    this.img,
    required this.feedInfo,
    required this.tSize,
    required this.writer,
  }) : super(key: key);
  final FeedState feedInfo;
  final MediaQueryData mq;
  final PiFile? img;
  final ThumnailSize tSize;
  final PiUser writer;

  @override
  Widget build(BuildContext context) {
    final thumnail = GestureDetector(
      onTap: () => context
          .read<NavigationCubit>()
          .push(feedDetailPath, {"selectedFeed": feedInfo}),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Stack(children: [
            if (img == null || img!.file == null)
              CachedNetworkImage(
                  fit: BoxFit.cover,
                  width: mq.size.width,
                  height: mq.size.height / 2.1,
                  imageUrl: img?.url ?? writer.profileImage)
            else if (img!.file != null)
              loadFile(f: img!, context: context),
            Positioned(
                bottom: tSize == ThumnailSize.medium ? mq.size.height / 30 : 10,
                left: mq.size.width / 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (tSize == ThumnailSize.medium)
                      UserRow(userId: feedInfo.writerId),
                    const SizedBox(height: 10),
                    Text(
                      rmTagAllPrefix(feedInfo.content),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(feedInfo.title,
                        style: tSize == ThumnailSize.medium
                            ? Theme.of(context)
                                .textTheme
                                .headline4
                                ?.copyWith(color: Colors.white)
                            : Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(color: Colors.white)),
                    Text(
                      rmTagAllPrefix(feedInfo.hashTags.join(" ")),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ))
          ])),
    );
    return thumnail;
  }
}
