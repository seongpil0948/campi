import 'package:campi/views/pages/common/login.dart';
import 'package:campi/views/pages/common/splash.dart';
import 'package:campi/views/pages/common/unknown.dart';
import 'package:campi/views/pages/posts/feed_detail.dart';
import 'package:campi/views/pages/posts/feed_post.dart';
import 'package:campi/views/pages/posts/mgz_detail.dart';
import 'package:campi/views/pages/posts/mgz_post.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

const rootPath = '/';
const splashPath = '/splash';
const loginPath = '/login';
const postListPath = '/post/list';
const mgzPostPath = '/post/mgz';
const feedPostPath = '/post/feed';
const mgzDetailPath = '/post/detail/mgz';
const feedDetailPath = '/post/detail/feed';

MaterialPage wgetToPage(PiPageConfig config, Widget w) =>
    MaterialPage(arguments: config, child: w, name: config.name);

MaterialPage getPage(PiPageConfig config) =>
    wgetToPage(config, _routes[config.route]?.call() ?? const UnknownPage());

Map<String, Widget Function()> _routes = {
  rootPath: () => const PostsListView(),
  splashPath: () => const SplashPage(),
  loginPath: () => const LoginPage(),
  postListPath: () => const PostsListView(),
  mgzPostPath: () => const MgzPostPage(),
  feedPostPath: () => const FeedPostPage(),
  mgzDetailPath: () => const MgzDetailPage(),
  feedDetailPath: () => const FeedDetailPage(),
};
