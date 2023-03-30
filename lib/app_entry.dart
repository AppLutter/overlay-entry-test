import 'package:flutter/material.dart';
import 'package:overlay_entry_test/overlay_const.dart';

mixin AppEntry {
  void showOverlay(BuildContext context) {
    removeOverlay();

    int count = 0;

    currentOverlay = OverlayEntry(
      builder: (_) {
        return Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('오버레이 이지롱'),
                  const SizedBox(height: 10),
                  Text(count.toString()),
                  TextButton(
                    onPressed: () {
                      count--;
                      currentOverlay!.markNeedsBuild();
                    },
                    child: const Text('빼기'),
                  ),
                  TextButton(
                    onPressed: () {
                      count++;
                      currentOverlay!.markNeedsBuild();
                    },
                    child: const Text('더하기'),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
    Overlay.of(context).insert(currentOverlay!);
  }

  void showAnimatedOverlay({
    required BuildContext context,
    required TickerProvider vsync,
  }) {
    removeOverlay();
    AnimationController animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 1),
    );
    // Animation<double> animation = Tween(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(
    //     parent: animationController,
    //     curve: Curves.bounceIn,
    //   ),
    // );
    Animation<double> animation = animationController.drive(CurveTween(curve: Curves.easeIn)).drive(
          Tween(begin: 0.0, end: 1.0),
        );

    currentOverlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Material(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        if (animationController.status == AnimationStatus.completed) {
                          animationController.reset();
                        }
                        animationController.forward();
                      },
                      child: const Text('시작')),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget? child) {
                      return Text(animation.value.toString());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );

    Overlay.of(context).insert(currentOverlay!);
  }

  void removeOverlay() {
    if (currentOverlay != null) {
      currentOverlay!.remove();
      currentOverlay = null;
    }
  }
}
