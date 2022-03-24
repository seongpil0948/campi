part of './index.dart';

class MgzCubit extends Cubit<MgzState> {
  MgzCubit({required String writerId, Document? content, String? title})
      : super(MgzState(
            writerId: writerId,
            content: content ?? Document(),
            title: title ?? ''));
  MgzCubit.fromState(MgzState mgz) : super(mgz);
  void changeDoc(String title, Document doc) =>
      emit(state.copyWith(title: title, content: doc));

  void posting(BuildContext context) {
    getCollection(c: Collections.magazines)
        .doc(state.mgzId)
        .set(state.toJson(), SetOptions(merge: true))
        .then((value) => context.read<NavigationCubit>().pop());
  }

  Future<void> _updates(PiUser u) async {
    Future.wait([u.update(), state.update()]);
  }

  void onLike(PiUser user, FcmRepo fcm) async {
    final aleady = state.likeUserIds.contains(user.userId);
    var uids = [...state.likeUserIds];
    if (aleady) {
      user.favoriteMgzs.remove(state.mgzId);
      uids.remove(user.userId);
      await _updates(user);
    } else {
      user.favoriteMgzs.add(state.mgzId);
      uids.add(user.userId);
      await _updates(user);
      final w = await UserRepo.getUserById(state.writerId);
      fcm.sendPushMessage(
          source: PushSource(
              tokens: w.rawFcmTokens,
              userIds: [],
              data: DataSource(
                  pushType: "favorFeed",
                  targetPage: "$mgzDetailPath?magazineId=${state.mgzId}"),
              noti: NotiSource(
                  title: "캠핑 포스팅 좋아요 알림",
                  body: "${user.name}님이 당신의 포스팅에 좋아요를 눌렀어요!")));
    }
    emit(state.copyWith(likeCnt: uids.length, likeUserIds: uids));
  }
}

String? docCheckMedia(Document dc, {checkImg = false, checkVideo = false}) {
  final j = dc.toDelta().toJson();
  for (var i = 0; i < j.length; i++) {
    if (!j[i].containsKey("insert") || j[i].values.first is String) {
      continue;
    } else if (checkImg == true && j[i].values.single.containsKey('image')) {
      return j[i].values.single['image'];
    } else if (checkVideo == true && j[i].values.single.containsKey('video')) {
      return j[i].values.single['video'];
    }
  }
  return null;
}
