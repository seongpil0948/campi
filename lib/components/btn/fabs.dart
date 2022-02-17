import 'package:campi/modules/posts/bloc.dart';
import 'package:campi/modules/posts/state.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostingFab extends StatelessWidget {
  const PostingFab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MgzBloc, PostState>(
        builder: (context, state) => FloatingActionButton(
            onPressed: () => state.myTurn
                ? context.read<NavigationCubit>().push(mgzPostPath)
                : context.read<NavigationCubit>().push(feedPostPath),
            child: const Icon(Icons.add)));
  }
}
