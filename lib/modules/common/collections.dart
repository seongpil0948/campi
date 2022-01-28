import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections { feeds, users, comments, messages, magazines }

CollectionReference getCollection(
    {required Collections c, String? userId, String? feedId, String? roomId}) {
  FirebaseFirestore store = FirebaseFirestore.instance;
  switch (c) {
    case Collections.feeds:
      if (userId == null) {
        throw ArgumentError(
            "If you want a feed collection, please enter your user ID.");
      }
      return store
          .collection(userCollection)
          .doc(userId)
          .collection(feedCollection);
    case Collections.comments:
      if (userId == null || feedId == null)
        // ignore: curly_braces_in_flow_control_structures
        throw ArgumentError(
            "If you want a CommentModel collection, please enter your user & feed ID.");
      return store
          .collection(userCollection)
          .doc(userId)
          .collection(feedCollection)
          .doc(feedId)
          .collection(commentCollection);
    case Collections.users:
      return store.collection(userCollection);
    case Collections.magazines:
      return store
          .collection(userCollection)
          .doc(userId)
          .collection(magazineCollection);
    case Collections.messages:
      final c = store.collection(messagesCollection);
      if (roomId == null) return c;
      return c.doc(roomId).collection("msgs");
  }
}

const userCollection = 'users';
const feedCollection = 'feeds';
const commentCollection = 'comments';
const replyCollection = 'replies';
const messagesCollection = 'messages';
const magazineCollection = 'mgzs';
