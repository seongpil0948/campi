part of './index.dart';

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
  static Future<FeedState> getFeedById(String feedId) async {
    final ss = await getCollection(c: Collections.feeds).doc(feedId).get();
    return FeedState.fromJson(ss.data() as Map<String, dynamic>);
  }

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
    if (tags != null && tags.isNotEmpty) {
      collect = collect.where('hashTags', arrayContainsAny: tags);
    }
    var query = addOrder(collect, orderBy);

    if (lastObj != null) {
      query =
          query.startAfter([lastObj.toJson()[orderToStr(orderBy: orderBy)]]);
    }
    return query.limit(pageSize).get();
  }

  static Future<MgzState> getMgzById(String mgzId) async {
    final ss = await getCollection(c: Collections.magazines).doc(mgzId).get();
    return MgzState.fromJson(ss.data() as Map<String, dynamic>);
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
    if (tags != null && tags.isNotEmpty) {
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
