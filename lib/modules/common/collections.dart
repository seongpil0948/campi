part of './index.dart';

enum Collections {
  feeds,
  users,
  comments,
  replies,
  messages,
  magazines,
  chatRooms,
  alarms
}

DocumentReference getCmtTargetDocRef(String? feedId, String? mgzId) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  DocumentReference d;
  if (feedId != null) {
    d = store.collection(feedCollection).doc(feedId);
  } else if (mgzId != null) {
    d = store.collection(magazineCollection).doc(mgzId);
  } else {
    throw ArgumentError("please enter Comment Target ID.");
  }
  return d;
}

CollectionReference getCollection(
    {required Collections c,
    String? userId,
    String? feedId,
    String? mgzId,
    String? roomId,
    String? cmtId}) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  switch (c) {
    case Collections.feeds:
      return store.collection(feedCollection);
    case Collections.comments:
      return getCmtTargetDocRef(feedId, mgzId).collection(commentCollection);
    case Collections.replies:
      if (cmtId == null) {
        throw ArgumentError("please enter Comment ID For Reply Collection.");
      }
      return getCmtTargetDocRef(feedId, mgzId)
          .collection(commentCollection)
          .doc(cmtId)
          .collection(replyCollection);
    case Collections.users:
      return store.collection(userCollection);
    case Collections.magazines:
      return store.collection(magazineCollection);
    case Collections.chatRooms:
      return store.collection(chatRoomCollection);
    case Collections.messages:
      if (roomId == null) {
        throw ArgumentError("please enter your Room ID.");
      }
      return store
          .collection(chatRoomCollection)
          .doc(roomId)
          .collection(messagesCollection);
    case Collections.alarms:
      return store.collection(alarmCollection);
  }
}

const userCollection = 'users';
const feedCollection = 'feeds';
const commentCollection = 'comments';
const replyCollection = 'replies';
const chatRoomCollection = 'chatRooms';
const messagesCollection = 'messages';
const magazineCollection = 'mgzs';
const alarmCollection = 'alarms';
