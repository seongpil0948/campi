import 'package:campi/modules/posts/feed/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rich_text_controller/rich_text_controller.dart';

Map<RegExp, TextStyle> tagPatternMap(BuildContext c) => {
      RegExp("#[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
          const TextStyle(color: Colors.purpleAccent),
      RegExp(r"@[|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
          TextStyle(color: Theme.of(c).colorScheme.primary),
      RegExp(r"![|ㄱ-ㅎ가-힣a-zA-Z0-9]+"):
          TextStyle(color: Theme.of(c).colorScheme.error),
    };

class PiFeedEditors extends StatefulWidget {
  const PiFeedEditors({Key? key}) : super(key: key);

  @override
  _PiEditorsState createState() => _PiEditorsState();
}

class _PiEditorsState extends State<PiFeedEditors> {
  final _titleController = TextEditingController();
  late RichTextController _contentController;
  bool once = false;

  void setHashTags(BuildContext context, List<String> tags) =>
      context.read<FeedCubit>().changeHashTags(tags);

  @override
  void didChangeDependencies() {
    if (once == false) {
      _contentController = RichTextController(
          patternMatchMap: tagPatternMap(context),
          onMatch: (matches) {
            setHashTags(context, matches);
            return matches.join(" ");
          });
      _contentController.addListener(() {
        context.read<FeedCubit>().changeContent(_contentController.text);
      });
      _titleController.addListener(() {
        context.read<FeedCubit>().changeTitle(_titleController.text);
      });
      once = true;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: OneLineEditor(titleController: _titleController),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
          child: PiContentEditor(controller: _contentController),
        ),
      ],
    );
  }
}

class OneLineEditor extends StatelessWidget {
  const OneLineEditor({
    Key? key,
    required TextEditingController titleController,
  })  : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _titleController,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 3, color: Theme.of(context).cardColor),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          labelText: "제목을 입력해주세요"),
    );
  }
}

class PiContentEditor extends StatelessWidget {
  final TextEditingController controller;
  const PiContentEditor({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 3, color: Theme.of(context).cardColor),
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          labelText: "사진에 대한 내용을 입력해주세요"),
      maxLines: 10,
    );
  }
}
