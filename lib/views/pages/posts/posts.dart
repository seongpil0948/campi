import 'package:campi/components/btn/fabs.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/components/structs/posts/list.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PostKind { feed, mgz }

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => FeedBloc(
                            context.read<SearchValBloc>(),
                            context,
                            orderFromStr(
                                orderBy: snapshot.data!
                                        .getString(prefFeedOrderKey) ??
                                    defaultPostOrderStr))),
                    BlocProvider(
                        create: (context) => MgzBloc(
                            context.read<SearchValBloc>(),
                            context,
                            orderFromStr(
                                orderBy:
                                    snapshot.data!.getString(prefMgzOrderKey) ??
                                        defaultPostOrderStr)))
                  ],
                  child: Piffold(
                      body: PostListTab(thumbSize: ThumnailSize.medium),
                      fButton: const PostingFab()),
                )
              : Container();
        });
  }
}
