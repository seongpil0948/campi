import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';

class PostRepo {
  List<FeedState> feeds = [];
  List<MgzState> mgzs = [];

  Future<List<dynamic>> getAllPosts(Iterable<String> userIds) async {
    var r = [];
    r.addAll(await getFeeds(userIds));
    r.addAll(await getMgzs(userIds));
    return r;
  }

  Future<List<FeedState>> getFeeds(Iterable<String> userIds) async {
    final userC = getCollection(c: Collections.users);
    for (var _id in userIds) {
      var feeds = await userC
          .doc(_id)
          .collection(feedCollection)
          .orderBy('updatedAt', descending: true)
          .get();
      var feedInfos = feeds.docs.map((f) => FeedState.fromJson(f.data()));
      this.feeds.addAll(feedInfos);
    }
    return feeds;
  }

  Future<List<MgzState>> getMgzs(Iterable<String> userIds) async {
    for (var _id in userIds) {
      final mgzs = await getCollection(c: Collections.magazines, userId: _id)
          .orderBy('updatedAt', descending: true)
          .get();
      var mgzDatas = mgzs.docs
          .map((m) => MgzState.fromJson(m.data() as Map<String, dynamic>));
      this.mgzs.addAll(mgzDatas);
    }
    return mgzs;
  }
}
