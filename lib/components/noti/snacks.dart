part of 'index.dart';

class PiBackToClose extends StatelessWidget {
  final Widget child;
  const PiBackToClose({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pages = context.read<NavigationCubit>().state.pages;
    return pages.length < 2
        ? DoubleBackToCloseApp(
            child: child,
            snackBar: SnackBar(
                content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.exit_to_app_sharp),
                SizedBox(width: 10),
                Text("뒤로가기 버튼을 두번 누르면 앱이 종료됩니다!")
              ],
            )),
          )
        : child;
  }
}
