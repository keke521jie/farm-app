import "package:app/base/kernel/Logger.dart";
import "package:app/base/port/GetuiClient.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/base/store/IdentityStore.dart";
import "package:app/uikit/clip/ClipMsgHandler.dart";
import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:injectable/injectable.dart";

@Singleton()
class MsgHandler extends ClipMsgHandler {
  AuthStore authStore;
  IdentityStore identityStore;
  final GetuiClient _getuiClient;

  MsgHandler(this.authStore, this.identityStore, this._getuiClient);

  @override
  void handle(BuildContext? context, Map<String, dynamic> msg, void Function(Map<String, dynamic> payload) reply) {
    var name = msg.getOrElse("name", () => "") as String;
    var payload = msg.getOrElse("payload", () => {}) as Map<String, dynamic>;
    switch (name) {
      case "setIdentity":
        var id = payload.getOrElse("id", () => "") as String;
        var token = payload.getOrElse("token", () => "") as String;
        authStore.login(token);
        identityStore.save(id: id);
        _getuiClient.configure();

        logger.i("setIdentity, token: $token id:${identityStore.state.id}  $id");
        reply({});
        break;
    }
  }
}
