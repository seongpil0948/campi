import 'package:campi/components/geo/pymap.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class PlaceInfo extends StatelessWidget {
  const PlaceInfo({
    Key? key,
    required this.mq,
    required this.iconImgH,
    required this.feed,
  }) : super(key: key);

  final MediaQueryData mq;
  final double iconImgH;
  final FeedState feed;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      width: mq.size.width,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
            width: mq.size.width,
            padding: const EdgeInsets.fromLTRB(60, 0, 23, 0),
            child: Row(children: [
              Expanded(
                  flex: 1,
                  child: feed.campKind != null && feed.campKind!.isNotEmpty
                      ? CampKind(iconImgH: iconImgH, feed: feed)
                      : Container()),
              Expanded(
                  flex: 1,
                  child: CampAddr(feed: feed, iconImgH: iconImgH, mq: mq)),
            ])),
        Container(
            width: mq.size.width,
            padding: const EdgeInsets.fromLTRB(60, 0, 20, 0),
            child: Row(children: [
              Expanded(
                  flex: 1, child: CampPriceW(iconImgH: iconImgH, feed: feed)),
              Expanded(
                  flex: 1,
                  child:
                      feed.placeAround != null && feed.placeAround!.isNotEmpty
                          ? CampAroundW(iconImgH: iconImgH, feed: feed)
                          : Container()),
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
        "  ${feed.placeAround}",
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
      Text("  ${feed.placePrice} 만원")
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
      Text(" ${feed.campKind}")
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
        Image.asset(
          "assets/images/map_marker.png",
          height: iconImgH - 3,
        ),
        Expanded(
          child: TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: feed.addr));
            },
            child: Text(
              "${feed.addr}",
              overflow: TextOverflow.ellipsis,
            ),
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
