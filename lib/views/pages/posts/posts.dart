import 'package:campi/modules/app/bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: ElevatedButton(
            onPressed: () async {
              await context.read<AppBloc>().authRepo.logOut();
            },
            child: Text("Logout")),
      ),
    );
  }
}
