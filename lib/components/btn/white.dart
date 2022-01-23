import 'package:flutter/material.dart';

class PiWhiteButton extends StatelessWidget {
  final Widget? widget;
  const PiWhiteButton({
    Key? key,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onPressed: () {},
        child: widget);
  }
}
