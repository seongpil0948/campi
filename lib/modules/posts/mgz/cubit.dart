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

  Future<void> _updates(PiUser u, MgzState mgz) async {
    await Future.wait([u.update(), mgz.update()]);
  }

  void onLike(PiUser user, FcmRepo fcm) async {
    var likeUserIds = [...state.likeUserIds];
    if (likeUserIds.contains(user.userId)) {
      user.favoriteMgzs.remove(state.mgzId);
      likeUserIds.remove(user.userId);
    } else {
      user.favoriteMgzs.add(state.mgzId);
      likeUserIds.add(user.userId);
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
    final newState =
        state.copyWith(likeUserIds: likeUserIds, likeCnt: likeUserIds.length);
    _updates(user, newState);
    emit(newState);
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
