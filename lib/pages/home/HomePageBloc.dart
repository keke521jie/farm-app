import "package:app/base/kernel/Logger.dart";
import "package:flutter/material.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class HomePageState {
  int currentIndex = 0;
  String platformVersion = "Unknown";
  String payloadInfo = "Null";
  String userMsg = "";
  String notificationState = "";
  String getClientId = "";
  String getDeviceToken = "";
  String onReceivePayload = "";
  String onReceiveNotificationResponse = "";
  String onAppLinkPayLoad = "";

  HomePageState copyWith({
    int? currentIndex,
  }) {
    return HomePageState()..currentIndex = currentIndex ?? this.currentIndex;
  }
}

@injectable
class HomePageBloc extends BlocBase<HomePageState> {
  BuildContext context;

  HomePageBloc(@factoryParam this.context) : super(HomePageState()) {
    logger.i("HomeBloc, context: $context");
  }
}
