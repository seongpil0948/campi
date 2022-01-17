import 'package:campi/modules/auth/repos/auth.dart';
import 'package:campi/utils/responsive_ratio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context);
    final body2 = Theme.of(context).textTheme.overline;
    return Scaffold(
      body: Stack(children: [
        Image.asset(
          // background image
          "assets/images/splash_back_${fileNumberByRatio(mq.devicePixelRatio)}.png",
          fit: BoxFit.cover,
          height: mq.size.height,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo_w_2.png",
              width: mq.size.width / 2,
              height: mq.size.height / 15,
              fit: BoxFit.cover,
            ),
            VmarginContainer(
              mq: mq,
              w: Text("캠피 서비스 이용을 위해 SNS 로그인을 해주세요", style: body2),
            ),
            LoginButton(
              mq: mq,
              aImg: "assets/images/google_login.png",
            ),
            const SizedBox(height: 10),
            LoginButton(
              mq: mq,
              aImg: "assets/images/facebook_login.png",
            ),
          ],
        )
      ]),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
    required this.mq,
    required this.aImg,
  }) : super(key: key);

  final MediaQueryData mq;
  final String aImg;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => context.read<AuthRepo>().logInWithGoogle(),
        splashColor: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width / 7),
          child: Image.asset(aImg),
        ));
  }
}

class VmarginContainer extends StatelessWidget {
  const VmarginContainer({Key? key, required this.mq, required this.w})
      : super(key: key);

  final MediaQueryData mq;
  final Widget w;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30),
      child: w,
    );
  }
}
