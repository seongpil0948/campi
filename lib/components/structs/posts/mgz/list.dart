import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/components/structs/posts/mgz/thumnail.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/state.dart';
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
    return BlocBuilder<PostBloc, PostState>(
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

class GridMgzs extends StatelessWidget {
  const GridMgzs({
    Key? key,
    required this.mgzs,
  }) : super(key: key);

  final List<MgzState> mgzs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: mgzs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) =>
            MgzThumnail(mgz: mgzs[idx], tSize: ThumnailSize.small));
  }
}
