import 'package:campi/modules/common/collections.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PiUser {
  String userId;
  String? displayName;
  String? email;
  bool emailVerified;
  String? phoneNumber;
  UserMetadata? metadata;
  String photoURL;
  List<UserInfo>? providerData;
  String? refreshToken;
  String? tenantId;
  int hash;
  String get profileImage => photoURL;
  List<String> messageToken = [];
  List<String> favoriteFeeds = [];
  List<String> followers = [];
  List<String> follows = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  String get name => displayName ?? email!.split("@")[0];

  bool get isEmpty => this == PiUser.empty();

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != PiUser.empty();
  @override
  // ignore: hash_and_equals
  bool operator ==(other) => userId == (other as PiUser).userId;

  Future<bool> update() async {
    updatedAt = DateTime.now();
    final doc = getCollection(c: Collections.users).doc(userId);
    await doc.set(toJson(), SetOptions(merge: true));
    return true;
  }

  PiUser({required User user})
      : displayName = user.displayName,
        email = user.email,
        userId = user.uid,
        emailVerified = user.emailVerified,
        phoneNumber = user.phoneNumber,
        metadata = user.metadata,
        photoURL = user.photoURL!,
        providerData = user.providerData,
        refreshToken = user.refreshToken,
        tenantId = user.tenantId,
        hash = user.hashCode;

  PiUser.empty()
      : userId = '',
        emailVerified = false,
        photoURL = '',
        hash = 0;

  @override
  String toString() {
    return """
    PiUser: name: $displayName \n 
    providerData: $providerData \n 
    tenantId: $tenantId \n
    followers: $followers \n 
    follows: $follows \n
    createdAt: $createdAt 
    updatedAt: $updatedAt 
    """;
  }

  PiUser.fromJson(Map<String, dynamic> j)
      : userId = j['userId'],
        displayName = j['displayName'],
        email = j['email'],
        emailVerified = j['emailVerified'],
        phoneNumber = j['phoneNumber'],
        photoURL = j['photoURL'],
        refreshToken = j['refreshToken'],
        messageToken = List<String>.from(j['messageToken']),
        tenantId = j['tenantId'],
        hash = j['hash'],
        favoriteFeeds = List<String>.from(j['favoriteFeeds']),
        followers = List<String>.from(j['followers']),
        follows = List<String>.from(j['follows']),
        createdAt = j['createdAt'] is DateTime
            ? j['createdAt']
            : timeStamp2DateTime(j['createdAt']),
        updatedAt = j['updatedAt'] is DateTime
            ? j['updatedAt']
            : timeStamp2DateTime(j['updatedAt']);

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'displayName': displayName,
        'email': email,
        'emailVerified': emailVerified,
        'phoneNumber': phoneNumber,
        'photoURL': photoURL,
        'refreshToken': refreshToken,
        'messageToken': messageToken,
        'tenantId': tenantId,
        'hash': hash,
        'favoriteFeeds': favoriteFeeds,
        'followers': followers,
        'follows': follows,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
  static Iterable<PiUser> mocks(int n) {
    return Iterable.generate(
        n,
        (i) => PiUser.fromJson({
              'userId': "spsp$i",
              'displayName': "spspspsp",
              'email': "seongpil0948@gmail.com",
              'emailVerified': i % 2 == 0 ? true : false,
              'phoneNumber': i % 2 == 0 ? "010-7184-0948" : null,
              'photoURL': "https://picsum.photos/250?image=$i",
              'refreshToken': "asdasfasfasfasfgadg",
              'messageToken': "asdasfasfasfasfgadg",
              'tenantId': "asdasfasfasfasfgadg",
              'hash': 1010012312412,
              'favoriteFeeds': [],
              'followers': [],
              'follows': [],
              'createdAt': Timestamp.now(),
              'updatedAt': Timestamp.now(),
            }));
  }
}
