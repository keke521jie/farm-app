import "package:flutter/material.dart";

import "config/Router.dart";

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "App",
      debugShowCheckedModeBanner: false,
      routerConfig: configureRouter(),
      theme: ThemeData(
          // highlightColor: Colors.transparent,
          // splashColor: Colors.transparent,
          ),
    );
  }
}
