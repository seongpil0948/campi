import 'package:campi/components/inputs/text_controller.dart';
import 'package:campi/config/theme.dart';
import 'package:campi/firebase_options.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/repo.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/bloc_observer.dart';
import 'modules/common/fcm/repo.dart';

final appTheme = PiTheme();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAnalytics.instance.logAppOpen();
  FirebaseCrashlytics.instance.log("logAppOpen");
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  final prefs = await SharedPreferences.getInstance();
  final auth = AuthRepo(prefs: prefs);
  await auth.user.first;
  NavigationCubit navi;
  if (auth.currentUser.isEmpty) {
    navi = NavigationCubit([PiPageConfig(location: splashPath)]);
  } else {
    navi = NavigationCubit([PiPageConfig(location: rootPath)]);
  }

  await FcmRepo().initFcm();
  BlocOverrides.runZoned(
    () => runApp(CampingApp(navi: navi, auth: auth)),
    blocObserver: AppBlocObserver(),
  );
}

class CampingApp extends StatelessWidget {
  final NavigationCubit navi;
  final AuthRepo auth;
  const CampingApp({Key? key, required this.navi, required this.auth})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: auth,
      child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: navi),
            BlocProvider(create: (_) => AppBloc(authRepo: auth)),
            BlocProvider(create: (ctx) => SearchValBloc())
          ],
          child: MaterialApp.router(
            title: 'Camping & Picknic',
            theme: appTheme.lightTheme,
            darkTheme: appTheme.darkTheme,
            themeMode: appTheme.currentTheme,
            routeInformationParser: PiRouteParser(),
            routerDelegate: PiRouteDelegator(navi: navi),
          )),
    );
  }
}
