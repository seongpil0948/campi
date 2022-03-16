import 'package:campi/components/noti/snacks.dart';
import 'package:campi/modules/auth/login/cubit.dart';
import 'package:campi/modules/auth/login/state.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/utils/responsive_ratio.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

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
          width: mq.size.width,
        ),
        BlocProvider(
            create: (_) => LoginCubit(context.read<AuthRepo>()),
            child: PiBackToClose(child: LoginW(mq: mq, body2: body2)))
      ]),
    );
  }
}

class LoginW extends StatelessWidget {
  const LoginW({
    Key? key,
    required this.mq,
    required this.body2,
  }) : super(key: key);

  final MediaQueryData mq;
  final TextStyle? body2;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Authentication Failure'),
                ),
              );
          } else if (state.status.isSubmissionSuccess) {
            context.read<NavigationCubit>().clearAndPush(rootPath);
          }
        },
        child: Column(
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
            InkWell(
                onTap: () => context.read<LoginCubit>().logInWithGoogle(),
                child: LoginButton(
                  mq: mq,
                  aImg: "assets/images/google_login.png",
                ))
            // const SizedBox(height: 10),
            // InkWell(
            //     onTap: () {},
            //     child: LoginButton(
            //         mq: mq, aImg: "assets/images/facebook_login.png"))
          ],
        ));
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mq.size.width / 7),
      child: Image.asset(aImg),
    );
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
