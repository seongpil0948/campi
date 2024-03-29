part of './index.dart';

final naviKey = GlobalKey<NavigatorState>();

class PiRouteDelegator extends RouterDelegate<PiPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final NavigationCubit navi;
  PiRouteDelegator({required this.navi});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationStack>(
      builder: (context, stack) => Navigator(
          key: navigatorKey, pages: stack.pages, onPopPage: _onPopPage),
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    debugPrint("setNewRoutePath: $configuration");
  }

  bool _onPopPage(Route<dynamic> route, result) {
    // returns false If the route can’t handle it internally
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // Otherwise, check to see if we can remove the top page
    // and remove the page from the list of pages.
    if (navi.canPop()) {
      navi.pop();
      return true;
    }
    return false;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => naviKey;
}
