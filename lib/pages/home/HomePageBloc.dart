import "dart:io";

import "package:app/base/kernel/Logger.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:getuiflut/getuiflut.dart";
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
    String? platformVersion,
    String? payloadInfo,
    String? userMsg,
    String? notificationState,
    String? getClientId,
    String? getDeviceToken,
    String? onReceivePayload,
    String? onReceiveNotificationResponse,
    String? onAppLinkPayLoad,
  }) {
    return HomePageState()
      ..currentIndex = currentIndex ?? this.currentIndex
      ..platformVersion = platformVersion ?? this.platformVersion
      ..payloadInfo = payloadInfo ?? this.payloadInfo
      ..userMsg = userMsg ?? this.userMsg
      ..notificationState = notificationState ?? this.notificationState
      ..getClientId = getClientId ?? this.getClientId
      ..getDeviceToken = getDeviceToken ?? this.getDeviceToken
      ..onReceivePayload = onReceivePayload ?? this.onReceivePayload
      ..onReceiveNotificationResponse = onReceiveNotificationResponse ?? this.onReceiveNotificationResponse
      ..onAppLinkPayLoad = onAppLinkPayLoad ?? this.onAppLinkPayLoad;
  }
}

@injectable
class HomePageBloc extends BlocBase<HomePageState> {
  BuildContext context;

  HomePageBloc(@factoryParam this.context) : super(HomePageState()) {
    logger.i("HomeBloc, context: $context");
  }

  Future<void> initPlatformState() async {
    print("#!!!!!!!!!!!!!!");
    String platformVersion;
    String payloadInfo = "default";
    String notificationState = "default";
    // Platform messages may fail, so we use a try/catch PlatformException.

    if (Platform.isIOS) {
      getSdkVersion();
      Getuiflut().startSdk(
          appId: "MBNiWcrEZo75YMXejwg4J2", appKey: "aTMnEu9zSEAga4iXguaKQ6", appSecret: "1llEjE2wna5arR5HgwbciA");
    }

    try {
      platformVersion = await Getuiflut.platformVersion;

      print("platformVersion$platformVersion");
    } on PlatformException {
      platformVersion = "Failed to get platform version.";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    // if (!mounted) return;

    emit(state.copyWith(
        platformVersion: platformVersion, payloadInfo: payloadInfo, notificationState: notificationState));

    Getuiflut().addEventHandler(onReceiveClientId: (String message) async {
      // 这个方法获取到cid就触发
      print("flutter onReceiveClientId: $message");
      Getuiflut().bindAlias("alias", "alias"); //这里设置别名
      emit(state.copyWith(getClientId: "ClientId: $message"));
    }, onReceiveMessageData: (Map<String, dynamic> msg) async {
      print("flutter onReceiveMessageData: $msg");
      state.copyWith(payloadInfo: msg["payload"]);
    }, onNotificationMessageArrived: (Map<String, dynamic> msg) async {
      print("flutter onNotificationMessageArrived: $msg");
      state.copyWith(notificationState: "Arrived");
    }, onNotificationMessageClicked: (Map<String, dynamic> msg) async {
      print("flutter onNotificationMessageClicked: $msg");
      state.copyWith(notificationState: "Clicked");
    }, onTransmitUserMessageReceive: (Map<String, dynamic> msg) async {
      print("flutter onTransmitUserMessageReceive:$msg");
      state.copyWith(userMsg: msg["msg"]);
    }, onRegisterDeviceToken: (String message) async {
      print("flutter onRegisterDeviceToken: $message");
      state.copyWith(getDeviceToken: message);
    }, onReceivePayload: (Map<String, dynamic> message) async {
      print("flutter onReceivePayload: $message");
      state.copyWith(onReceivePayload: "$message");
    }, onReceiveNotificationResponse: (Map<String, dynamic> message) async {
      print("flutter onReceiveNotificationResponse: $message");
      state.copyWith(onReceiveNotificationResponse: "$message");
    }, onAppLinkPayload: (String message) async {
      print("flutter onAppLinkPayload: $message");
      state.copyWith(onAppLinkPayLoad: message);
    }, onPushModeResult: (Map<String, dynamic> message) async {
      print("flutter onPushModeResult: $message");
    }, onSetTagResult: (Map<String, dynamic> message) async {
      print("flutter onSetTagResult: $message");
    }, onAliasResult: (Map<String, dynamic> message) async {
      print("flutter onAliasResult: $message");
    }, onQueryTagResult: (Map<String, dynamic> message) async {
      print("flutter onQueryTagResult: $message");
    }, onWillPresentNotification: (Map<String, dynamic> message) async {
      print("flutter onWillPresentNotification: $message");
    }, onOpenSettingsForNotification: (Map<String, dynamic> message) async {
      print("flutter onOpenSettingsForNotification: $message");
    }, onGrantAuthorization: (String granted) async {
      print("flutter onGrantAuthorization: $granted");
    }, onLiveActivityResult: (Map<String, dynamic> message) async {
      print("flutter onLiveActivityResult: $message");
    });
  }

  Future<void> initGetuiSdk() async {
    try {
      Getuiflut.initGetuiSdk;
    } catch (e) {
      e.toString();
    }
  }

  Future<void> getClientId() async {
    String getClientId;
    try {
      getClientId = await Getuiflut.getClientId;
      print(getClientId); // 这里可以获取到cid
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getSdkVersion() async {
    String ver;
    try {
      ver = await Getuiflut.sdkVersion;
      print(ver);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
      print(info);
    } catch (e) {
      print(e.toString());
    }
  }
}
