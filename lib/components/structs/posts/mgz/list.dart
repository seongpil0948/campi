import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/mgz/thumnail.dart';
import 'package:campi/modules/posts/bloc/post.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MgzListW extends StatelessWidget {
  const MgzListW({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PostListTab widget;

  @override
  Widget build(BuildContext context) {
    final txtSty = Theme.of(context).textTheme.bodyText2;
    return BlocBuilder<MgzBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            return Center(child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
          case PostStatus.success:
            if (state.posts.isEmpty) {
              return Center(
                  child: Text(
                'no posts',
                style: txtSty,
              ));
            }

            return ListView.builder(
              // FIXME: argument as thumnail size
              // return FeedW(mq: mq, f: post as FeedState);
              itemBuilder: (BuildContext context, int index) => MgzThumnail(
                  mgz: state.posts[index] as MgzState,
                  tSize: ThumnailSize.medium),
              itemCount: state.posts.length,
              controller: widget.scrollController,
            );
          default:
            return Container();
        }
      },
    );
  }
}
