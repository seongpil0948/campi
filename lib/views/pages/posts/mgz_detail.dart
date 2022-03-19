import 'package:campi/components/noti/snacks.dart';
import 'package:campi/config/constants.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/modules/posts/repo.dart';
import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_quill/flutter_quill.dart';

class MgzDetailPage extends StatelessWidget {
  const MgzDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PiPageConfig;
    Widget child;
    final FocusNode _focusNode = FocusNode();
    final s = MediaQuery.of(context).size;

    if (args.args['magazine'] != null) {
      final _controller = QuillController(
          document: args.args['magazine'].content,
          selection: const TextSelection.collapsed(offset: 0));
      child = MgzDetailW(s: s, controller: _controller, focusNode: _focusNode);
    } else {
      child = FutureBuilder<MgzState>(
          future: PostRepo.getMgzById(args.args['magazineId'][0] as String),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final _controller = QuillController(
                  document: snapshot.data!.content,
                  selection: const TextSelection.collapsed(offset: 0));
              return MgzDetailW(
                  s: s, controller: _controller, focusNode: _focusNode);
            }
            return loadingIndicator;
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: mat.Text(args.args['magazine']?.title,
            style: const TextStyle(color: Colors.black)),
        leading: IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: child,
    );
  }
}

class MgzDetailW extends StatelessWidget {
  const MgzDetailW({
    Key? key,
    required this.s,
    required QuillController controller,
    required FocusNode focusNode,
  })  : _controller = controller,
        _focusNode = focusNode,
        super(key: key);

  final Size s;
  final QuillController _controller;
  final FocusNode _focusNode;

  @override
  Widget build(BuildContext context) {
    return PiBackToClose(
      child: SafeArea(
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
