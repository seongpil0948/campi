import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/layout/piffold.dart';
import 'package:campi/modules/posts/bloc/post.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:campi/modules/posts/models/mgz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsListView extends StatefulWidget {
  const PostsListView({Key? key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    const txtSty = TextStyle(color: Colors.black);
    return const Piffold(
        body: Center(child: Text("I Am Postings Page", style: txtSty)),
        // body: BlocBuilder<PostBloc, PostState>(
        //   builder: (context, state) {
        //     switch (state.status) {
        //       case PostStatus.failure:
        //         return const Center(
        //             child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
        //       case PostStatus.success:
        //         if (state.posts.isEmpty) {
        //           return const Center(
        //               child: Text(
        //             'no posts',
        //             style: txtSty,
        //           ));
        //         }

        //         return ListView.builder(
        //           itemBuilder: (BuildContext context, int index) {
        //             return index >= state.posts.length
        //                 ? const BottomLoader()
        //                 : PostListItem(post: state.posts[index]);
        //           },
        //           itemCount: state.hasReachedMax
        //               ? state.posts.length
        //               : state.posts.length + 1,
        //           controller: _scrollController,
        //         );
        //       default:
        //         return const Center(child: CircularProgressIndicator());
        //     }
        //   },
        // ),
        fButton: PostingFab());
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}

class PostListItem extends StatelessWidget {
  const PostListItem({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.id}', style: textTheme.caption),
        title: Text(post.title),
        isThreeLine: true,
        subtitle: Text(post.body),
        dense: true,
      ),
    );
  }
}
