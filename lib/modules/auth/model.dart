import 'dart:convert';

import 'package:campi/modules/auth/repo.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/common/fcm/model.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class PiUser extends Equatable {
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
  List<FcmToken> messageToken = [];
  List<String> favoriteFeeds = [];
  List<String> followers = [];
  List<String> follows = [];
  List<String> feedIds = [];
  List<String> mgzIds = [];
  String desc = "이 시대 진정한 인싸 캠핑러 정보 공유 DM 환영 ";
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  String get uId => email?.split("@")[0] ?? name;
  String get name => displayName ?? email!.split("@")[0];

  bool get isEmpty => this == PiUser.empty();
  bool get isNotEmpty => this != PiUser.empty();
  List<String> get rawFcmTokens =>
      messageToken.map<String>((e) => e.token).toList();

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
        email = user.email ?? user.providerData.first.email,
        userId = user.uid,
        emailVerified = user.emailVerified,
        phoneNumber = user.phoneNumber ?? user.providerData.first.phoneNumber,
        metadata = user.metadata,
        photoURL = user.photoURL!,
        providerData = user.providerData,
        refreshToken = user.refreshToken,
        tenantId = user.tenantId,
        hash = user.hashCode;
  PiUser.fromSnap(AsyncSnapshot<DocumentSnapshot> snapshot)
      : this.fromJson(snapshot.data!.data() as Map<String, dynamic>);

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
        messageToken = j['messageToken']
            .map<FcmToken>((f) => FcmToken.fromJson(f))
            .toList(),
        tenantId = j['tenantId'],
        hash = j['hash'],
        desc = j['desc'] ?? '',
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
        'messageToken': messageToken.map((f) => f.toJson()).toList(),
        'tenantId': tenantId,
        'hash': hash,
        'favoriteFeeds': favoriteFeeds,
        'feedIds': feedIds,
        'mgzIds': mgzIds,
        'followers': followers,
        'follows': follows,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'desc': desc
      };
  Map<String, dynamic> toJsonCache() {
    final j = toJson();
    j['createdAt'] = createdAt.toIso8601String();
    j['updatedAt'] = updatedAt.toIso8601String();
    return j;
  }

  @override
  List<Object?> get props => [userId, followers, follows, feedIds, mgzIds];
}
