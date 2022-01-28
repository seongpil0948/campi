import 'package:campi/modules/auth/model.dart';
import 'package:campi/modules/posts/models/common.dart';
import 'package:campi/utils/moment.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentModel {
  ContentType ctype = ContentType.comment;
  final String id;
  final PiUser writer;
  String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  CommentModel({required this.id, required this.writer, required this.content});

  void update({required String content}) {
    updatedAt = DateTime.now();
    this.content = content;
  }

  CommentModel.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        writer = PiUser.fromJson(j['writer']),
        ctype = contentTypeFromString(j['ctype']),
        content = j['content'],
        createdAt = timeStamp2DateTime(j['createdAt']),
        updatedAt = timeStamp2DateTime(j['updatedAt']);
  Map<String, dynamic> toJson() => {
        'id': id,
        'writer': writer.toJson(),
        'ctype': ctype.toCustomString(),
        'content': content,
        'updatedAt': updatedAt,
        'createdAt': createdAt,
      };
}

// ignore: must_be_immutable
class CommentState extends Equatable {
  final CommentModel? targetCmt;
  final bool showPostCmtW;

  const CommentState(CommentModel? targetComment, bool showPostCmtWiget)
      : targetCmt = targetComment,
        showPostCmtW = showPostCmtWiget;

  CommentState copyWith(CommentModel? targetComment, bool showPostCmtWiget) {
    return CommentState(targetComment, showPostCmtWiget);
  }

  @override
  List<Object?> get props => [targetCmt, showPostCmtW];
}

abstract class CommentEvent {}

class ShowPostCmtW extends CommentEvent {
  CommentModel? targetComment;
  bool showPostCmtWiget;
  ShowPostCmtW({required this.targetComment, required this.showPostCmtWiget});
}

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(const CommentState(null, false)) {
    on<ShowPostCmtW>((ShowPostCmtW event, Emitter<CommentState> emit) async {
      return emit(state.copyWith(event.targetComment, event.showPostCmtWiget));
    });
  }
}
