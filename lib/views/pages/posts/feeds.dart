import 'package:campi/modules/posts/bloc/post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FeedListPage extends StatefulWidget {
  const FeedListPage({Key? key}) : super(key: key);

  @override
  _FeedListPageState createState() => _FeedListPageState();
}

class _FeedListPageState extends State<FeedListPage> {
  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    super.initState();
  }

  final _scrollController = ScrollController();
  final bloc = MgzBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: bloc, child: FeedListW(scrollController: _scrollController));
  }
}

class FeedListW extends StatelessWidget {
  final ScrollController scrollController;
  const FeedListW({Key? key, required this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
