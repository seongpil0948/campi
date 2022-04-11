part of './index.dart';

class BackBtn extends StatelessWidget {
  final double size;
  const BackBtn({Key? key, this.size = 60}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_left_outlined, size: size));
  }
}
