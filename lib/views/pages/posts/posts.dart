import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => FeedBloc(
                context.read<SearchValBloc>(), context, defaultPostOrder)),
        BlocProvider(
            create: (context) => MgzBloc(
                context.read<SearchValBloc>(), context, defaultPostOrder))
      ],
      child: Piffold(
          body: PostListTab(thumbSize: ThumnailSize.medium),
          fButton: const PostingFab()),
    );
  }
}
