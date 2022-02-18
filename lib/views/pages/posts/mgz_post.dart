import 'dart:io';

import 'package:campi/components/signs/files.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/common/upload_file.dart';
import 'package:campi/modules/posts/mgz/cubit.dart';
import 'package:campi/utils/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as q;
import 'package:tuple/tuple.dart';

class MgzPostPage extends StatelessWidget {
  const MgzPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocProvider(
        create: (_) => MgzCubit(_user.userId), child: MgzPostW(user: _user));
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
  late q.QuillController _controller;
  @override
  void initState() {
    _titleContoller = TextEditingController();
    _controller = q.QuillController.basic();
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
    final mq = MediaQuery.of(context);
    Future<String> _onImagePickCallback(File file) async {
      return await _assetPickCallback(file, false, widget.user);
    }

    Future<String> _onVideoPickCallback(File file) async {
      return await _assetPickCallback(file, true, widget.user);
    }

    final FocusNode _focusNode = FocusNode();
    final quillEditor = q.QuillEditor(
        controller: _controller,
        scrollController: ScrollController(),
        scrollable: true,
        focusNode: _focusNode,
        autoFocus: false,
        readOnly: false,
        placeholder: '내용을 입력 해주세요.',
        expands: false,
        padding: EdgeInsets.zero,
        customStyles: q.DefaultStyles(
          h1: q.DefaultTextBlockStyle(
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
        ));
    var toolbar = q.QuillToolbar.basic(
      locale: const Locale("ko"),
      controller: _controller,
      onImagePickCallback: _onImagePickCallback,
      onVideoPickCallback: _onVideoPickCallback,
      showAlignmentButtons: false,
      showCodeBlock: false,
      showDividers: false,
      showInlineCode: false,
      showItalicButton: false,
      showQuote: false,
      showStrikeThrough: false,
      showUnderLineButton: false,
    );

    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: toolbar,
        body: SingleChildScrollView(
          child: SizedBox(
            height: mq.size.height + 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _TitleField(titleContoller: _titleContoller),
                Expanded(
                  flex: 10,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: quillEditor,
                  ),
                ),
              ],
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
          },
          child: const Text("제출하기"),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: TextField(
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.3, color: Theme.of(context).primaryColor)),
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.only(
                  left: 15, bottom: 11, top: 11, right: 15),
              label: Text("제목을 입력 해..주세요",
                  style: TextStyle(color: Theme.of(context).cardColor))),
          controller: _titleContoller),
    );
  }
}
