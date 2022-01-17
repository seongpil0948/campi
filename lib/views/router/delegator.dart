import 'package:campi/modules/app/bloc/app_bloc.dart';
import 'package:campi/views/pages/common/login.dart';
import 'package:campi/views/pages/common/splash.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/router/path.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

// e.key = pageConfig Key
const backDisbles = ['/login', '/unknown', '/splash'];

class PiRouterDelegate extends RouterDelegate<PiPathConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  GlobalKey<NavigatorState> get navigatorKey => GlobalKey<NavigatorState>();

  List<Page> _pages = [];
  List<MaterialPage> get pages => List.unmodifiable(_pages);
  PiPathConfig get currPageConfig => _pages.last.arguments as PiPathConfig;

  List<Page> buildPages(BuildContext context) {
    final status = context.select((AppBloc bloc) => bloc.state.status);
    switch (status) {
      case AppStatus.splashed:
        _pushClearPages(splashPathConfig);
        break;
      case AppStatus.unauthenticated:
        _pushClearPages(loginPathConfig);
        break;
      case AppStatus.authenticated:
        _pushClearPages(defaultPage);
        break;
    }

    print("Build Pages");
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: buildPages(context),
      onPopPage: _onPopPage,
      onGenerateRoute: (settings) {
        print("===> onGenerateRoute : $settings");
        // return MaterialPageRoute(
        //     builder: (_) => const SplashPage(), settings: settings);
      },
    );
  }

  Widget _getPageW(PiPathConfig pageConfig) {
    // final shouldAddPage = _pages.isEmpty ||
    //     (_pages.last.arguments as PyPathConfig).uiCtgr != pageConfig.uiCtgr;

    switch (pageConfig.uiCtgr) {
      case Views.splashPage:
        return const SplashPage(key: ValueKey("Splash"));
      case Views.loginPage:
        return const LoginPage(key: ValueKey("Login"));
      case Views.postListPage:
        return const PostListPage(key: ValueKey("Feed"));

      default:
        return Container();
    }
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    print("In setNewRoutePath, Configure: $configuration");
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // returns false If the route can’t handle it internally
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // Otherwise, check to see if we can remove the top page
    // and remove the page from the list of pages.
    if (canPop()) {
      popRoute();
      return true;
    }
    return false;
  }

  bool canPop() => pages.length > 1;
  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last as MaterialPage);

      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(PiPathConfig pageConfig) {
    return MaterialPage(
        child: _getPageW(pageConfig),
        key: ValueKey(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

  void _addPageData(PiPathConfig pageConfig) {
    _pages.add(
      _createPage(pageConfig),
    );
  }

  void _removePage(MaterialPage page) {
    _pages.remove(page);
  }

  void _pushClearPages(PiPathConfig pageConfig) {
    _pages = [];
    _addPageData(pageConfig);
  }
}
