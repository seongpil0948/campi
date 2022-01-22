// ignore_for_file: implementation_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/modules/posts/mgz/cubit.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class MgzW extends StatelessWidget {
  const MgzW({
    Key? key,
    required this.mgz,
  }) : super(key: key);

  final MgzState mgz;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaUrl = docCheckMedia(mgz.content, checkImg: true);
    return mediaUrl != null
        ? InkWell(
            onTap: () => context
                .read<NavigationCubit>()
                .push(mgzDetailPath, {"magazine": mgz}),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                    imageUrl: mediaUrl,
                    fit: BoxFit.cover,
                    width: size.width,
                    height: size.height / 3),
              ),
            ))
        : Container();
  }
}
