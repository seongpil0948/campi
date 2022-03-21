import 'package:campi/components/assets/index.dart';
import 'package:campi/components/geo/index.dart';
import 'package:campi/components/inputs/index.dart';
import 'package:campi/components/noti/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/feed/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/views/router/index.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class FeedPostPage extends StatelessWidget {
  const FeedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
        builder: (context, state) => Piffold(
                body: SingleChildScrollView(
                    child: BlocProvider(
              create: (_) => FeedCubit(state.user.userId),
              child: const FeedPostW(),
            ))));
  }
}

class FeedPostW extends StatefulWidget {
  const FeedPostW({Key? key}) : super(key: key);

  @override
  _FeedPostWState createState() => _FeedPostWState();
}

class _FeedPostWState extends State<FeedPostW> {
  var loading = false;
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return loading == true
        ? loadingIndicator
        : SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: mq.size.height / 2,
                  width: mq.size.width,
                  child: PiAssetCarousel(),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const _EditKind(),
                      const _EditPrice(),
                      const _EditAround(),
                      SizedBox(
                          width: mq.size.width / 4,
                          child: SelectMapW(onPick: (PickResult r) {
                            final l = r.geometry?.location;
                            if (l != null) {
                              context
                                  .read<FeedCubit>()
                                  .changeAddr(l.lat, l.lng, r.formattedAddress);
                            }
                          }))
                    ],
                  ),
                ),
                const PiFeedEditors(),
                const _HashList(),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            List<PiFile> paths = [];
                            try {
                              final feed = context.read<FeedCubit>().state;
                              final userId = feed.writerId;

                              if (feed.files.isEmpty ||
                                  feed.files
                                      .where((element) =>
                                          element.ftype == PiFileType.image)
                                      .isEmpty) {
                                oneMoreImg(context);
                                setState(() {
                                  loading = false;
                                });
                                return;
                              }

                              for (var f in feed.files) {
                                var file = await uploadFilePathsToFirebase(
                                    f: f,
                                    path: 'clientUploads/$userId/${f.fName}');
                                if (file != null) paths.add(file);
                              }

                              final newFeed = feed.copyWith(fs: paths);
                              getCollection(c: Collections.feeds)
                                  .doc(newFeed.feedId)
                                  .set(newFeed.toJson())
                                  .then((value) async {
                                final writer = await feed.writer;
                                writer.feedIds.add(feed.feedId);
                                await writer.update();
                                context.read<FeedBloc>().add(
                                    FeedChangeOrder(order: PostOrder.latest));
                                context.read<AppBloc>().fcm.sendPushMessage(
                                    source: PushSource(
                                        tokens: [],
                                        userIds: writer.followers,
                                        data: DataSource(
                                            pushType: "postFeed",
                                            targetPage:
                                                "$feedDetailPath?feedId=${feed.feedId}"),
                                        noti: NotiSource(
                                            title: "캠핑 SNS 포스팅 알림",
                                            body:
                                                "${writer.name}님이 SNS 게시글을 올렸어요!")));
                                context.read<NavigationCubit>().pop();
                              });
                            } catch (e, s) {
                              // debugPrint('!!!Failed to add Feed!!! Exception details:\n $e \n Stack trace:\n $s');
                              FirebaseCrashlytics.instance.recordError(e, s,
                                  reason: 'Post Feed Error',
                                  fatal: true,
                                  printDetails: true);
                            }
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
            ),
          );
  }
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
        hint: "    캠핑 종류",
        items: const [
          "    오토 캠핑",
          "    차박 캠핑",
          "    글램핑",
          "    트래킹",
          "    카라반"
        ]);
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
