import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BouncyTouch extends HookWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scaleDown;
  final Duration duration;

  const BouncyTouch({
    super.key,
    required this.child,
    required this.onTap,
    this.scaleDown = 0.98,
    this.duration = const Duration(milliseconds: 150),
  });

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(duration: duration);
    
    final scaleAnimation = useMemoized(
      () => Tween<double>(begin: 1.0, end: scaleDown).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        ),
      ),
      [controller, scaleDown],
    );

    return GestureDetector(
      onTapDown: (_) => controller.forward(),
      onTapUp: (_) {
        controller.reverse();
        onTap();
      },
      onTapCancel: () => controller.reverse(),
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: child,
      ),
    );
  }
}
