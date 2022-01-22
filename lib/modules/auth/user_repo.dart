import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/common/collections.dart';

class UserRepo {
  Future<Iterable<PiUser>> getAllUsers() async {
    // todo: Filtering Friends
    final collection = await getCollection(c: Collections.users)
        .orderBy('updatedAt', descending: true)
        .get();
    return collection.docs.map(
        (userDoc) => PiUser.fromJson(userDoc.data()! as Map<String, dynamic>));
  }

  Future<List<String>> get allUserIds async =>
      (await getAllUsers()).map((u) => u.userId).toList();
}
