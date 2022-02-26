import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class MgzDetailPage extends StatelessWidget {
  const MgzDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    // debugPrint("Magazine Detail View Arguments : $args");
    MgzState mgz = args.args['magazine'];
    // debugPrint("Magazine : $mgz");
    final FocusNode _focusNode = FocusNode();

    final _controller = QuillController(
        document: mgz.content,
        selection: const TextSelection.collapsed(offset: 0));
    final s = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
          ),
          height: s.height - 50,
          // child: RawKeyboardListener(
          //   focusNode: _focusNode,
          //   onKey: (evt) {
          //     if (evt.isControlPressed && evt.character == 'b') {
          //       final atts = _controller.getSelectionStyle().attributes;
          //       debugPrint("Selected Attributes: $atts");
          //       atts.keys.contains("bold")
          //           ? _controller
          //               .formatSelection(Attribute.clone(Attribute.bold, null))
          //           : _controller.formatSelection(Attribute.bold);
          //     }
          //   },
          child: QuillEditor(
            controller: _controller,
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: true,
            readOnly: true,
            expands: true,
            padding: const EdgeInsets.all(8),
            showCursor: false,
          ),
          // ),
        ),
      ),
    );
  }
}
