import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/components/structs/posts/feed/feed.dart';
import 'package:campi/modules/posts/mgz/cubit.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/views/pages/common/user.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class MgzThumnail extends StatelessWidget {
  const MgzThumnail({
    Key? key,
    required this.mgz,
    required this.tSize,
  }) : super(key: key);

  final MgzState mgz;
  final ThumnailSize tSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaUrl = docCheckMedia(mgz.content, checkImg: true);
    return mediaUrl != null
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: InkWell(
                onTap: () {
                  context
                      .read<NavigationCubit>()
                      .push(mgzDetailPath, {'magazine': mgz});
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                          imageUrl: mediaUrl,
                          fit: BoxFit.cover,
                          width: size.width,
                          height: size.height / 3),
                      Positioned(
                          bottom: size.height / 30,
                          left: size.width / 15,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (tSize == ThumnailSize.medium)
                                  UserRow(userId: mgz.writerId),
                                const SizedBox(height: 10),
                                Text(
                                  mgz.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4
                                      ?.copyWith(color: Colors.white),
                                )
                              ]))
                    ],
                  ),
                )),
          )
        : Container();
  }
}
