import 'dart:async';

import 'package:campi/views/router/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: const ValueKey("Splash Page"));

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        BlocProvider.of<NavigationCubit>(context).clearAndPush(loginPath);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SplashW(mq: mq);
  }
}

class SplashW extends StatelessWidget {
  const SplashW({
    Key? key,
    required this.mq,
  }) : super(key: key);

  final MediaQueryData mq;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          "assets/images/splash_back_1.png",
          fit: BoxFit.cover,
          height: mq.size.height,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width / 3.2),
          child: Image.asset("assets/images/splash_fore.png"),
        ),
      ],
    );
  }
}
