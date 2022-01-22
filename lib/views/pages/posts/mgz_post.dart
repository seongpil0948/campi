import 'dart:io';

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
    return BlocProvider(create: (_) => MgzCubit(), child: MgzPostW());
  }
}

class MgzPostW extends StatelessWidget {
  MgzPostW({Key? key}) : super(key: key);

  Future<String> _assetPickCallback(File file, bool isVideo, PiUser u) async {
    final f = PiFile.file(
        file: file, ftype: isVideo ? PiFileType.video : PiFileType.image);
    final uploaded = await uploadFilePathsToFirebase(
        f: f, path: 'mgzs/${u.userId}/${f.fName}');
    return uploaded!.url!;
  }

  @override
  Widget build(BuildContext context) {
    final _user = context.select((AppBloc bloc) => bloc.state.user);
    context.read<MgzCubit>().fillId(_user.userId);
    Future<String> _onImagePickCallback(File file) async {
      return await _assetPickCallback(file, false, _user);
    }

    Future<String> _onVideoPickCallback(File file) async {
      return await _assetPickCallback(file, true, _user);
    }

    final _controller = q.QuillController.basic();
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
      showHorizontalRule: false,
      showInlineCode: false,
      showItalicButton: false,
      showQuote: false,
      showStrikeThrough: false,
      showUnderLineButton: false,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            toolbar,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final mediaUrl = docCheckMedia(_controller.document, checkImg: true);
          if (mediaUrl == null) {
            showDialog(
                context: context,
                builder: (BuildContext nestedCtx) {
                  return const AlertDialog(content: Text("이미지를 하나이상 첨부 해주세요."));
                });
            return;
          }
          final c = context.read<MgzCubit>();
          c.changeDoc(_controller.document);
          c.posting(context);
        },
        child: const Text("제출하기"),
      ),
    );
  }
}
