part of './index.dart';

class CommentModel {
  ContentType ctype;
  String ctypeId;
  final String id;
  String writerId;
  String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  PiUser? _writer;

  CommentModel(
      {required this.id,
      required this.writerId,
      required this.content,
      required this.ctype,
      required this.ctypeId});

  Future<PiUser> get writer async {
    if (_writer != null) return _writer!;
    _writer = await UserRepo.getUserById(writerId);
    return _writer!;
  }

  void update({required String content}) {
    updatedAt = DateTime.now();
    this.content = content;
  }

  CommentModel.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writerId = j['writerId'],
        ctype = contentTypeFromString(j['ctype']),
        ctypeId = j['ctypeId'],
        content = j['content'],
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'writerId': writerId,
        'ctype': ctype.toCustomString(),
        'ctypeId': ctypeId,
        'content': content,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
}

// ignore: must_be_immutable
class CommentState extends Equatable {
  final CommentModel? targetCmt;
  final bool showPostCmtW;
  final TextEditingController commentController;

  const CommentState(
      {required this.commentController,
      this.targetCmt,
      required this.showPostCmtW});

  CommentState copyWith(
      {TextEditingController? commentController,
      CommentModel? targetComment,
      bool? showPostCmtWiget}) {
    return CommentState(
        commentController: commentController ?? this.commentController,
        targetCmt: targetComment,
        showPostCmtW: showPostCmtWiget ?? showPostCmtW);
  }

  @override
  List<Object?> get props => [targetCmt, showPostCmtW];
}

abstract class CommentEvent {}

class ShowPostCmtW extends CommentEvent {
  CommentModel? targetComment;
  bool showPostCmtWiget;
  ShowPostCmtW({required this.targetComment, required this.showPostCmtWiget});
}

class SubmitCmt extends CommentEvent {}

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ContentType contentType;
  final PiUser cmtWriter;
  final String postWriterId;
  final FcmRepo fcm;
  final String? feedId;
  final String? mgzId;
  CommentBloc(
      {this.mgzId,
      this.feedId,
      required TextEditingController controller,
      required this.fcm,
      required this.cmtWriter,
      required this.postWriterId,
      required this.contentType})
      : super(
            CommentState(showPostCmtW: false, commentController: controller)) {
    on<ShowPostCmtW>((ShowPostCmtW event, Emitter<CommentState> emit) async {
      return emit(state.copyWith(
          showPostCmtWiget: event.showPostCmtWiget,
          targetComment: event.targetComment));
    });

    on<SubmitCmt>((SubmitCmt event, Emitter<CommentState> emit) async {
      final txt = state.commentController.text;
      final postWriter = await UserRepo.getUserById(postWriterId);
      switch (contentType) {
        case ContentType.feed:
          if (feedId == null) {
            throw ArgumentError("feedId is Required");
          } else if (state.targetCmt == null) {
            postFeedComment(txt, cmtWriter, feedId!);
            fcm.sendPushMessage(
                destUserIds: [postWriter.userId],
                source: PushSource(
                    tokens: postWriter.rawFcmTokens,
                    userIds: [],
                    data: DataSource(
                        pushType: "postComment",
                        targetPage: "$feedDetailPath?feedId=$feedId",
                        fromUserId: cmtWriter.userId),
                    noti: NotiSource(
                        title: "댓글 알림",
                        body: "${cmtWriter.name}님이 당신의 게시글에 댓글을 남겼어요")));
          } else {
            postFeedReply(txt, cmtWriter, feedId!, state.targetCmt!.id);
            fcm.sendPushMessage(
                destUserIds: [state.targetCmt!.writerId],
                source: PushSource(
                    tokens: [],
                    userIds: [state.targetCmt!.writerId],
                    data: DataSource(
                        pushType: "postReply",
                        targetPage: "$feedDetailPath?feedId=$feedId",
                        fromUserId: cmtWriter.userId),
                    noti: NotiSource(
                        title: "답글 알림",
                        body: "${cmtWriter.name}님이 당신의 댓글에 답글을 남겼어요")));
          }
          state.commentController.clear();
          break;
        case ContentType.mgz:
          if (mgzId == null) {
            throw ArgumentError("mgzId is Required");
          } else if (state.targetCmt == null) {
            postMgzComment(txt, cmtWriter, mgzId!);
            fcm.sendPushMessage(
                destUserIds: [postWriter.userId],
                source: PushSource(
                    tokens: postWriter.rawFcmTokens,
                    userIds: [],
                    data: DataSource(
                        pushType: "postComment",
                        targetPage: "$mgzDetailPath?magazineId=$mgzId",
                        fromUserId: cmtWriter.userId),
                    noti: NotiSource(
                        title: "댓글 알림",
                        body: "${cmtWriter.name}님이 당신의 게시글에 댓글을 남겼어요")));
          } else {
            postMgzReply(txt, cmtWriter, mgzId!, state.targetCmt!.id);
            fcm.sendPushMessage(
                destUserIds: [state.targetCmt!.writerId],
                source: PushSource(
                    tokens: [],
                    userIds: [state.targetCmt!.writerId],
                    data: DataSource(
                        pushType: "postReply",
                        targetPage: "$mgzDetailPath?magazineId=$mgzId",
                        fromUserId: cmtWriter.userId),
                    noti: NotiSource(
                        title: "답글 알림",
                        body: "${cmtWriter.name}님이 당신의 댓글에 답글을 남겼어요")));
          }
          break;
        default:
          throw ArgumentError("Invalid Content Type In Comment Bloc");
      }
      state.commentController.clear();
      add(ShowPostCmtW(targetComment: null, showPostCmtWiget: false));
    });
  }
}
