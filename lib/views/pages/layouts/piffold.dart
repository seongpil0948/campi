import 'package:campi/views/pages/layouts/appbar.dart';
import 'package:campi/views/pages/layouts/drawer.dart';
import 'package:flutter/material.dart';

class Piffold extends StatelessWidget {
  final Widget body;
  final Widget? fButton;
  final BottomSheet? bSheet;

  const Piffold({
    Key? key,
    this.fButton,
    this.bSheet,
    required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final toolbarH = mq.size.height / 7;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(toolbarH),
          child: PiAppBar(toolbarH: toolbarH)),
      // drawer: const PiDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: fButton,
      body: body,
      bottomSheet: bSheet,
    );
  }
}
