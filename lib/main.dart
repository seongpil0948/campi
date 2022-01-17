import 'package:campi/firebase_options.dart';
import 'package:campi/modules/app/bloc/app_bloc.dart';
import 'package:campi/modules/auth/repos/auth.dart';
import 'package:campi/views/router/delegator.dart';
import 'package:campi/views/router/parser.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/app/bloc_observer.dart';

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
  final authRepo = AuthRepo();
  await authRepo.user.first;
  BlocOverrides.runZoned(
    () => runApp(CampingApp(authRepo: authRepo)),
    blocObserver: AppBlocObserver(),
  );
}

class CampingApp extends StatelessWidget {
  const CampingApp({Key? key, required this.authRepo}) : super(key: key);
  final AuthRepo authRepo;
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: authRepo,
        child: BlocProvider(
            create: (_) => AppBloc(authRepo: authRepo),
            child: MaterialApp.router(
                title: 'Camping & Picknic',
                routeInformationParser: PiPathParser(),
                routerDelegate: PiRouterDelegate())));
  }
}
