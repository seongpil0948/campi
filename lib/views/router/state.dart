part of './index.dart';

class NavigationCubit extends Cubit<NavigationStack> {
  NavigationCubit(List<PiPageConfig> initialPages)
      : super(NavigationStack(initialPages)) {
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: initialPages.last.currScreenName);
  }

  @override
  void onChange(Change<NavigationStack> change) {
    super.onChange(change);
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: change.nextState.last.currScreenName);

    // FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
  }

  void push(String path, [Map<String, dynamic>? args]) {
    PiPageConfig config = PiPageConfig(location: path, args: args);

    final newState = state.push(config);
    emit(newState);
  }

  void clearAndPush(String path, [Map<String, dynamic>? args]) {
    PiPageConfig config = PiPageConfig(location: path, args: args);
    emit(state.clearAndPush(config));
  }

  void pop() {
    emit(state.pop());
  }

  bool canPop() {
    return state.canPop();
  }

  void pushBeneathCurrent(String path, [Map<String, dynamic>? args]) {
    final PiPageConfig config = PiPageConfig(location: path, args: args);
    emit(state.pushBeneathCurrent(config));
  }

  void naviFromStr(String targetPage) {
    /// "feedDetail?feedId=123&mgzId=456"; => PATH: feedDetail , ARGS: {feedId: [123], mgzId: [456]}
    /// "feedDetail?feedId=14636346"; => PATH: feedDetail, ARGS: {feedId: [14636346]}
    /// "feedDetail"; => PATH: feedDetail, ARGS: {}
    Map<String, List<String>> args = {};
    final splited = targetPage.split("?");
    final path = splited[0];

    if (splited.length > 1) {
      String argStr = splited[1];
      for (String param in argStr.split("&")) {
        var a = param.split("=");
        if (args.containsKey(a[0])) {
          args[a[0]]!.add(a[1]);
        } else {
          args[a[0]] = [a[1]];
        }
      }
    }
    push(path, args);
  }
}
