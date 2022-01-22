import 'package:campi/components/structs/feed/feed.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/feed/utils.dart';
import 'package:campi/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GridFeeds extends StatelessWidget {
  const GridFeeds({
    Key? key,
    required this.feeds,
    required this.mq,
    required PiUser currUser,
  })  : _currUser = currUser,
        super(key: key);

  final List<FeedState> feeds;
  final MediaQueryData mq;
  final PiUser _currUser;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: feeds.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) {
          final f = feeds[idx];
          return Card(
              elevation: 4.0,
              child: Container(
                width: mq.size.width / 2.5,
                height: mq.size.height / 3,
                child: Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Provider.value(
                            value: _currUser,
                            child: FeedStatusRow(
                              feed: f,
                              tSize: ThumnailSize.small,
                              U: _currUser,
                            ))),
                    Expanded(
                        flex: 3,
                        child: FutureBuilder<List<Object?>>(
                            future: Future.wait(
                                [imgsOfFeed(f: f, limit: 1), f.writer]),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final imgs = snapshot.data![0] as List<PiFile>;
                              final writer = snapshot.data![1] as PiUser?;
                              return writer != null
                                  ? FeedThumnail(
                                      mq: mq,
                                      img: imgs.first,
                                      feedInfo: f,
                                      tSize: ThumnailSize.medium,
                                      writer: writer)
                                  : Container();
                            }))
                  ],
                ),
              ));
        });
  }
}
