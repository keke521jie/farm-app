import "package:app/base/kernel/Properties.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/pages/example/api/ApiClientDemoPage.dart";
import "package:app/pages/example/lifecycle/LifecyclePage1.dart";
import "package:app/pages/example/lifecycle/LifecyclePage2.dart";
import "package:app/pages/home/HomePage.dart";
import "package:app/pages/login/LoginPage.dart";
import "package:app/uikit/getIt.dart";
import "package:app/uikit/navigatorKey.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:go_router/go_router.dart";
import "package:lifecycle/lifecycle.dart";

GoRouter configureRouterOrGet() {
  if (!GetIt.instance.isRegistered<GoRouter>()) {
    var router = configureRouter();
    GetIt.instance.registerSingleton(router);
    return router;
  } else {
    return GetIt.instance.get<GoRouter>();
  }
}

GoRouter configureRouter() {
  return GoRouter(
    observers: [defaultLifecycleObserver],
    initialLocation: properties.initialLocation,
    navigatorKey: navigatorKey,
    redirect: (BuildContext context, GoRouterState state) {
      return null;
    },
    routes: _pages() + _example(),
  );
}

List<GoRoute> _pages() {
  return [
    GoRoute(
        path: "/",
        pageBuilder: (BuildContext context, GoRouterState state) {
          var authStore = getIt<AuthStore>();
          return CustomTransitionPage(
            key: state.pageKey,
            child: authStore.isAuth ? HomePage() : LoginPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        }),
    GoRoute(
        path: "/home",
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        }),
  ];
}

List<GoRoute> _example() {
  return [
    GoRoute(
      path: "/example/ApiClientDemoPage",
      builder: (BuildContext context, GoRouterState state) {
        return const ApiClientDemoPage();
      },
    ),
    GoRoute(
      path: "/example/LifecyclePage1",
      builder: (BuildContext context, GoRouterState state) {
        return const LifecyclePage1();
      },
    ),
    GoRoute(
      path: "/example/LifecyclePage2",
      builder: (BuildContext context, GoRouterState state) {
        return const LifecyclePage2();
      },
    ),
  ];
}
