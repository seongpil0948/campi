import 'package:campi/utils/responsive_ratio.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          "assets/images/splash_back_${fileNumberByRatio(mq.devicePixelRatio)}.png",
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
