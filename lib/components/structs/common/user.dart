// import 'package:campi/modules/auth/model.dart';
// import 'package:flutter/material.dart';
// // ignore: implementation_imports
// import 'package:provider/src/provider.dart';

// class UserSnsInfo extends StatelessWidget {
//   const UserSnsInfo({
//     Key? key,
//     required this.currUser,
//     required this.numUserFeeds,
//   }) : super(key: key);

//   final PiUser currUser;
//   final int numUserFeeds;

//   @override
//   Widget build(BuildContext context) {
//     final sty = TextStyle(
//         color: Theme.of(context).primaryColor,
//         fontWeight: FontWeight.bold,
//         fontSize: 12);
//     return PyWhiteButton(
//         widget: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           "포스팅 ${numUserFeeds.toString()}",
//           style: sty,
//         ),
//         TextButton(
//           onPressed: () async => showFollow(
//               context: context,
//               currUser: currUser,
//               users: await currUser.usersByIds(currUser.followers)),
//           child: Text(
//             "팔로워 ${currUser.followers.length}",
//             style: sty,
//           ),
//         ),
//         TextButton(
//           onPressed: () async => showFollow(
//               context: context,
//               currUser: currUser,
//               users: await currUser.usersByIds(currUser.follows)),
//           child: Text(
//             "팔로우 ${currUser.follows.length}",
//             style: sty,
//           ),
//         )
//       ],
//     ));
//   }
// }

// void showFollow(
//     {required BuildContext context,
//     required PiUser currUser,
//     required List<PiUser> users}) {
//   showDialog(
//       context: context,
//       builder: (context) => Dialog(
//           insetPadding: EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             children: [
//               Container(
//                 height: 50,
//                 margin: EdgeInsets.only(top: 10),
//                 child: Row(
//                   children: [
//                     Spacer(),
//                     IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(Icons.exit_to_app))
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height / 2,
//                 child: ListView.builder(
//                     itemBuilder: (context, idx) =>
//                         UserList(targetUser: users[idx], currUser: currUser),
//                     itemCount: users.length),
//               ),
//             ],
//           )));
// }

// class UserList extends StatelessWidget {
//   final PiUser targetUser;
//   final PiUser? currUser;
//   UserList({
//     required this.targetUser,
//     this.currUser,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//         leading: PyUserAvatar(
//             imgUrl: targetUser.profileImage, userId: targetUser.userId),
//         title: Text(targetUser.displayName ??
//             // targetUser.email?.split('@').first ??
//             targetUser.email ??
//             ""),
//         subtitle: Text(targetUser.email ?? ""),
//         trailing: FollowBtn(
//           currUser: currUser!,
//           targetUser: targetUser,
//         ));
//   }
// }

// class FollowBtn extends StatefulWidget {
//   final PiUser currUser;
//   final PiUser targetUser;
//   FollowBtn({Key? key, required this.currUser, required this.targetUser})
//       : super(key: key);

//   @override
//   _FollowBtnState createState() => _FollowBtnState();
// }

// class _FollowBtnState extends State<FollowBtn> {
//   Future<void> followUser(PiUser s, PiUser target, bool unFollow) async {
//     if (s == target) return;
//     setState(() {
//       if (unFollow) {
//         s.follows.remove(target.userId);
//         target.followers.remove(s.userId);
//       } else {
//         s.follows.add(target.userId);
//         target.followers.add(s.userId);
//       }
//     });
//     await s.update();
//     await target.update();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.targetUser == widget.currUser) return Container();
//     final aleady = widget.targetUser.followers.contains(widget.currUser.userId);
//     final txt = aleady ? "팔로우 취소" : "팔로우";
//     return ElevatedButton(
//         onPressed: () {
//           followUser(widget.currUser, widget.targetUser, aleady);
//         },
//         child: Text(txt));
//   }
// }

// class UserRow extends StatelessWidget {
//   const UserRow({
//     Key? key,
//     required this.feedInfo,
//   }) : super(key: key);

//   final FeedState feedInfo;

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<PiUser?>(
//         future: feedInfo.writer,
//         builder: (context, snapshot) {
//           return snapshot.hasData
//               ? GestureDetector(
//                   onTap: () {
//                     print("Click User Row");
//                     final state = context.read<PyState>();
//                     state.selectedUser = snapshot.data!;
//                     state.currPageAction = PageAction.my(snapshot.data!.userId);
//                   },
//                   child: Row(
//                     children: [
//                       PyUserAvatar(
//                         radius: 15,
//                         userId: snapshot.data!.userId,
//                         imgUrl: snapshot.data!.profileImage,
//                       ),
//                       SizedBox(width: 10),
//                       Text(
//                         snapshot.data?.email ?? "",
//                         style: Theme.of(context).textTheme.bodyText1,
//                       )
//                     ],
//                   ),
//                 )
//               : Center(child: CircularProgressIndicator());
//         });
//   }
// }
