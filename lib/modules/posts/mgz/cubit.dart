import 'package:campi/modules/common/collections.dart';
import 'package:campi/modules/posts/mgz/state.dart';
import 'package:campi/views/router/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/models/documents/document.dart';

class MgzCubit extends Cubit<MgzState> {
  MgzCubit(String writerId)
      : super(MgzState(writerId: writerId, content: Document()));
  void changeDoc(Document doc) => emit(state.copyWith(content: doc));

  void posting(BuildContext context) =>
      getCollection(c: Collections.magazines, userId: state.writerId)
          .doc()
          .set(state.toJson())
          .then((value) => context.read<NavigationCubit>().pop());
}

String? docCheckMedia(Document dc, {checkImg = false, checkVideo = false}) {
  final j = dc.toDelta().toJson();
  for (var i = 0; i < j.length; i++) {
    if (!j[i].containsKey("insert") || j[i].values.single is String) {
      continue;
    } else if (checkImg == true && j[i].values.single.containsKey('image')) {
      return j[i].values.single['image'];
    } else if (checkVideo == true && j[i].values.single.containsKey('video')) {
      return j[i].values.single['video'];
    }
  }
}
