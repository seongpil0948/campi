part of 'index.dart';

class IconTxtBtn extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final Widget txt;
  const IconTxtBtn(
      {Key? key,
      required this.onPressed,
      required this.icon,
      required this.txt})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [IconButton(onPressed: onPressed, icon: icon), txt],
    );
  }
}
