import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/mgz/thumnail.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/feed/utils.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedListW extends StatelessWidget {
  const FeedListW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchBloc = context.read<SearchValBloc>();
    searchBloc.add(AppSearchInit(context: context));
    return const Text("FeedListW");
  }
}

class GridFeeds extends StatelessWidget {
  const GridFeeds({
    Key? key,
    required this.feeds,
    required this.mgzs,
    required this.mq,
    required PiUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final List<FeedState> feeds;
  final List<MgzState> mgzs;
  final MediaQueryData mq;
  final PiUser _currUser;

  @override
  Widget build(BuildContext context) {
    final posts = [...feeds, ...mgzs];
    return GridView.builder(
        itemCount: feeds.length + mgzs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) {
          // FIXME
          return posts[idx] is FeedState
              ? Card(
                  elevation: 4.0,
                  child: SizedBox(
                    width: mq.size.width / 2.5,
                    height: mq.size.height / 3,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Provider.value(
                                value: _currUser,
                                child: FeedStatusRow(
                                  feed: posts[idx] as FeedState,
                                  tSize: ThumnailSize.small,
                                  U: _currUser,
                                ))),
                        Expanded(
                            flex: 3,
                            child: FutureBuilder<List<Object?>>(
                                future: Future.wait([
                                  imgsOfFeed(
                                      f: posts[idx] as FeedState, limit: 1),
                                  (posts[idx] as FeedState).writer
                                ]),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final imgs =
                                      snapshot.data![0] as List<PiFile>;
                                  final writer = snapshot.data![1] as PiUser?;
                                  return writer != null
                                      ? FeedThumnail(
                                          mq: mq,
                                          img: imgs.first,
                                          feedInfo: posts[idx] as FeedState,
                                          tSize: ThumnailSize.medium,
                                          writer: writer)
                                      : Container();
                                }))
                      ],
                    ),
                  ))
              : MgzThumnail(
                  mgz: posts[idx] as MgzState, tSize: ThumnailSize.small);
        });
  }
}
