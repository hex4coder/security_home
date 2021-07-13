import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

// animation property
enum AniProps { y, opacity }

class FadeAnimator extends StatelessWidget {
  final double delay;
  final Widget child;
  final bool reverse;
  final bool vertical;

  FadeAnimator(
      {Key key,
      @required this.delay,
      @required this.child,
      this.reverse = false,
      this.vertical = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tween = TimelineTween<AniProps>()
      ..addScene(begin: 0.seconds, duration: 0.5.seconds)
          .animate(AniProps.y,
              tween: (reverse ? 0.0 : -30.0).tweenTo(reverse ? -30 : 0.0),
              curve: Curves.easeInOutSine)
          .animate(AniProps.opacity,
              tween: (reverse ? 1.0 : 0.0).tweenTo(reverse ? 0.0 : 1.0));

    return PlayAnimation<TimelineValue<AniProps>>(
      delay: Duration(milliseconds: (50 * delay).round()),
      duration: _tween.duration,
      tween: _tween,
      child: child,
      builder: (context, child, values) => Opacity(
        opacity: values.get(AniProps.opacity),
        child: Transform.translate(
          offset: Offset(vertical ? 0 : values.get(AniProps.y),
              vertical ? values.get(AniProps.y) : 0),
          child: child,
        ),
      ),
    );
  }
}
