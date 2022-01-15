import 'package:campi/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MyApp.analytics.logAppOpen();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  RemoteConfig remoteConfig = RemoteConfig.instance;
  remoteConfig.setDefaults(<String, dynamic>{
    'welcome_message': 'this is the default welcome message',
    'feat1_enabled': false,
  });

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: 'Flutter Demo Home Page',
        analytics: analytics,
        observer: observer,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
  }) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  String email = '';
  String url = '';
  String name = '';
  @override
  void initState() {
    FirebaseCrashlytics.instance.log("SPSPSPSPSPSP APP Open");
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        FirebaseCrashlytics.instance.log('User is currently signed out!');
      } else {
        FirebaseCrashlytics.instance.log('User is signed in!');
      }
    });
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Email: $email  Name: $name PhotoURL: $url',
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseCrashlytics.instance
                    .recordError("my Errrorororororo", StackTrace.empty,
                        reason: 'a fatal error',
                        // Pass in 'fatal' argument
                        fatal: true);
                FirebaseCrashlytics.instance.crash();
              },
              child: const Text("!!Crash!!"),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  // Trigger the authentication flow
                  final GoogleSignInAccount? googleUser =
                      await GoogleSignIn().signIn();

                  // Obtain the auth details from the request
                  final GoogleSignInAuthentication? googleAuth =
                      await googleUser?.authentication;

                  // Create a new credential
                  final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth?.accessToken,
                    idToken: googleAuth?.idToken,
                  );
                  final authResult =
                      await auth.signInWithCredential(credential);
                  final user = authResult.user;
                  setState(() {
                    email = user!.email ?? "";
                    url = user.email ?? "";
                    name = user.displayName ?? "";
                  });
                } catch (e, s) {
                  FirebaseCrashlytics.instance
                      .log("=== LOGIN FAIL === $e \n Stack Trace :$s");
                }
              },
              child: const Text("!!구글 로그인!!"),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
