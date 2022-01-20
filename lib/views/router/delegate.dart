import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class PiRouteDelegator extends RouterDelegate<PiPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<Page> _pages = [
    const MaterialPage(
        child: PostsListView(key: ValueKey("Post Lists View")),
        key: ValueKey("Post Lists Page"),
        arguments: {})
  ];
  List<Page> get pages => List.unmodifiable(_pages);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: _onPopPage,
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    print("setNewRoutePath: $configuration");
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
      pop();
      return true;
    }
    return false;
  }

  bool canPop() => pages.length > 1;
  void pop() {
    if (canPop()) {
      pages.remove(_pages.last);
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();
}
