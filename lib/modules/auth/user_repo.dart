part of './index.dart';

class UserRepo {
  const UserRepo();
  Future<List<PiUser>> getAllUsers() async {
    // todo: Filtering Friends
    final collection = await getCollection(c: Collections.users)
        .orderBy('updatedAt', descending: true)
        .get();
    return collection.docs
        .map((userDoc) =>
            PiUser.fromJson(userDoc.data()! as Map<String, dynamic>))
        .toList();
  }

  static Future<PiUser> getUserById(String userId) async {
    final doc = await getCollection(c: Collections.users).doc(userId).get();
    assert(doc.exists);
    return PiUser.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<List<PiUser>> usersByIds(List<String> userIds) async {
    final uCol = getCollection(c: Collections.users);
    const chunkSize = 9;
    List<Future<QuerySnapshot<Object?>>> futures = [];
    for (var i = 0; i < userIds.length; i += chunkSize) {
      final chunkIds = userIds.sublist(
          i, i + chunkSize > userIds.length ? userIds.length : i + chunkSize);
      futures.add(uCol.where('userId', whereIn: chunkIds).get());
    }
    final queryResults = await Future.wait(futures);
    List<PiUser> users = [];
    for (var j in queryResults) {
      users.addAll(
          j.docs.map((e) => PiUser.fromJson(e.data() as Map<String, dynamic>)));
    }
    return users;
  }

  Future<List<String>> get allUserIds async =>
      (await getAllUsers()).map((u) => u.userId).toList();
}

class PostsUser {
  final String userId;
  final List<FeedState> feeds;
  final List<MgzState> mgzs;
  final Stream<DocumentSnapshot> userStream;
  PostsUser({required this.userId, required this.feeds, required this.mgzs})
      : userStream =
            getCollection(c: Collections.users).doc(userId).snapshots();
}

Future<PostsUser> getPostsUser(
    {required BuildContext context, PiUser? selectedUser}) async {
  final user = selectedUser ?? context.watch<AppBloc>().state.user;
  if (user.isEmpty) {
    context.read<NavigationCubit>().clearAndPush(loginPath);
  }
  final pRepo = PostRepo();
  final feeds = await pRepo.getFeedByUser(user.userId);
  final mgzs = await pRepo.getMgzByUser(user.userId);
  return PostsUser(feeds: feeds, userId: user.userId, mgzs: mgzs);
}

Future<PiUser?> getUser(String? userId) async {
  final doc = await getCollection(c: Collections.users).doc(userId!).get();
  return doc.exists
      ? PiUser.fromJson(doc.data() as Map<String, dynamic>)
      : null;
}
