import 'package:flutter/material.dart';

class PiWhiteButton extends StatelessWidget {
  final Widget? widget;
  final Function() onPressed;
  const PiWhiteButton({Key? key, this.widget, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
        onPressed: onPressed,
        child: widget);
  }
}
