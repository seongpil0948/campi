import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PostOrder { latest, popular }
const postOpts = [
  "최신순",
  "인기순",
];
PostOrder orderFromStr({required String orderBy}) {
  switch (orderBy) {
    case '최신순':
      return PostOrder.latest;
    case 'updatedAt':
      return PostOrder.latest;
    case '인기순':
      return PostOrder.popular;
    case 'likeCnt':
      return PostOrder.popular;
    default:
      return PostOrder.popular;
  }
}

String orderToStr({required PostOrder orderBy, bool ko = false}) {
  switch (orderBy) {
    case PostOrder.latest:
      return ko ? '최신순' : 'updatedAt';
    case PostOrder.popular:
      return ko ? '인기순' : 'likeCnt';
  }
}

Query<Object?> addOrder(Query ref, PostOrder orderBy) {
  return ref.orderBy(orderToStr(orderBy: orderBy, ko: false), descending: true);
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
      required PostOrder orderBy,
      List<String>? tags}) async {
    Query collect = getCollection(c: Collections.feeds);
    if (tags != null) {
      collect = collect.where('hashTags', arrayContainsAny: tags);
    }
    var query = addOrder(collect, orderBy);

    if (lastObj != null) {
      query =
          query.startAfter([lastObj.toJson()[orderToStr(orderBy: orderBy)]]);
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
      required PostOrder orderBy,
      List<String>? tags}) async {
    Query collect = getCollection(c: Collections.magazines);
    if (tags != null) {
      collect = collect.where('hashTags', arrayContainsAny: tags);
    }
    var query = addOrder(collect, orderBy);
    if (lastObj != null) {
      query =
          query.startAfter([lastObj.toJson()[orderToStr(orderBy: orderBy)]]);
    }
    return query.limit(pageSize).get();
  }
}
