import "package:app/base/kernel/Logger.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/base/store/IdentityStore.dart";
import "package:app/uikit/clip/ClipMsgHandler.dart";
import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:injectable/injectable.dart";

@Injectable()
class MsgHandler extends ClipMsgHandler {
  AuthStore authStore;
  IdentityStore identityStore;

  MsgHandler(this.authStore, this.identityStore);

  @override
  void handle(BuildContext context, Map<String, dynamic> msg, void Function(Map<String, dynamic> payload) reply) {
    var name = msg.getOrElse("name", () => "") as String;
    var payload = msg.getOrElse("payload", () => {}) as Map<String, dynamic>;
    switch (name) {
      case "setIdentity":
        var id = payload.getOrElse("id", () => "") as String;
        var token = payload.getOrElse("token", () => "") as String;
        authStore.login(token);
        identityStore.save(id: id);

        logger.i("setIdentity, token: $token");
        reply({});
        break;
    }
  }
}
