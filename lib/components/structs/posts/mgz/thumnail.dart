part of './index.dart';

class MgzThumnail extends StatelessWidget {
  const MgzThumnail({
    Key? key,
    required this.mgz,
    required this.tSize,
  }) : super(key: key);

  final MgzState mgz;
  final ThumnailSize tSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaUrl = docCheckMedia(mgz.content, checkImg: true);
    const comC = Colors.white; // complementary color
    final marginHSide = size.width / 15;
    final marginVSide = size.height / 30;
    return mediaUrl != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: InkWell(
                onTap: () {
                  context
                      .read<NavigationCubit>()
                      .push(mgzDetailPath, {'magazine': mgz});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                          imageUrl: mediaUrl,
                          fit: BoxFit.cover,
                          width: size.width,
                          height: size.height / 3),
                      Positioned(
                          bottom: marginVSide,
                          left: marginHSide,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tSize == ThumnailSize.medium)
                                  UserRow(userId: mgz.writerId),
                                const SizedBox(height: 10),
                                Text(
                                  mgz.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(color: comC),
                                )
                              ])),
                      Positioned(
                          bottom: marginHSide,
                          right: marginHSide,
                          child: Row(
                            children: [
                              const Icon(Icons.favorite, color: comC),
                              const SizedBox(width: 5),
                              Text(
                                mgz.likeCnt.toString(),
                                style: const TextStyle(color: comC),
                              ),
                              const SizedBox(width: 10),
                              const Icon(Icons.mode_comment, color: comC),
                              const SizedBox(width: 5),
                              const Text("10", style: TextStyle(color: comC))
                            ],
                          ))
                    ],
                  ),
                )),
          )
        : Container();
  }
}
