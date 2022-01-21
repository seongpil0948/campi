import 'package:campi/config/theme.dart';
import 'package:campi/firebase_options.dart';
import 'package:campi/views/router/config.dart';
import 'package:campi/views/router/delegate.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/parser.dart';
import 'package:campi/views/router/state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final appTheme = PiTheme();
final navi = NavigationCubit([PiPageConfig(location: postListPath)]);

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
    return BlocProvider.value(
        value: navi,
        child: MaterialApp.router(
          title: 'Camping & Picknic',
          theme: appTheme.lightTheme,
          darkTheme: appTheme.darkTheme,
          themeMode: appTheme.currentTheme,
          routeInformationParser: PiRouteParser(),
          routerDelegate: PiRouteDelegator(navi: navi),
        ));
  }
}
