import 'package:campi/modules/chat/msg_state.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepo {
  List<FeedState> feeds = [];
  List<MgzState> mgzs = [];

  Future<List<FeedState>> getFeeds() async {
    final feedsDocs = await getCollection(c: Collections.feeds)
        .orderBy('updatedAt', descending: true)
        .get();
    return feedsDocs.docs
        .map((f) => FeedState.fromJson(f.data() as Map<String, dynamic>))
        .toList();
  }

  Future<QuerySnapshot> getMgzs(
      {required MgzState? lastObj, required int pageSize}) async {
    var startQuery = getCollection(c: Collections.magazines)
        .orderBy('updatedAt', descending: true);
    if (lastObj != null) {
      startQuery = startQuery.startAfter([lastObj.toJson()['updatedAt']]);
    }
    return startQuery.limit(pageSize).get();
  }
}
