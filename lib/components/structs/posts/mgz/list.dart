part of './index.dart';

class MgzListW extends StatelessWidget {
  const MgzListW({Key? key, required this.scrollController}) : super(key: key);

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final txtSty = Theme.of(context).textTheme.bodyText2;
    return BlocBuilder<MgzRUDBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.failure) {
          return Center(child: Text('게시글들을 받아오는데에 실패 하였습니다.', style: txtSty));
        }
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) => MgzThumnail(
              mgz: state.posts[index] as MgzState, tSize: ThumnailSize.medium),
          itemCount: state.posts.length,
          controller: scrollController,
        );
      },
    );
  }
}

class GridMgzs extends StatelessWidget {
  const GridMgzs({
    Key? key,
    required this.mgzs,
  }) : super(key: key);

  final List<MgzState> mgzs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: mgzs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, idx) =>
            MgzThumnail(mgz: mgzs[idx], tSize: ThumnailSize.small));
  }
}
