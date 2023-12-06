import "package:app/Startup.dart";
import "package:app/uikit/getIt.dart";
import "package:flutter/material.dart";

import "App.dart";

void main() async {
  // runZonedGuarded(() async {
  var startup = getIt<Startup>();
  await startup.onCreated();
  runApp(const App());
  // }, (error, stack) {
  //   logger.e("runZonedGuarded", error, stack);
  // });
}
