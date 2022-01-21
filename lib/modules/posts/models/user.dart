


//   bool valid() {
//     return userId.length > 3 && displayName != null && email != null;
//   }

//   // ignore: hash_and_equals, test_types_in_equals
//   bool operator ==(other) => this.userId == (other as PiUser).userId;

//   Future<bool> update() async {
//     updatedAt = DateTime.now();
//     final doc = getCollection(c: Collections.Users).doc(userId);
//     await doc.set(toJson(), SetOptions(merge: true));
//     return true;
//   }

//   Future<List<PiUser>> usersByIds(List<String> userIds) async {
//     final uCol = getCollection(c: Collections.Users);
//     const chunkSize = 9;
//     List<Future<QuerySnapshot<Object?>>> futures = [];
//     for (var i = 0; i < userIds.length; i += chunkSize) {
//       final chunkIds = userIds.sublist(
//           i, i + chunkSize > userIds.length ? userIds.length : i + chunkSize);
//       futures.add(uCol.where('userId', whereIn: chunkIds).get());
//     }
//     final queryResults = await Future.wait(futures);
//     List<PiUser> users = [];
//     for (var j in queryResults) {
//       users.addAll(
//           j.docs.map((e) => PiUser.fromJson(e.data() as Map<String, dynamic>)));
//     }
//     return users;
//   }

//   PiUser.fromJson(Map<String, dynamic> j)
//       : userId = j['userId'],
//         displayName = j['displayName'],
//         email = j['email'],
//         emailVerified = j['emailVerified'],
//         phoneNumber = j['phoneNumber'],
//         photoURL = j['photoURL'],
//         refreshToken = j['refreshToken'],
//         messageToken = j['messageToken'],
//         tenantId = j['tenantId'],
//         hash = j['hash'],
//         favoriteFeeds = List<String>.from(j['favoriteFeeds']),
//         followers = List<String>.from(j['followers']),
//         follows = List<String>.from(j['follows']),
//         createdAt = j['createdAt'] is DateTime
//             ? j['createdAt']
//             : timeStamp2DateTime(j['createdAt']),
//         updatedAt = j['updatedAt'] is DateTime
//             ? j['updatedAt']
//             : timeStamp2DateTime(j['updatedAt']);

//   Map<String, dynamic> toJson() => {
//         'userId': userId,
//         'displayName': displayName,
//         'email': email,
//         'emailVerified': emailVerified,
//         'phoneNumber': phoneNumber,
//         'photoURL': photoURL,
//         'refreshToken': refreshToken,
//         'messageToken': messageToken,
//         'tenantId': tenantId,
//         'hash': hash,
//         'favoriteFeeds': favoriteFeeds,
//         'followers': followers,
//         'follows': follows,
//         'createdAt': createdAt,
//         'updatedAt': updatedAt,
//       };
// }
