import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PiSingleSelect extends StatefulWidget {
  final List<String> items;
  final String hint;
  void Function(String?) onChange;
  String? defaultVal;
  String? dropdownValue;

  PiSingleSelect(
      {Key? key,
      required this.hint,
      required this.items,
      required this.onChange,
      this.defaultVal})
      : super(key: key);

  @override
  _PiSingleSelectState createState() => _PiSingleSelectState();
}

class _PiSingleSelectState extends State<PiSingleSelect> {
  @override
  void initState() {
    widget.dropdownValue = widget.defaultVal;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final sty = Theme.of(context)
        .textTheme
        .overline!
        .copyWith(color: Theme.of(context).hintColor);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Theme.of(context).cardColor,
        width: mq.size.width / 4,
        child: DropdownButton<String>(
          style: const TextStyle(color: Colors.red),
          alignment: AlignmentDirectional.centerEnd,
          value: widget.dropdownValue,
          hint: Padding(
              padding: EdgeInsets.only(left: mq.size.width / 14),
              child: Text(widget.hint, style: sty)),
          underline: Container(),
          menuMaxHeight: mq.size.height / 2,
          dropdownColor: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          // style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newVal) {
            widget.onChange(newVal);
            setState(() {
              widget.dropdownValue = newVal;
            });
          },
          items: widget.items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Center(child: Text(value, style: sty)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
