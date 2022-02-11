import 'package:campi/components/inputs/text_controller.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PiAppBarTextField extends StatelessWidget {
  const PiAppBarTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchVal = context.watch<SearchValBloc>();
    final b = UnderlineInputBorder(
        borderSide:
            BorderSide(width: 0.3, color: Theme.of(context).primaryColor));
    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextField(
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
              controller: searchVal.state.appSearchController, // FIXME
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  border: b,
                  focusedBorder: b,
                  enabledBorder: b,
                  errorBorder: b,
                  disabledBorder: b,
                  label: Text("Camping Place",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          ?.copyWith(color: Theme.of(context).primaryColor)))),
        ),
        Expanded(
            flex: 1,
            child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search_outlined,
                    size: 35, color: Theme.of(context).primaryColor)))
      ],
    );
  }
}
