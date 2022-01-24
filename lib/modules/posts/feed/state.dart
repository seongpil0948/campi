import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/common/collections.dart';
import 'package:campi/utils/io.dart';
import 'package:campi/utils/moment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class FeedState extends Equatable {
  final String feedId;
  final List<PiFile> files;
  final String writerId;
  late String title;
  late String content;
  String? placeAround;
  int? placePrice;
  String? campKind;
  String? addr;
  double? lat;
  double? lng; // lat lng
  List<String> hashTags = [];
  List<String> likeUserIds = [];
  List<String> sharedUserIds = [];
  List<String> bookmarkedUserIds = [];
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  FeedState(
      {this.files = const [],
      this.title = '',
      this.content = '',
      this.placeAround,
      this.placePrice,
      this.campKind,
      this.addr,
      this.lat,
      this.lng,
      this.hashTags = const [],
      this.likeUserIds = const [],
      this.sharedUserIds = const [],
      this.bookmarkedUserIds = const [],
      required this.writerId})
      : feedId = const Uuid().v4();

  Future<PiUser?> get writer async {
    final doc = await getCollection(c: Collections.users).doc(writerId).get();
    return doc.exists
        ? PiUser.fromJson(doc.data() as Map<String, dynamic>)
        : null;
  }

  Future<bool> update() {
    updatedAt = DateTime.now();
    final fc = getCollection(c: Collections.feeds, userId: writerId);
    return fc
        .doc(feedId)
        .set(toJson(), SetOptions(merge: true))
        .then((value) => true)
        .catchError((e) => false);
  }

  FeedState copyWith({
    List<PiFile>? fs,
    String? wrterId,
    String? title,
    String? content,
    String? around,
    String? campKind,
    int? price,
    String? addr,
    double? lat,
    double? lng,
    List<String>? hashTags,
    List<String>? likeUserIds,
    List<String>? sharedUserIds,
    List<String>? bookmarkedUserIds,
  }) {
    var feed = FeedState(
        writerId: writerId,
        files: fs ?? files,
        title: title ?? this.title,
        content: content ?? this.content,
        placeAround: around ?? placeAround,
        campKind: campKind ?? this.campKind,
        placePrice: price ?? placePrice,
        addr: addr ?? this.addr,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        hashTags: hashTags ?? this.hashTags,
        likeUserIds: likeUserIds ?? this.likeUserIds,
        sharedUserIds: sharedUserIds ?? this.sharedUserIds,
        bookmarkedUserIds: bookmarkedUserIds ?? this.bookmarkedUserIds);
    return feed;
  }

  FeedState.fromJson(Map<String, dynamic> j)
      : writerId = j['writerId'],
        feedId = j['feedId'],
        files = j['files'].map<PiFile>((f) => PiFile.fromJson(f)).toList(),
        title = j['title'],
        content = j['content'],
        placeAround = j['placeAround'],
        placePrice = j['placePrice'],
        campKind = j['campKind'],
        hashTags = j['hashTags'].cast<String>(),
        likeUserIds = j['likeUserIds'].cast<String>(),
        sharedUserIds = j['sharedUserIds'].cast<String>(),
        bookmarkedUserIds = j['bookmarkedUserIds'].cast<String>(),
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']),
        addr = j['addr'],
        lat = j['lat'],
        lng = j['lng'];

  Map<String, dynamic> toJson() => {
        'writerId': writerId,
        'feedId': feedId,
        'files': files.map((f) => f.toJson()).toList(),
        'title': title,
        'content': content,
        'placeAround': placeAround,
        'placePrice': placePrice,
        'campKind': campKind,
        'hashTags': hashTags,
        'likeUserIds': likeUserIds,
        'sharedUserIds': sharedUserIds,
        'bookmarkedUserIds': bookmarkedUserIds,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
        'addr': addr,
        'lat': lat,
        'lng': lng,
      };

  @override
  List<Object?> get props => [];
  @override
  String toString() {
    var str =
        "\n >>>>> User: $writerId 's FeedState: \n Title$title \n tags: $hashTags \n Files: $files \n <<<<<";
    if (addr != null) str += "Address: $addr";
    return str;
  }
}
