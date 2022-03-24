part of './index.dart';

class MoreSelect extends StatelessWidget {
  final void Function()? onEdit;
  final void Function()? onDelete;
  const MoreSelect({Key? key, this.onDelete, this.onEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<Object>>? items = [];

    if (onEdit != null) {
      items.add(DropdownMenuItem(
        child: Icon(Icons.edit),
        onTap: onEdit,
        value: 'edit',
      ));
    }
    if (onDelete != null) {
      items.add(DropdownMenuItem(
        child: Icon(Icons.delete_forever_rounded),
        onTap: onDelete,
        value: 'delete',
      ));
    }

    return DropdownButton(
        items: items,
        underline: Container(),
        isDense: true,
        isExpanded: true,
        iconSize: 0,
        hint: Icon(Icons.more_horiz_rounded),
        dropdownColor: Colors.white,
        elevation: 0,
        onChanged: (v) {
          debugPrint(v.toString());
        });
  }
}
