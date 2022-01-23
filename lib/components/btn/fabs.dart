import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PostingFab extends StatelessWidget {
  const PostingFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (innercontext) => AlertDialog(
                  title: const Center(child: Text("포스팅 종류 선택")),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [MgzFab(), FeedFab()],
                  )));
        },
        child: const Icon(Icons.add));
  }
}

class MgzFab extends StatelessWidget {
  const MgzFab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<NavigationCubit>().push(mgzPostPath);
      },
      child: const Text("매거진"),
      shape: const CircleBorder(),
    );
  }
}

class FeedFab extends StatelessWidget {
  const FeedFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<NavigationCubit>().push(feedPostPath);
      },
      child: const Text("피드"),
      shape: const CircleBorder(),
    );
  }
}
