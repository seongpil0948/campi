import 'package:campi/views/router/config.dart';
import 'package:campi/views/router/stack.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PiRouteDelegator extends RouterDelegate<PiPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final NavigationCubit navi;
  PiRouteDelegator({required this.navi});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NavigationCubit, NavigationStack>(
        buildWhen: (previous, current) {
          print("In Navi Bloc Build When");
          return true;
        },
        builder: (context, stack) => Navigator(
            key: navigatorKey, pages: stack.pages, onPopPage: _onPopPage),
        listener: (context, stack) {
          print("In Navi Bloc Listen");
        });
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
    if (navi.canPop()) {
      navi.pop();
      return true;
    }
    return false;
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey();
}
