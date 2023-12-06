import "package:app/base/kernel/Logger.dart";
import "package:app/gen/assets.gen.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lifecycle/lifecycle.dart";

class LifecyclePage2 extends StatefulWidget {
  const LifecyclePage2({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<LifecyclePage2> with LifecycleAware, LifecycleMixin {
  bool turnStatus = true;

  @override
  void onLifecycleEvent(LifecycleEvent event) {
    logger.i("=============== $event");
  }

  @override
  Widget build(BuildContext context) {
    logger.i("ProfilePage.build");

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.homeBg.provider(),
            fit: BoxFit.cover,
          ),
          color: const Color(0xFF000000),
        ),
        child: turnStatus ? _turnOnView() : _turnOffView(),
      ),
    );
  }

  Widget _turnOnView() {
    return Column(children: [
      Expanded(
        child: Center(
          child: LifecycleWrapper(
            onLifecycleEvent: (event) {
              logger.i("------------------ turnOnView, onLifecycleEvent, $event");
            },
            child: GestureDetector(
              child: const Text(
                "ON",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  turnStatus = false;
                });
              },
            ),
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: GestureDetector(
            child: const Text("LifecyclePage1"),
            onTap: () {
              context.pop();
            },
          ),
        ),
      )
    ]);
  }

  Widget _turnOffView() {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: LifecycleWrapper(
              onLifecycleEvent: (event) {
                logger.i("------------------ turnOffView, onLifecycleEvent, $event");
              },
              child: GestureDetector(
                child: const Text(
                  "OFF",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  setState(() {
                    turnStatus = false;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              child: const Text("LifecyclePage1"),
              onTap: () {
                context.pop();
              },
            ),
          ),
        )
      ],
    );
  }
}
