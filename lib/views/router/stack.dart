import 'package:campi/views/router/config.dart';
import 'package:flutter/material.dart';

class NavigationStack {
  final List<PiPageConfig> _stack;

  NavigationStack(this._stack);

  List<MaterialPage> get pages => List.unmodifiable(_stack.map((e) => e.page));
  List<PiPageConfig> get configs => _stack;
  int get length => _stack.length;
  PiPageConfig get first => _stack.first;
  PiPageConfig get last => _stack.last;

  ///the reason behind returning Navigation Stack instead of just being a void
  ///is to chain calls as we'll see in navigation_cubit.dart
  //not to go into how a cubit defines a state to be new with lists, I've just returned a new instance

  void clear() {
    _stack.removeRange(0, _stack.length - 2);
    //pages list in navigator can't be empty, remember
  }

  bool canPop() {
    return _stack.length > 1;
  }

  NavigationStack pop() {
    if (canPop()) _stack.remove(_stack.last);
    return NavigationStack(_stack);
  }

  NavigationStack pushBeneathCurrent(PiPageConfig config) {
    _stack.insert(_stack.length - 1, config);
    return NavigationStack(_stack);
  }

  NavigationStack push(PiPageConfig config) {
    if (_stack.last != config) _stack.add(config);
    return NavigationStack(_stack);
  }

  NavigationStack replace(PiPageConfig config) {
    if (canPop()) {
      _stack.removeLast();
      push(config);
    } else {
      _stack.insert(0, config);
      _stack.removeLast();
    }
    return NavigationStack(_stack);
  }

  NavigationStack clearAndPush(PiPageConfig config) {
    _stack.clear();
    _stack.add(config);
    return NavigationStack(_stack);
  }

  NavigationStack clearAndPushAll(List<PiPageConfig> configs) {
    _stack.clear();
    _stack.addAll(configs);
    return NavigationStack(_stack);
  }
}
