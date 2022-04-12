import 'package:campi/components/btn/index.dart';
import 'package:campi/components/structs/posts/feed/index.dart';
import 'package:campi/components/structs/posts/index.dart';
import 'package:campi/config/index.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/views/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navi = context.read<NavigationCubit>();
    final search = context.read<SearchValBloc>();
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) => snapshot.hasData
            ? MultiBlocProvider(
                providers: [
                    BlocProvider(
                        create: (context) => FeedRUDBloc(
                            sBloc: search,
                            orderBy: orderFromStr(
                                orderBy: snapshot.data!
                                        .getString(prefFeedOrderKey) ??
                                    defaultPostOrderStr),
                            navi: navi)),
                    BlocProvider(
                        create: (context) => MgzRUDBloc(
                            sBloc: search,
                            orderBy: orderFromStr(
                                orderBy: snapshot.data!
                                        .getString(prefFeedOrderKey) ??
                                    defaultPostOrderStr),
                            navi: navi))
                  ],
                child: Piffold(
                    body: PostListTab(thumbSize: ThumnailSize.medium),
                    fButton: const PostingFab()))
            : loadingIndicator);
  }
}
