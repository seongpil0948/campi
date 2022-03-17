// ignore_for_file: avoid_print
import 'package:bloc/bloc.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';

class AppBlocObserver extends BlocObserver {
  // @override
  // void onEvent(Bloc bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   debugPrint("\n BLOC Event => $event");
  // }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    final msg =
        "ERROR has Occured at Bloc: $bloc, Error: $error,  StackTrace: $stackTrace ";
    FirebaseCrashlytics.instance
        .recordError(error, stackTrace, reason: msg, printDetails: true);
    debugPrint(error.toString());
    super.onError(bloc, error, stackTrace);
  }

  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   debugPrint("\n BLOC Ttransition => $transition");
  // }
}
