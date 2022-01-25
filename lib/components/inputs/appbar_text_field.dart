import 'package:campi/components/inputs/text_controller.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PiAppBarTextField extends StatelessWidget {
  const PiAppBarTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchVal = context.watch<SearchValBloc>();
    return TextField(
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.caption,
      controller: searchVal.state.postController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          labelText: "     캠핑라이프와 상품을 검색 해보세요",
          prefixIcon: Icon(
            Icons.search_outlined,
            size: 20,
            color: Colors.blue.shade900,
          )),
    );
  }
}
