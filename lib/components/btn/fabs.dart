import 'package:campi/views/pages/posts/posts.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PostingFab extends StatelessWidget {
  final PostKind postKind;
  const PostingFab({Key? key, required this.postKind}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          switch (postKind) {
            case PostKind.feed:
              return context.read<NavigationCubit>().push(feedPostPath);
            case PostKind.mgz:
              return context.read<NavigationCubit>().push(mgzPostPath);
            default:
              return context.read<NavigationCubit>().push(feedPostPath);
          }
        },
        child: const Icon(Icons.add));
  }
}
