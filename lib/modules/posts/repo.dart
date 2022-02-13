import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostRepo {
  Future<List<FeedState>> getFeedByUser(String userId) async {
    final snapshot = await getCollection(c: Collections.feeds)
        .where('writerId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((d) {
      return FeedState.fromJson(d.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<QuerySnapshot> getFeeds(
      {required FeedState? lastObj, required int pageSize}) async {
    var startQuery = getCollection(c: Collections.feeds)
        .orderBy('updatedAt', descending: true);
    if (lastObj != null) {
      startQuery = startQuery.startAfter([lastObj.toJson()['updatedAt']]);
    }
    return startQuery.limit(pageSize).get();
  }

  Future<List<MgzState>> getMgzByUser(String userId) async {
    final snapshot = await getCollection(c: Collections.magazines)
        .where('writerId', isEqualTo: userId)
        .get();
    return snapshot.docs.map((d) {
      return MgzState.fromJson(d.data() as Map<String, dynamic>);
    }).toList();
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
