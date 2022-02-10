import 'package:campi/components/assets/carousel.dart';
import 'package:campi/components/geo/pymap.dart';
import 'package:campi/components/inputs/text_controller.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/components/select/single.dart';
import 'package:campi/components/signs/files.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/upload_file.dart';
import 'package:campi/modules/posts/feed/cubit.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/utils/parsers.dart';
import 'package:campi/views/router/state.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:uuid/uuid.dart';

class FeedPostPage extends StatelessWidget {
  const FeedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = context.select((AppBloc bloc) => bloc.state.user);
    return Piffold(
        body: SingleChildScrollView(
            child: BlocProvider(
      create: (_) => FeedCubit(_user.userId),
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
        SelectMapW(onPick: (PickResult r) {
          final l = r.geometry?.location;
          if (l != null) {
            context
                .read<FeedCubit>()
                .changeAddr(l.lat, l.lng, r.formattedAddress);
          }
        }),
        const PiFeedEditors(),
        const _HashList(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 30),
                child: ElevatedButton(
                  onPressed: () async {
                    List<PiFile> paths = [];
                    try {
                      context.read<AppBloc>().add(AppLoadingChange());
                      final feed = context.read<FeedCubit>().state;
                      final userId = feed.writerId;

                      if (feed.files.isEmpty ||
                          feed.files
                              .where((element) =>
                                  element.ftype == PiFileType.image)
                              .isEmpty) {
                        oneMoreImg(context);
                        return;
                      }

                      for (var f in feed.files) {
                        var file = await uploadFilePathsToFirebase(
                            f: f, path: 'clientUploads/$userId/${f.fName}');
                        if (file != null) paths.add(file);
                      }

                      final newFeed = feed.copyWith(fs: paths);
                      getCollection(c: Collections.feeds)
                          .doc(newFeed.feedId)
                          .set(newFeed.toJson())
                          .then((value) async {
                        final appBloc = context.read<AppBloc>();
                        appBloc.add(AppLoadingChange());

                        final writer = await feed.writer;
                        writer.feedIds.add(feed.feedId);
                        writer.update();
                        appBloc.fcm.sendPushMessage(
                            tokens: writer.followers,
                            data: {"tokenIsUid": true, "type": "postFeed"});
                        context.read<NavigationCubit>().pop();
                      });
                    } catch (e, s) {
                      debugPrint(
                          '!!!Failed to add Feed!!! Exception details:\n $e \n Stack trace:\n $s');
                      FirebaseCrashlytics.instance.recordError(e, s,
                          reason: 'Post Feed Error', fatal: true);
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
