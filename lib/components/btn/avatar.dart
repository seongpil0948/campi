part of 'index.dart';

const uuid = Uuid();

Widget getAvatar(double? radius, String imgUrl) => CircleAvatar(
    radius: radius, backgroundImage: CachedNetworkImageProvider(imgUrl));

class GoMyIdAvatar extends StatelessWidget {
  final void Function()? onTap;
  final double? radius;
  final String userId;
  const GoMyIdAvatar({Key? key, this.onTap, this.radius, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PiUser>(
        future: UserRepo.getUserById(userId),
        builder: (context, snapshot) => snapshot.hasData
            ? GoMyAvatar(radius: radius, onTap: onTap, user: snapshot.data!)
            : loadingIndicator);
  }
}

class GoMyAvatar extends StatelessWidget {
  final double? radius;
  final PiUser user;
  final void Function()? onTap;
  const GoMyAvatar({Key? key, required this.user, this.radius, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap == null
          ? context.read<NavigationCubit>().push(myPath, {"selectedUser": user})
          : onTap!(),
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

class AvartarIdRow extends StatelessWidget {
  const AvartarIdRow({
    Key? key,
    required this.user,
  }) : super(key: key);

  final PiUser user;

  @override
  Widget build(BuildContext context) {
    final T = Theme.of(context).textTheme;
    return Row(children: [
      getAvatar(15, user.photoURL),
      Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: Text(user.name,
              style: T.bodyText2!.copyWith(fontWeight: FontWeight.bold)))
    ]);
  }
}
