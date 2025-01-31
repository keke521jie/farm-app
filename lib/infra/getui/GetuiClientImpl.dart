import "dart:io";

import "package:app/base/kernel/Logger.dart";
import "package:app/base/kernel/Settings.dart";
import "package:app/base/port/GetuiClient.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/base/store/IdentityStore.dart";
import "package:dartx/dartx.dart";
import "package:getuiflut/getuiflut.dart";
import "package:injectable/injectable.dart";

@Singleton(as: GetuiClient)
class GetuiClientImpl extends GetuiClient {
  final AuthStore _authStore;
  final IdentityStore _identityStore;
  bool initGetuiSdk = false;

  GetuiClientImpl(this._authStore, this._identityStore) : super();

  @override
  void configure() {
    if (!initGetuiSdk) {
      initGetuiSdk = true;
      if (Platform.isIOS) {
        Getuiflut().startSdk(
          appId: settings.getuiAppId,
          appKey: settings.getuiAppKey,
          appSecret: settings.getuiAppSecret,
        );
      } else {
        Getuiflut.initGetuiSdk;
      }

      Getuiflut().addEventHandler(onReceiveClientId: (String message) async {
        print("getui onReceiveClientId: $message");
        // Getuiflut().bindAlias("alias", "alias"); //这里设置别名
        emit(state.copyWith(clientId: "ClientId: $message"));
        configure();
      }, onReceiveMessageData: (Map<String, dynamic> msg) async {
        print("getui onReceiveMessageData: $msg");
      }, onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        print("getui onNotificationMessageArrived: $msg");
      }, onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        print("getui onNotificationMessageClicked: $msg");
      }, onTransmitUserMessageReceive: (Map<String, dynamic> msg) async {
        print("getui onTransmitUserMessageReceive:$msg");
      }, onRegisterDeviceToken: (String message) async {
        print("getui onRegisterDeviceToken: $message");
        state.copyWith(deviceToken: message);
      }, onReceivePayload: (Map<String, dynamic> message) async {
        print("getui onReceivePayload: $message");
      }, onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        print("getui onReceiveNotificationResponse: $message");
      }, onAppLinkPayload: (String message) async {
        print("getui onAppLinkPayload: $message");
      }, onPushModeResult: (Map<String, dynamic> message) async {
        print("getui onPushModeResult: $message");
      }, onSetTagResult: (Map<String, dynamic> message) async {
        print("getui onSetTagResult: $message");
      }, onAliasResult: (Map<String, dynamic> message) async {
        print("getui onAliasResult: $message");
      }, onQueryTagResult: (Map<String, dynamic> message) async {
        print("getui onQueryTagResult: $message");
      }, onWillPresentNotification: (Map<String, dynamic> message) async {
        print("getui onWillPresentNotification: $message");
      }, onOpenSettingsForNotification: (Map<String, dynamic> message) async {
        print("getui onOpenSettingsForNotification: $message");
      }, onGrantAuthorization: (String granted) async {
        print("getui onGrantAuthorization: $granted");
      }, onLiveActivityResult: (Map<String, dynamic> message) async {
        print("getui onLiveActivityResult: $message");
      });
    }

    logger.i(
        "authStore.isAuth: ${_authStore.isAuth}, identityStore.id: ${_identityStore.state.id}, clientId:${state.clientId}");
    if (_authStore.isAuth && _identityStore.state.id.isNotBlank && state.clientId.isNotBlank) {
      // 绑定别名
      Getuiflut().bindAlias(_identityStore.state.id, _identityStore.state.id); //这里设置别名
    }
  }

  @override
  Future<String> getClientId() async {
    String getClientId = "";
    try {
      getClientId = await Getuiflut.getClientId;
      logger.i("ClientId: $getClientId"); // 这里可以获取到cid
    } catch (e) {
      logger.e("getClientId error", e);
    }
    return getClientId;
  }
}
