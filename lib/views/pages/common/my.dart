import 'package:campi/components/btn/avatar.dart';
import 'package:campi/components/btn/follow.dart';
import 'package:campi/components/noti/snacks.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/auth/user_repo.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/router/config.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final selectedUser = arg.args['selectedUser'] as PiUser;
    final body = FutureBuilder<PostsUser>(
      future: getPostsUser(context: context, selectedUser: selectedUser),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final targetUser = snapshot.data!;
        return _MyPageW(currUser: targetUser);
      },
    );
    return Scaffold(
        // drawer: const PiDrawer(),
        body: PiBackToClose(child: body));
  }
}

class _MyPageW extends StatelessWidget {
  const _MyPageW({
    Key? key,
    required PostsUser currUser,
  })  : targetUser = currUser,
        super(key: key);

  final PostsUser targetUser;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(children: [
        _MyProfileInfo(targetUser: targetUser),
        Positioned(
            top: 50,
            right: 25,
            child: TextButton(
              child: Text("로그아웃", style: Theme.of(context).textTheme.bodyText1),
              onPressed: () async {
                await context.read<AuthRepo>().logOut();
                context.read<NavigationCubit>().push(loginPath);
              },
            ))
      ]),
      Expanded(
          child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => FeedBloc(
                            context.read<SearchValBloc>(),
                            context,
                            defaultPostOrder)),
                    BlocProvider(
                        create: (context) => MgzBloc(
                            context.read<SearchValBloc>(),
                            context,
                            defaultPostOrder))
                  ],
                  child: PostListTab(
                      thumbSize: ThumnailSize.small, targetUser: targetUser))))
    ]);
  }
}

class _MyProfileInfo extends StatelessWidget {
  const _MyProfileInfo({
    Key? key,
    required this.targetUser,
  }) : super(key: key);

  final PostsUser targetUser;

  @override
  Widget build(BuildContext context) {
    final mSize = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: targetUser.userStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = PiUser.fromSnap(snapshot);
            return SizedBox(
              height: mSize.height / 2.3,
              width: mSize.width,
              child: Stack(children: [
                Image.asset("assets/images/splash_back_1.png",
                    width: mSize.width, fit: BoxFit.cover),
                Opacity(
                    opacity: 0.4,
                    child: Container(color: Theme.of(context).primaryColor)),
                SizedBox(
                  width: mSize.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      PiEditAvatar(radius: 40, user: user),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("@${user.uId}",
                                style: Theme.of(context).textTheme.bodyText1),
                            const SizedBox(width: 5),
                            FollowBtn(targetUser: user)
                          ],
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          width: mSize.width / 1.3,
                          child: UserSnsInfo(user: user)),
                      SizedBox(
                          width: mSize.width / 1.3,
                          child: _UserDesc(user: user))
                    ],
                  ),
                )
              ]),
            );
          }
          return loadingIndicator;
        });
  }
}

class _UserDesc extends StatefulWidget {
  final PiUser user;
  const _UserDesc({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  __UserDescState createState() => __UserDescState();
}

class __UserDescState extends State<_UserDesc> {
  bool editMode = false;
  late final TextEditingController _controller;
  FocusNode descFocusNode = FocusNode();
  @override
  void initState() {
    _controller = TextEditingController(text: widget.user.desc);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = context.read<AppBloc>().state.user.imYou(widget.user);
    final T = Theme.of(context);
    final activeBorder = Theme.of(context)
        .inputDecorationTheme
        .focusedBorder!
        .copyWith(borderSide: const BorderSide(color: Colors.black));
    return Column(
      children: [
        TextField(
            focusNode: descFocusNode,
            textAlign: TextAlign.center,
            textAlignVertical: TextAlignVertical.center,
            style: editMode ? T.textTheme.bodyText2 : T.textTheme.bodyText1,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: editMode,
                focusedBorder:
                    editMode == true ? activeBorder : InputBorder.none,
                enabledBorder:
                    editMode == true ? activeBorder : InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none),
            readOnly: !editMode,
            maxLines: 1,
            controller: _controller),
        if (isMe)
          ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () async {
                if (!isMe) return;
                setState(() {
                  editMode = !editMode;
                });
                if (editMode == false) {
                  widget.user.desc = _controller.text;
                  await widget.user.update();
                } else {
                  descFocusNode.requestFocus();
                }
              },
              child: editMode
                  ? Text("소개글 제출",
                      style:
                          T.textTheme.caption!.copyWith(color: T.primaryColor))
                  : Text("소개글 편집",
                      style:
                          T.textTheme.caption!.copyWith(color: T.primaryColor)))
      ],
    );
  }
}
