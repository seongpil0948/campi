part of './index.dart';

class PlaceInfo extends StatelessWidget {
  const PlaceInfo({
    Key? key,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final double iconImgH;
  final FeedState feed;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final height = mq.size.height / 10;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: mq.size.width,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const SizedBox(width: 40),
        SizedBox(
            width: mq.size.width / 2,
            height: height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: CampKind(iconImgH: iconImgH, feed: feed)),
                  Expanded(
                      child: CampAddr(feed: feed, iconImgH: iconImgH, mq: mq)),
                ])),
        SizedBox(
            height: height,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: CampPriceW(iconImgH: iconImgH, feed: feed)),
                  Expanded(child: CampAroundW(iconImgH: iconImgH, feed: feed)),
                ])),
      ]),
    );
  }
}

class CampAroundW extends StatelessWidget {
  const CampAroundW({
    Key? key,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final double iconImgH;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.asset(
        "assets/images/caution.png",
        height: iconImgH - 7,
      ),
      Text(
        "  ${feed.placeAround ?? ''}",
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }
}

class CampPriceW extends StatelessWidget {
  const CampPriceW({
    Key? key,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final double iconImgH;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.asset(
        "assets/images/won.png",
        height: iconImgH - 7,
      ),
      Text(feed.placePrice ?? '')
    ]);
  }
}

class CampKind extends StatelessWidget {
  const CampKind({
    Key? key,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final double iconImgH;
  final FeedState feed;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Image.asset(
        "assets/images/feed_icon_filled.png",
        height: iconImgH,
      ),
      Text(" ${feed.campKind ?? ''}")
    ]);
  }
}

class CampAddr extends StatelessWidget {
  const CampAddr({
    Key? key,
    required this.iconImgH,
    required this.feed,
    required this.mq,
  }) : super(key: key);

  final double iconImgH;
  final FeedState feed;
  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    if (feed.addr != null) {
      return Row(children: [
        Image.asset("assets/images/map_marker.png", height: iconImgH - 3),
        Expanded(
          child: TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: feed.addr)),
            child: Text("${feed.addr}", overflow: TextOverflow.ellipsis),
          ),
        )
      ]);
    } else {
      return SelectMapW(onPick: (PickResult r) async {
        feed.addr = r.formattedAddress;
        final l = r.geometry?.location;
        if (l != null) {
          feed.lat = l.lat;
          feed.lng = l.lng;
        }
        await feed.update();
      });
    }
  }
}
