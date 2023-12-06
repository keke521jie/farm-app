import "package:app/base/kernel/Logger.dart";
import "package:flutter/material.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class LoginPageState {
  int currentIndex = 0;

  LoginPageState copyWith({
    int? currentIndex,
  }) {
    return LoginPageState()..currentIndex = currentIndex ?? this.currentIndex;
  }
}

@injectable
class LoginPageBloc extends BlocBase<LoginPageState> {
  BuildContext context;

  LoginPageBloc(@factoryParam this.context) : super(LoginPageState()) {
    logger.i("HomeBloc, context: $context");
  }
}
