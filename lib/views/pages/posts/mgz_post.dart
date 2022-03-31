import 'dart:io';
import 'package:campi/components/noti/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/mgz/index.dart';
import 'package:campi/utils/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
// ignore: implementation_imports
import 'package:flutter_quill/src/widgets/embeds/default_embed_builder.dart'
    show defaultEmbedBuilder;

import 'package:tuple/tuple.dart';

class MgzPostPage extends StatelessWidget {
  const MgzPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    final _user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
        create: (_) => args.args['magazine'] != null
            ? MgzCubit.fromState(args.args['magazine'] as MgzState)
            : MgzCubit(writerId: _user.userId),
        child: MgzPostW(user: _user));
  }
}

class MgzPostW extends StatefulWidget {
  final PiUser user;
  const MgzPostW({Key? key, required this.user}) : super(key: key);

  @override
  _MgzPostWState createState() => _MgzPostWState();
}

class _MgzPostWState extends State<MgzPostW> {
  late TextEditingController _titleContoller;
  late QuillController _controller;
  @override
  void initState() {
    final bloc = context.read<MgzCubit>();
    _titleContoller = TextEditingController(text: bloc.state.title);
    _controller = QuillController(
        document: bloc.state.content,
        selection: const TextSelection(baseOffset: 0, extentOffset: 0));
    super.initState();
  }

  @override
  void dispose() {
    _titleContoller.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<String> _assetPickCallback(File file, bool isVideo, PiUser u) async {
    final f = PiFile.file(
        file: file, ftype: isVideo ? PiFileType.video : PiFileType.image);
    final uploaded = await uploadFilePathsToFirebase(
        f: f, path: 'mgzs/${u.userId}/${f.fName}');
    return uploaded!.url!;
  }

  @override
  Widget build(BuildContext context) {
    Future<String> _onImagePickCallback(File file) async {
      return await _assetPickCallback(file, false, widget.user);
    }

    Future<String> _onVideoPickCallback(File file) async {
      return await _assetPickCallback(file, true, widget.user);
    }

    final FocusNode _focusNode = FocusNode();
    final quillEditor = QuillEditor(
        controller: _controller,
        locale: const Locale("ko"),
        scrollController: ScrollController(),
        scrollable: false,
        focusNode: _focusNode,
        autoFocus: true,
        readOnly: false,
        placeholder: '내용을 입력 해주세요.',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: DefaultStyles(
          h1: DefaultTextBlockStyle(
              const TextStyle(
                fontSize: 32,
                color: Colors.black,
                height: 1.15,
                fontWeight: FontWeight.w300,
              ),
              const Tuple2(16, 0),
              const Tuple2(0, 0),
              null),
          sizeSmall: const TextStyle(fontSize: 12),
        ),
        embedBuilder: (context, controller, node, readOnly) {
          var widget = defaultEmbedBuilder(context, controller, node, readOnly);
          if (widget is GestureDetector) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: widget.child ?? Container(),
            );
          }
          return widget;
        });

    // quillEditor.embedBuilder., defaultEmbedBuilder
    var toolbar = QuillToolbar.basic(
        locale: const Locale("ko"),
        controller: _controller,
        onImagePickCallback: _onImagePickCallback,
        onVideoPickCallback: _onVideoPickCallback,
        toolbarSectionSpacing: 1,
        showCameraButton: false,
        showCodeBlock: false,
        showDividers: false,
        showStrikeThrough: false,
        showSmallButton: true,
        showAlignmentButtons: true,
        showListNumbers: false,
        multiRowsDisplay: false);
    return SafeArea(
      // bottom: false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size(double.infinity, MediaQuery.of(context).size.height / 7),
          child: Column(
            children: [_TitleField(titleContoller: _titleContoller), toolbar],
          ),
        ),
        body: PiBackToClose(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: quillEditor,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final mediaUrl =
                docCheckMedia(_controller.document, checkImg: true);
            if (mediaUrl == null) {
              oneMoreImg(context);
              return;
            }
            final c = context.read<MgzCubit>();
            c.changeDoc(_titleContoller.text, _controller.document);
            c.posting(context);
            widget.user.mgzIds.add(c.state.mgzId);
            widget.user.update();
            context.read<AppBloc>().fcm.sendPushMessage(
                source: PushSource(
                    tokens: [],
                    userIds: widget.user.followers,
                    data: DataSource(
                        pushType: "postMgz",
                        targetPage:
                            "$mgzDetailPath?magazineId=${c.state.mgzId}"),
                    noti: NotiSource(
                        title: "캠핑 SNS 좋아요 알림",
                        body: "${widget.user.name}님이 캠핑 포스팅 게시글을 올렸어요!")));
          },
          child: const mat.Text("게시"),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    Key? key,
    required TextEditingController titleContoller,
  })  : _titleContoller = titleContoller,
        super(key: key);

  final TextEditingController _titleContoller;

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 0.3, color: Theme.of(context).primaryColor)),
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding:
                const EdgeInsets.only(left: 15, bottom: 11, top: 0, right: 15),
            label: mat.Text("제목을 입력 해주세요..",
                style: TextStyle(color: Theme.of(context).cardColor))),
        controller: _titleContoller);
  }
}
