// import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:campi/modules/app/bloc.dart';
import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/common/upload_file.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/views/router/page.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

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

class PiEditAvatar extends StatefulWidget {
  final double? radius;
  final PiUser user;
  const PiEditAvatar({
    Key? key,
    this.radius,
    required this.user,
  }) : super(key: key);
  @override
  _PiEditAvatarState createState() => _PiEditAvatarState();
}

class _PiEditAvatarState extends State<PiEditAvatar> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());
    return InkWell(
        onTap: () async {
          setState(() {
            loading = true;
          });
          final appBloc = context.read<AppBloc>();
          if (appBloc.state.user != widget.user) return;
          final _picker = ImagePicker();
          final f = await _picker.pickImage(source: ImageSource.gallery);
          if (f == null) return;
          final pyfile = PiFile.fromXfile(f: f, ftype: PiFileType.image);
          final uploaded = await uploadFilePathsToFirebase(
              f: pyfile,
              path: 'userProfile/${widget.user.userId}/${uuid.v4()}');
          if (uploaded != null) {
            setState(() {
              widget.user.photoURL = uploaded.url!;
            });
            await widget.user.update();
          }
          setState(() {
            loading = false;
          });
        },
        child: getAvatar(widget.radius, widget.user.profileImage));
  }
}
