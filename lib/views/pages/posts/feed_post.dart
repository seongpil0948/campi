import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/inputs/text_controller.dart';
import 'package:campi/components/layout/piffold.dart';
import 'package:campi/components/select/single.dart';
import 'package:campi/modules/posts/feed/cubit.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/utils/parsers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedPostPage extends StatelessWidget {
  const FeedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Piffold(
        body: SingleChildScrollView(
            // FIXME: writer
            child: BlocProvider(
      create: (_) => FeedCubit(),
      child: const FeedPostW(),
    )));
  }
}

class FeedPostW extends StatelessWidget {
  const FeedPostW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Column(
      children: [
        SizedBox(
          height: mq.size.height / 2.5,
          width: mq.size.width - 20,
          child: PiAssetCarousel(),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _EditKind(),
              _EditPrice(),
              _EditAround(),
            ],
          ),
        ),
        // SelectMapW(onPick: (PickResult r) { TODO
        //   var feed = context.read<FeedInfo>();
        //   feed.addr = r.formattedAddress;
        //   final l = r.geometry?.location;
        //   if (l != null) {
        //     feed.lat = l.lat;
        //     feed.lng = l.lng;
        //   }
        // }),
        const PiFeedEditors(),
        const _HashList(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: ElevatedButton(
                  onPressed: () {
                    _postFeed(context: context);
                  },
                  child: const Center(
                    child: Text("올리기"),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

Future _postFeed({required BuildContext context}) async {
  List<PiFile> paths = [];
  // try {
  final feed = context.read<FeedCubit>().state;
  await Future.delayed(Duration.zero);
  return true;
  //   final writer = await feed.writer;

  //   for (var f in feed.files) {
  //     var file = await uploadFilePathsToFirebase(
  //         f: f, path: 'clientUploads/${writer?.userId}/${f.fName}');
  //     if (file != null) paths.add(file);
  //   }

  //   final doc = getCollection(c: Collections.Users).doc(writer?.userId);
  //   var finfo = FeedInfo(
  //     writerId: writer!.userId,
  //     feedId: feed.feedId,
  //     files: paths,
  //     title: feed.title,
  //     content: feed.content,
  //     placeAround: feed.placeAround,
  //     placePrice: feed.placePrice,
  //     campKind: feed.campKind,
  //     hashTags: feed.hashTags,
  //     addr: feed.addr,
  //     lat: feed.lat,
  //     lng: feed.lng,
  //   );
  //   // If you don't add a field to the document it will be orphaned.
  //   doc.set(writer.toJson(), SetOptions(merge: true));
  //   doc
  //       .collection(FeedCollection)
  //       .doc(feed.feedId)
  //       .set(finfo.toJson())
  //       .then((value) {
  //     print(">>> Feed Added <<<");
  //     state.currPageAction = PageAction.feed();
  //   });
  // } catch (e, s) {
  //   print(
  //       '!!!Failed to add Feed!!! Exception details:\n $e \n Stack trace:\n $s');
  //   FirebaseCrashlytics.instance
  //       .recordError(e, s, reason: 'Post Feed Error', fatal: true);
  // } finally {
  //   state.isLoading = false;
  // }
}

class _EditAround extends StatelessWidget {
  const _EditAround({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PiSingleSelect(
        onChange: (String? v) =>
            context.read<FeedCubit>().changeAround(v ?? ""),
        hint: "주변 정보",
        items: const ["마트 없음", "관광코스 없음", "계곡 없음", "산 없음"]);
  }
}

class _EditPrice extends StatelessWidget {
  const _EditPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PiSingleSelect(
        onChange: (String? v) {
          context.read<FeedCubit>().changePrice(int.parse(
              RegExp(r"\d+", caseSensitive: false, multiLine: false)
                  .stringMatch(v ?? "0")
                  .toString()));
        },
        hint: "가격 정보",
        items: const ["5만원 이하", "10만원 이하", "15만원 이하 ", "20만원 이하", "20만원 이상"]);
  }
}

class _EditKind extends StatelessWidget {
  const _EditKind({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PiSingleSelect(
        onChange: (String? v) {
          context.read<FeedCubit>().changeKind(v ?? "");
        },
        hint: "캠핑 종류",
        items: const ["__오토 캠핑", "차박 캠핑", "글램핑", "트래킹", "카라반"]);
  }
}

class _HashList extends StatelessWidget {
  const _HashList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tags = context.select((FeedCubit c) => c.state.hashTags);
    return Wrap(
      children: [
        for (var tag in tags)
          TextButton(
              onPressed: () {
                tags.remove(tag);
              },
              child: Text(tag, style: tagTextSty(tag, context))),
      ],
    );
  }
}