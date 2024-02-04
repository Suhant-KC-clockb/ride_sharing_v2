import 'package:flutter/material.dart';

class CustomPageRoute extends PageRouteBuilder {
  final AxisDirection direction;
  final Widget child;
  final Duration duration;
  CustomPageRoute(
      {required this.child,
      this.direction = AxisDirection.right,
      this.duration = const Duration(seconds: 5),
      RouteSettings? settings})
      : super(
            transitionDuration: duration,
            reverseTransitionDuration: duration,
            settings: settings,
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) =>
                child);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      SlideTransition(
        position: Tween<Offset>(
          begin: getBeginOffset(),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );

  Offset getBeginOffset() {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(-1, 0);
      case AxisDirection.right:
        return const Offset(1, 0);
    }
  }
}

class FadeCustomPageRoute extends PageRouteBuilder {
  final Widget child;
  FadeCustomPageRoute({
    required this.child,
    RouteSettings? settings,
  }) : super(
            settings: settings,
            pageBuilder: (
              context,
              animation,
              secondaryAnimation,
            ) =>
                child);
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );
  // @override
  // Duration get transitionDuration => Duration(milliseconds: 500);
}
