import 'package:flutter/material.dart';

class SmoothPageRoute extends PageRouteBuilder {
  final Widget child;

  SmoothPageRoute({required this.child})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              child,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return ScaleTransition(
              scale:
                  Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.fastOutSlowIn,
              )),
              child: FadeTransition(
                opacity:
                    Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                )),
                child: child,
              ),
            );
          },
        );
}
