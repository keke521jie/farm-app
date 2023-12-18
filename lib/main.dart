import "dart:async";

import "package:app/Startup.dart";
import "package:app/uikit/getIt.dart";
import "package:flutter/material.dart";

import "App.dart";

void main() async {
  Startup? startup;
  runZonedGuarded(() async {
    startup = getIt<Startup>();
    await startup?.onCreated();
    runApp(const App());
  }, (error, stack) {
    startup?.handleError(FlutterErrorDetails(exception: error, stack: stack));
  });
}
