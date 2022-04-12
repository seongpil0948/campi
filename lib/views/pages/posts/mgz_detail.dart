import 'package:campi/components/btn/index.dart';
import 'package:campi/components/inputs/index.dart';
import 'package:campi/components/noti/index.dart';
import 'package:campi/components/structs/comment/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/comment/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/modules/posts/mgz/index.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MgzDetailPage extends StatelessWidget {
  const MgzDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;

    Widget getBody(MgzState m) {
      return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            mat.Text(m.title, style: const TextStyle(color: Colors.black)),
            UserRow(userId: m.writerId, isCmc: false)
          ]),
          leading: IconButton(
              icon: const Icon(Icons.undo),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: BlocProvider(
            // create: (_) => CommentBloc(
            //     controller: TextEditingController()),
            create: (_) => CommentBloc(
                controller: TextEditingController(),
                mgzId: m.mgzId,
                fcm: context.read<AppBloc>().fcm,
                cmtWriter: context.watch<AppBloc>().state.user,
                postWriterId: m.writerId,
                contentType: ContentType.mgz),
            child: const MgzDetailW()),
      );
    }

    if (args.args['magazine'] != null) {
      final mgz = args.args['magazine'];
      return BlocProvider(
          create: (_) => MgzCubit.fromState(mgz), child: getBody(mgz));
    } else {
      return FutureBuilder<MgzState>(
          future: PostRepo.getMgzById(args.args['magazineId'][0] as String),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BlocProvider(
                  create: (_) => MgzCubit.fromState(snapshot.data!),
                  child: getBody(snapshot.data!));
            }
            return loadingIndicator;
          });
    }
  }
}

class MgzDetailW extends StatelessWidget {
  const MgzDetailW({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final mgz = context.watch<MgzCubit>();
    return PiBackToClose(
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: InkWell(
                onTap: () => context.read<CommentBloc>().add(
                    ShowPostCmtW(targetComment: null, showPostCmtWiget: false)),
                child: Column(
                  children: [
                    QuillEditor(
                      controller: QuillController(
                          document: mgz.state.content,
                          selection: const TextSelection.collapsed(offset: 0)),
                      scrollController: ScrollController(),
                      scrollable: true,
                      focusNode: FocusNode(),
                      autoFocus: true,
                      readOnly: true,
                      expands: false,
                      padding: const EdgeInsets.all(8),
                      showCursor: false,
                    ),
                    SizedBox(
                      width: s.width,
                      height: s.height / 11,
                      child: const MgzStatusRow(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 0),
                      child: CommentList(
                          commentStream: getCollection(
                                  c: Collections.comments,
                                  mgzId: mgz.state.mgzId)
                              .snapshots(),
                          mgzId: mgz.state.mgzId,
                          userId: context.watch<AppBloc>().state.user.userId),
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<CommentBloc, CommentState>(
                builder: (context, state) => state.showPostCmtW
                    ? const Positioned(
                        bottom: 30,
                        child: CommentPostW(),
                      )
                    : Container())
          ],
        ),
      ),
    );
  }
}

class MgzStatusRow extends StatelessWidget {
  const MgzStatusRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppBloc>();
    final s = MediaQuery.of(context).size;
    final navi = context.read<NavigationCubit>();
    return BlocBuilder<MgzCubit, MgzState>(
        buildWhen: ((previous, current) => previous.likeCnt != current.likeCnt),
        builder: (context, state) {
          final aleady = state.likeUserIds.contains(app.state.user.userId);
          return FutureBuilder<PiUser?>(
              future: UserRepo.getUserById(state.writerId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return loadingIndicator;
                return Row(children: [
                  IconTxtBtn(
                      onPressed: () => context
                          .read<MgzCubit>()
                          .onLike(app.state.user, app.fcm),
                      icon: Icon(
                          aleady
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          color: aleady ? Colors.red : null),
                      txt: mat.Text("${state.likeCnt}")),
                  IconButton(
                      onPressed: () {
                        context.read<CommentBloc>().add(ShowPostCmtW(
                            targetComment: null, showPostCmtWiget: true));
                      },
                      icon: const Icon(
                        Icons.mode_comment_outlined,
                      )),
                  const Spacer(),
                  if (app.state.user == snapshot.data!)
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: s.width / 7),
                      child: MoreSelect(
                          onDelete: () => context.read<MgzRUDBloc>().add(
                              PostDeleted(
                                  postId: state.mgzId, owner: snapshot.data!)),
                          onEdit: () =>
                              navi.push(mgzPostPath, {'magazine': state})),
                    )
                ]);
              });
        });
  }
}
