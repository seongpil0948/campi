import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';

class PostRepo {
  List<FeedState> feeds = [];
  List<MgzState> mgzs = [];

  Future<List<dynamic>> getAllPosts() async {
    var r = [];
    r.addAll(await getAllFeeds());
    r.addAll(await getAllMgzs());
    return r;
  }

  Future<List<FeedState>> getAllFeeds() async {
    final feedsDocs = await getCollection(c: Collections.feeds)
        .orderBy('updatedAt', descending: true)
        .get();
    return feedsDocs.docs
        .map((f) => FeedState.fromJson(f.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<MgzState>> getAllMgzs() async {
    final mgzsDocs = await getCollection(c: Collections.magazines)
        .orderBy('updatedAt', descending: true)
        .get();
    return mgzsDocs.docs
        .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>))
        .toList();
  }
}
