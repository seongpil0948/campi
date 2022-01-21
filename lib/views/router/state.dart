import 'package:campi/views/router/config.dart';
import 'package:campi/views/router/stack.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<NavigationStack> {
  NavigationCubit(List<PiPageConfig> initialPages)
      : super(NavigationStack(initialPages));

  void push(String path, [Map<String, dynamic>? args]) {
    print('push called with $path and $args');
    PiPageConfig config = PiPageConfig(location: path, args: args);
    emit(state.push(config));
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
}
