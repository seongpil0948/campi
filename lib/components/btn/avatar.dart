import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/upload_file.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

Widget getAvatar(double? radius, String imgUrl) => CircleAvatar(
    radius: radius, backgroundImage: CachedNetworkImageProvider(imgUrl));

class GoMyAvatar extends StatelessWidget {
  final double? radius;
  final PiUser user;
  const GoMyAvatar({Key? key, required this.user, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.read<NavigationCubit>().push(myPath, {"selectedUser": user}),
      child: getAvatar(radius, user.photoURL),
    );
  }
}

class PiUserAvatar extends StatelessWidget {
  final String imgUrl;
  final double? radius;
  final String userId;
  const PiUserAvatar({
    Key? key,
    this.radius,
    required this.userId,
    required this.imgUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatar = getAvatar(radius, imgUrl);
    return InkWell(
        onTap: () async {
          final doc =
              await getCollection(c: Collections.users).doc(userId).get();
          final user = PiUser.fromJson(doc.data() as Map<String, dynamic>);

          final _picker = ImagePicker();
          final f = await _picker.pickImage(source: ImageSource.gallery);
          if (f == null) return;
          final pyfile = PiFile.fromXfile(f: f, ftype: PiFileType.image);
          final uploaded = await uploadFilePathsToFirebase(
              f: pyfile, path: 'userProfile/$userId');
          if (uploaded != null) {
            user.photoURL = uploaded.url!;
            await user.update();
          }
        },
        child: avatar);
  }
}

class PiEditAvatar extends StatelessWidget {
  final double? radius;
  final String? userId;
  const PiEditAvatar({
    Key? key,
    this.radius,
    this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final U = context.watch<AuthRepo>().currentUser;
    return InkWell(
        onTap: () async {
          final _picker = ImagePicker();
          final f = await _picker.pickImage(source: ImageSource.gallery);
          if (f == null) return;
          final pyfile = PiFile.fromXfile(f: f, ftype: PiFileType.image);
          final uploaded = await uploadFilePathsToFirebase(
              f: pyfile, path: 'userProfile/$userId');
          if (uploaded != null) {
            U.photoURL = uploaded.url!;
            await U.update();
          }
        },
        child: getAvatar(radius, U.profileImage));
  }
}
