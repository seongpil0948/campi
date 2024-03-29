part of 'index.dart';

class PiAppBarTextField extends StatelessWidget {
  const PiAppBarTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final txtController = TextEditingController();
    final focusNode = FocusNode();
    final b = UnderlineInputBorder(
        borderSide:
            BorderSide(width: 0.3, color: Theme.of(context).primaryColor));

    void searching() {
      final terms = txtController.text
          .trim()
          .split(" ")
          .where((e) => e.isNotEmpty)
          .toList();
      context.read<SearchValBloc>().add(AppOnSearch(terms: terms));
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }

    return Row(
      children: [
        Expanded(
          flex: 8,
          child: TextField(
              focusNode: focusNode,
              onSubmitted: (txt) => searching(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.caption,
              controller: txtController,
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
                onPressed: () {
                  focusNode.requestFocus();
                  searching();
                },
                icon: Icon(Icons.search_outlined,
                    size: 35, color: Theme.of(context).primaryColor)))
      ],
    );
  }
}
