part of './index.dart';

class NavigationStack extends Equatable {
  final List<PiPageConfig> _stack;

  const NavigationStack(this._stack);

  List<MaterialPage> get pages => List.unmodifiable(_stack.map((e) => e.page));
  List<PiPageConfig> get configs => _stack;
  int get length => _stack.length;
  PiPageConfig get first => _stack.first;
  PiPageConfig get last => _stack.last;

  ///the reason behind returning Navigation Stack instead of just being a void
  ///is to chain calls as we'll see in navigation_cubit.dart
  //not to go into how a cubit defines a state to be new with lists, I've just returned a new instance

  void clear() {
    final stack = List<PiPageConfig>.from(_stack);
    stack.removeRange(0, stack.length - 2);
    //pages list in navigator can't be empty, remember
  }

  bool canPop() {
    return _stack.length > 1;
  }

  NavigationStack pop() {
    final stack = List<PiPageConfig>.from(_stack);
    if (canPop()) {
      stack.remove(stack.last);
    }
    return NavigationStack(stack);
  }

  NavigationStack pushBeneathCurrent(PiPageConfig config) {
    final stack = List<PiPageConfig>.from(_stack);
    stack.insert(stack.length - 1, config);
    return NavigationStack(_stack);
  }

  NavigationStack push(PiPageConfig config) {
    final stack = List<PiPageConfig>.from(_stack);
    if (stack.last != config) {
      stack.add(config);
    }
    return NavigationStack(stack);
  }

  NavigationStack replace(PiPageConfig config) {
    final stack = List<PiPageConfig>.from(_stack);
    if (canPop()) {
      stack.removeLast();
      push(config);
    } else {
      stack.insert(0, config);
      stack.removeLast();
    }
    return NavigationStack(stack);
  }

  NavigationStack clearAndPush(PiPageConfig config) {
    final stack = List<PiPageConfig>.from(_stack);
    stack.clear();
    stack.add(config);
    return NavigationStack(stack);
  }

  NavigationStack clearAndPushAll(List<PiPageConfig> configs) {
    final stack = List<PiPageConfig>.from(_stack);
    stack.clear();
    stack.addAll(configs);
    return NavigationStack(stack);
  }

  @override
  List<Object?> get props => [_stack, length, first, last];
}
