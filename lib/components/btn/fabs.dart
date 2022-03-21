part of 'index.dart';

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
