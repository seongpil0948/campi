import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage() : super(key: const ValueKey("UnknownPage"));

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "UnKnown Page",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
