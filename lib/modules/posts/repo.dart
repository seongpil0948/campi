import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PostOrder { latest, popular }
String orderToStr(PostOrder orderBy) {
  switch (orderBy) {
    case PostOrder.latest:
      return 'updatedAt';
    case PostOrder.popular:
      return 'likeCnt';
  }
}

Query<Object?> addOrder(CollectionReference ref, PostOrder orderBy) {
  return ref.orderBy(orderToStr(orderBy), descending: true);
}

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
      {required FeedState? lastObj,
      required int pageSize,
      required PostOrder orderBy}) async {
    var query = addOrder(getCollection(c: Collections.feeds), orderBy);
    if (lastObj != null) {
      query = query.startAfter([lastObj.toJson()[orderToStr(orderBy)]]);
    }
    return query.limit(pageSize).get();
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
      {required MgzState? lastObj,
      required int pageSize,
      required PostOrder orderBy}) async {
    var query = addOrder(getCollection(c: Collections.magazines), orderBy);
    if (lastObj != null) {
      query = query.startAfter([lastObj.toJson()[orderToStr(orderBy)]]);
    }
    return query.limit(pageSize).get();
  }
}
