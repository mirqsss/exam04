import 'package:flutter/material.dart';

class FadePageRoute<T> extends PageRoute<T> {
  final Widget child;
  final Duration duration;

  FadePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class SlidePageRoute<T> extends PageRoute<T> {
  final Widget child;
  final Duration duration;

  SlidePageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }
}

class CustomScaleTransition extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const CustomScaleTransition({
    Key? key,
    required this.child,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

class CustomFadeTransition extends StatelessWidget {
  final Widget child;
  final bool isVisible;

  const CustomFadeTransition({
    Key? key,
    required this.child,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: child,
    );
  }
}

class CustomSlideTransition extends StatelessWidget {
  final Widget child;
  final bool isVisible;
  final Offset begin;
  final Offset end;

  const CustomSlideTransition({
    Key? key,
    required this.child,
    required this.isVisible,
    this.begin = const Offset(0.0, 0.5),
    this.end = Offset.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: isVisible ? end : begin,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: child,
    );
  }
} 