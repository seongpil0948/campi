import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/components/btn/fabs.dart';
import 'package:campi/views/pages/layouts/piffold.dart';
import 'package:campi/components/structs/feed/feed.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/bloc/post.dart';
import 'package:campi/modules/posts/events.dart';
import 'package:campi/modules/posts/feed/state.dart';
import 'package:campi/modules/posts/feed/utils.dart';
import 'package:campi/modules/posts/mgz/cubit.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PostsListView extends StatefulWidget {
  const PostsListView({Key? key}) : super(key: key);

  @override
  _PostsListState createState() => _PostsListState();
}

class _PostsListState extends State<PostsListView> {
  final _scrollController = ScrollController();
  final _msgInst = FirebaseMessaging.instance;
  final bloc = PostBloc();

  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    _msgInst.getToken().then((value) => debugPrint("Msg Token : $value"));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
    });
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: bloc, child: PostListW(scrollController: _scrollController));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) bloc.add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}

class PostListW extends StatelessWidget {
  const PostListW({
    Key? key,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    const txtSty = TextStyle(color: Colors.black);
    return Piffold(
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            switch (state.status) {
              case PostStatus.failure:
                return const Center(
                    child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
              case PostStatus.success:
                if (state.posts.isEmpty) {
                  return const Center(
                      child: Text(
                    'no posts',
                    style: txtSty,
                  ));
                }

                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    // return index >= state.posts.length
                    // ? const BottomLoader()
                    // : PostListItem(post: state.posts[index]);
                    return PostListItem(post: state.posts[index]);
                  },
                  itemCount: state.posts.length,
                  // itemCount: state.hasReachedMax
                  // ? state.posts.length
                  // : state.posts.length + 1,
                  controller: _scrollController,
                );
              default:
                return Container();
            }
          },
        ),
        fButton: const PostingFab());
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

  final dynamic post;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    if (post is FeedState) {
      return FeedW(mq: mq, f: post as FeedState);
    } else if (post is MgzState) {
      return MgzW(mgz: post as MgzState);
    } else {
      throw ("Un expected Post Item");
    }
  }
}

class FeedW extends StatelessWidget {
  const FeedW({Key? key, required this.mq, required this.f}) : super(key: key);

  final MediaQueryData mq;
  final FeedState f;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object?>>(
        future: Future.wait([imgsOfFeed(f: f, limit: 1), f.writer]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Container(
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 30),
                    child: const CircularProgressIndicator()));
          }
          final imgs = snapshot.data![0] as List<PiFile>;
          final writer = snapshot.data![1] as PiUser?;
          return Container(
            margin: const EdgeInsets.all(20),
            height: mq.size.height / 3,
            child: writer != null
                ? FeedThumnail(
                    mq: mq,
                    img: imgs.first,
                    feedInfo: f,
                    tSize: ThumnailSize.medium,
                    writer: writer)
                : Container(),
          );
        });
  }
}

class MgzW extends StatelessWidget {
  const MgzW({
    Key? key,
    required this.mgz,
  }) : super(key: key);

  final MgzState mgz;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaUrl = docCheckMedia(mgz.content, checkImg: true);
    return mediaUrl != null
        ? InkWell(
            onTap: () {
              context
                  .read<NavigationCubit>()
                  .push(mgzDetailPath, {'magazine': mgz});
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    width: size.width,
                    height: size.height / 3),
              ),
            ))
        : Container();
  }
}
