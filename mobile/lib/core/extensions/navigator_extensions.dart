import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

extension NavigatorContextExtension on BuildContext {
  static const _defaultDuration = Duration(milliseconds: 300);

  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: _defaultDuration,
      ),
    );
  }

  Future<T?> pushReplacement<T, TO>(Widget page, {TO? result}) {
    return Navigator.of(this).pushReplacement<T, TO>(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: _defaultDuration,
      ),
      result: result,
    );
  }

  Future<T?> pushAndRemoveUntil<T>(
    Widget page,
    bool Function(Route<dynamic>) predicate,
  ) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      PageTransition(
        child: page,
        type: PageTransitionType.fade,
        duration: _defaultDuration,
      ),
      predicate,
    );
  }

  void pop<T extends Object?>([T? result]) => Navigator.of(this).pop<T>(result);
  Future<bool> maybePop<T extends Object?>([T? result]) =>
      Navigator.of(this).maybePop<T>(result);
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this).popUntil(predicate);
}
