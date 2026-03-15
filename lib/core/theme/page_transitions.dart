import 'package:flutter/material.dart';

class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (route.settings.name == '/') {
      return child;
    }

    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final offsetTween = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    );

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: offsetTween.animate(curved),
        child: child,
      ),
    );
  }
}

