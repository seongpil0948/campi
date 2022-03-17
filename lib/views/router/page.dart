import 'package:campi/views/pages/chat/list.dart';
import 'package:campi/views/pages/chat/room.dart';
import 'package:campi/views/pages/common/login.dart';
import 'package:campi/views/pages/common/my.dart';
import 'package:campi/views/pages/common/splash.dart';
import 'package:campi/views/pages/common/unknown.dart';
import 'package:campi/views/pages/posts/feed_detail.dart';
import 'package:campi/views/pages/posts/feed_post.dart';
import 'package:campi/views/pages/posts/mgz_detail.dart';
import 'package:campi/views/pages/posts/mgz_post.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/pages/store/detail.dart';
import 'package:campi/views/pages/store/index.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

const rootPath = '/';
const myPath = '/my';
const splashPath = '/splash';
const loginPath = '/login';
const postListPath = '/posts/mgz';

const mgzPostPath = '/posts/mgz/post';
const feedPostPath = '/posts/feed/post';
const mgzDetailPath = '/posts/mgz/detail';
const feedDetailPath = '/posts/feed/detail';
const storePath = '/store';
const storeDetailPath = '/store/item/detail';
const chatPath = '/chat';
const chatRoomPath = '/chat/rooms';

MaterialPage wgetToPage(PiPageConfig config, Widget w) =>
    MaterialPage(arguments: config, child: w, name: config.name);

MaterialPage getPage(PiPageConfig config) =>
    wgetToPage(config, _routes[config.route]?.call() ?? const UnknownPage());

Map<String, Widget Function()> _routes = {
  rootPath: () => const PostListPage(key: ValueKey("PostListPage")),
  splashPath: () => const SplashPage(key: ValueKey("SplashPage")),
  loginPath: () => const LoginPage(key: ValueKey("LoginPage")),
  postListPath: () => const PostListPage(key: ValueKey("PostListPage")),
  mgzPostPath: () => const MgzPostPage(key: ValueKey("MagazinePostPage")),
  feedPostPath: () => const FeedPostPage(key: ValueKey("FeedPostPage")),
  mgzDetailPath: () => const MgzDetailPage(key: ValueKey("MagazineDetailPage")),
  feedDetailPath: () => const FeedDetailPage(key: ValueKey("FeedDetailPage")),
  // Un Implements ....
  storePath: () => const StorePage(key: ValueKey("StorePage")),
  myPath: () => const MyPage(key: ValueKey("MyPage")),
  storeDetailPath: () =>
      const ProductDetailPage(key: ValueKey("ProductDetailPage")),
  chatPath: () => const ChatPage(key: ValueKey("ChatPage")),
  chatRoomPath: () => const ChatRoomPage(key: ValueKey("ChatRoomPage")),
};
