part of './index.dart';

class FeedCubit extends Cubit<FeedState> {
  FeedCubit(String userId) : super(FeedState(writerId: userId));
  FeedCubit.fromState(FeedState f) : super(f);
  @override
  void onChange(Change<FeedState> change) {
    // debugPrint("Feed Change: $change");
    super.onChange(change);
  }

  void changeFs(List<PiFile> fs) => emit(state.copyWith(fs: fs));
  void changeTitle(String t) => emit(state.copyWith(title: t));
  void changeKind(String k) => emit(state.copyWith(campKind: k));
  void changePrice(String p) => emit(state.copyWith(price: p));
  void changeAround(String a) => emit(state.copyWith(around: a));
  void changeContent(String t) => emit(state.copyWith(content: t));
  void changeHashTags(List<String> hs) => emit(state.copyWith(hashTags: hs));
  void changeAddr(double lat, double lng, String? addr) =>
      emit(state.copyWith(lat: lat, lng: lng, addr: addr));
}
