import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PiSingleSelect extends StatefulWidget {
  final List<String> items;
  final String? hint;
  void Function(String?) onChange;
  String? defaultVal;
  String? dropdownValue;
  Color? color;

  PiSingleSelect(
      {Key? key,
      this.hint,
      required this.items,
      required this.onChange,
      this.defaultVal,
      this.color})
      : super(key: key);

  @override
  _PiSingleSelectState createState() => _PiSingleSelectState();
}

class _PiSingleSelectState extends State<PiSingleSelect> {
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
        color: widget.color ?? Theme.of(context).cardColor,
        width: mq.size.width / 7,
        child: DropdownButton<String>(
          alignment: AlignmentDirectional.centerEnd,
          value: widget.defaultVal,
          hint: widget.hint != null ? Text(widget.hint!, style: sty) : null,
          underline: Container(),
          menuMaxHeight: mq.size.height / 2,
          dropdownColor: widget.color ?? Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 24,
          // style: const TextStyle(color: Colors.deepPurple),
          onChanged: (String? newVal) {
            widget.onChange(newVal);
            setState(() {
              widget.defaultVal = newVal;
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
