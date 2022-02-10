import 'dart:convert';

import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> feedIds = [];
  List<String> mgzIds = [];
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
    final prefs = await SharedPreferences.getInstance();
    updatedAt = DateTime.now();
    final doc = getCollection(c: Collections.users).doc(userId);
    await doc.set(toJson(), SetOptions(merge: true));
    prefs.setString(AuthRepo.userCacheKey, jsonEncode(toJsonCache()));
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
        feedIds = List<String>.from(j['feedIds'] ?? []),
        mgzIds = List<String>.from(j['mgzIds'] ?? []),
        followers = List<String>.from(j['followers']),
        follows = List<String>.from(j['follows']),
        createdAt = j['createdAt'] is String
            ? DateTime.parse(j['createdAt'])
            : j['createdAt'] is DateTime
                ? j['createdAt']
                : timeStamp2DateTime(j['createdAt']),
        updatedAt = j['updatedAt'] is String
            ? DateTime.parse(j['updatedAt'])
            : j['updatedAt'] is DateTime
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
        'feedIds': feedIds,
        'mgzIds': mgzIds,
        'followers': followers,
        'follows': follows,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
  Map<String, dynamic> toJsonCache() {
    final j = toJson();
    j['createdAt'] = createdAt.toIso8601String();
    j['updatedAt'] = updatedAt.toIso8601String();
    return j;
  }
}
