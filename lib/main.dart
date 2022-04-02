import 'package:campi/config/index.dart';
import 'package:campi/firebase_options.dart';
import 'package:campi/modules/app/index.dart';
import 'package:campi/modules/auth/index.dart';
import 'package:campi/modules/common/index.dart';
import 'package:campi/modules/posts/index.dart';
import 'package:campi/views/router/index.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modules/bloc_observer.dart';

final appTheme = PiTheme();
final searchBloc = SearchValBloc();
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
  if (auth.cachedUser.isEmpty) {
    navi = NavigationCubit([PiPageConfig(location: splashPath)]);
  } else {
    navi = NavigationCubit([PiPageConfig(location: rootPath)]);
  }

  final fcm = FcmRepo(navi: navi);
  await fcm.initFcm();
  BlocOverrides.runZoned(
    () => runApp(CampingApp(navi: navi, auth: auth, fcm: fcm)),
    blocObserver: AppBlocObserver(),
  );
}

class CampingApp extends StatelessWidget {
  final NavigationCubit navi;
  final AuthRepo auth;
  final FcmRepo fcm;
  const CampingApp(
      {Key? key, required this.navi, required this.auth, required this.fcm})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: auth,
      child: FutureBuilder<List>(
          future: Future.wait([SharedPreferences.getInstance()]),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              final pref = snapshot.data![0] as SharedPreferences;
              return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                        create: (context) => FeedBloc(
                            sBloc: searchBloc,
                            orderBy: orderFromStr(
                                orderBy: pref.getString(prefFeedOrderKey) ??
                                    defaultPostOrderStr),
                            navi: navi)),
                    BlocProvider(
                        create: (context) => MgzBloc(
                            sBloc: searchBloc,
                            orderBy: orderFromStr(
                                orderBy: pref.getString(prefFeedOrderKey) ??
                                    defaultPostOrderStr),
                            navi: navi)),
                    BlocProvider.value(value: navi),
                    BlocProvider(
                        create: (_) =>
                            AppBloc(authRepo: auth, fcm: fcm, navi: navi)),
                    BlocProvider(create: (context) => searchBloc)
                  ],
                  child: MaterialApp.router(
                    title: 'Camping & Picknic',
                    theme: appTheme.lightTheme,
                    darkTheme: appTheme.darkTheme,
                    themeMode: appTheme.currentTheme,
                    routeInformationParser: PiRouteParser(),
                    routerDelegate: PiRouteDelegator(navi: navi),
                  ));
            } else {
              return loadingIndicator;
            }
          }),
    );
  }
}
