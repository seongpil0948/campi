import 'package:campi/config/theme.dart';
import 'package:campi/firebase_options.dart';
import 'package:campi/views/pages/posts/posts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

final appTheme = PiTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance.logAppOpen();
  FirebaseCrashlytics.instance.log("logAppOpen");
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // FirebaseStorage storage = FirebaseStorage.instance;
  // RemoteConfig remoteConfig = RemoteConfig.instance;
  // remoteConfig.setDefaults(<String, dynamic>{
  //   'welcome_message': 'this is the default welcome message',
  //   'feat1_enabled': false,
  // });
  runApp(const CampingApp());
}

class CampingApp extends StatelessWidget {
  const CampingApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        title: 'Camping & Picknic',
        // theme: appTheme.lightTheme,
        // darkTheme: appTheme.darkTheme,
        // themeMode: appTheme.currentTheme,
        routeInformationParser: PiRouteParser(),
        routerDelegate: PiRouteDelegator());
  }
}

class PiRouteParser extends RouteInformationParser<PiPageConfig> {
  @override
  Future<PiPageConfig> parseRouteInformation(
      RouteInformation routeInformation) async {
    return PiPageConfig(
        path: routeInformation.location ?? "", state: routeInformation.state);
  }
}

class PiRouteDelegator extends RouterDelegate<PiPageConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final List<Page> _pages = [
    const MaterialPage(
        child: PostsListView(key: ValueKey("Post Lists Keys")),
        key: ValueKey("Post Lists Page"),
        name: "postlist",
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

class PiPageConfig {
  String path;
  Object? state;

  PiPageConfig({required this.path, required this.state});
}
