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
const mgzListPath = '/posts/mgz';

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
  rootPath: () => const MgzListPage(),
  splashPath: () => const SplashPage(),
  loginPath: () => const LoginPage(),
  mgzListPath: () => const MgzListPage(),
  mgzPostPath: () => const MgzPostPage(),
  feedPostPath: () => const FeedPostPage(),
  mgzDetailPath: () => const MgzDetailPage(),
  feedDetailPath: () => const FeedDetailPage(),
  // Un Implements ....
  storePath: () => const StorePage(),
  myPath: () => const MyPage(),
  storeDetailPath: () => const ProductDetailPage(),
  chatPath: () => const ChatPage(),
  chatRoomPath: () => const ChatRoomPage(),
};
