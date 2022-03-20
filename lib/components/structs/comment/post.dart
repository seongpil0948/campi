import 'package:campi/components/btn/avatar.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentPostW extends StatelessWidget {
  const CommentPostW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      width: mq.size.width - 40,
      margin: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.black, width: 0.0),
        borderRadius: const BorderRadius.all(Radius.circular(60)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Expanded(
              flex: 1,
              child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: BlocBuilder<AppBloc, AppState>(
                      builder: (context, appState) {
                    return BlocBuilder<CommentBloc, CommentState>(
                        builder: (context, state) =>
                            GoMyAvatar(radius: 17, user: appState.user));
                  }))),
          const Expanded(flex: 6, child: CmtPostTxtField()),
        ],
      ),
    );
  }
}

class CmtPostTxtField extends StatelessWidget {
  const CmtPostTxtField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cmtBloc = context.watch<CommentBloc>();
    final target = cmtBloc.state.targetCmt;
    TextField txtFieldW(String? labelTxt) => TextField(
        controller: cmtBloc.state.commentController,
        minLines: 1,
        maxLines: 12,
        decoration: InputDecoration(
          labelText: labelTxt,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
              onPressed: () => cmtBloc.add(SubmitCmt()),
              icon: const Icon(Icons.send),
              iconSize: 18,
              color: Theme.of(context).primaryColor),
        ),
        onSubmitted: (txt) => cmtBloc.add(SubmitCmt()));
    return target == null
        ? txtFieldW(null)
        : FutureBuilder<PiUser>(
            future: target.writer,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return txtFieldW(snapshot.data!.name);
              }
              return const Center(child: CircularProgressIndicator());
            });
  }
}
