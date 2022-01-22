import 'package:campi/modules/posts/feed/state.dart';
import 'package:bloc/bloc.dart';
import 'package:campi/utils/io.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit() : super(FeedState());

  @override
  void onChange(Change<FeedState> change) {
    print("Feed Change: $change");
    super.onChange(change);
  }

  void changeFs(List<PiFile> fs) => emit(state.copyWith(fs: fs));
  void changeTitle(String t) => emit(state.copyWith(title: t));
  void changeKind(String k) => emit(state.copyWith(campKind: k));
  void changePrice(int p) => emit(state.copyWith(price: p));
  void changeAround(String a) => emit(state.copyWith(around: a));
  void changeContent(String t) => emit(state.copyWith(content: t));
  void changeHashTags(List<String> hs) => emit(state.copyWith(hashTags: hs));

  void postFeed(List<String> hs) => emit(state.copyWith(hashTags: hs));
}