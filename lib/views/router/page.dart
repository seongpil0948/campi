import 'package:campi/views/pages/common/login.dart';
import 'package:campi/views/pages/common/splash.dart';
import 'package:campi/views/pages/common/unknown.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

const splashPath = '/splash';
const loginPath = '/login';
const postListPath = '/post/list';

MaterialPage wgetToPage(PiPageConfig config, Widget w) =>
    MaterialPage(arguments: config.args, child: w, name: config.name);

MaterialPage getPage(PiPageConfig config) =>
    wgetToPage(config, _routes[config.route]?.call() ?? const UnknownPage());

Map<String, Widget Function()> _routes = {
  splashPath: () => const SplashPage(),
  loginPath: () => const LoginPage(),
  postListPath: () => const PostsListView(),
};
