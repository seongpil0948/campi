import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

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

class CompleteUser {
  PiUser user;
  List<FeedState> feeds;
  List<MgzState> mgzs;
  CompleteUser({required this.user, required this.feeds, required this.mgzs});
}

Future<CompleteUser> getCompleteUser(
    {required BuildContext context, PiUser? selectedUser}) async {
  late PiUser user;
  if (selectedUser != null) {
    user = selectedUser;
  } else {
    user = context.watch<AuthRepo>().currentUser;
  }
  if (user.isEmpty) {
    context.read<NavigationCubit>().clearAndPush(loginPath);
  }
  // FIXME: Posts by Ids 유저의 포스트 아이디 목록을 추가해야함
  // final pRepo = PostRepo();
  // final feeds = await pRepo.getFeeds([user.userId]);
  // final mgzs = await pRepo.getMgzs([user.userId]);
  return CompleteUser(feeds: [], user: user, mgzs: []);
}

Future<PiUser?> getUser(String? userId) async {
  final doc = await getCollection(c: Collections.users).doc(userId!).get();
  return doc.exists
      ? PiUser.fromJson(doc.data() as Map<String, dynamic>)
      : null;
}
