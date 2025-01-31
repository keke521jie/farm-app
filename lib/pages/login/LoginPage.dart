import "package:app/base/kernel/Logger.dart";
import "package:app/gen/assets.gen.dart";
import "package:app/uikit/getIt.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_hooks/flutter_hooks.dart";

import "LoginPageBloc.dart";

class LoginPage extends HookWidget with WidgetsBindingObserver {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.i("HomePage.build");
    return BlocProvider(
      create: (_) => getIt<LoginPageBloc>(param1: context),
      child: BlocBuilder<LoginPageBloc, LoginPageState>(builder: (context, state) {
        var homeBloc = context.read<LoginPageBloc>();
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
              child: const Stack(children: [])),
        );
      }),
    );
  }
}
