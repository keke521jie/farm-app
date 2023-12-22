import "package:app/base/kernel/Logger.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/uikit/clip/ClipMsgHandler.dart";
import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:injectable/injectable.dart";

@Injectable()
class MsgHandler extends ClipMsgHandler {
  AuthStore authStore;

  MsgHandler(this.authStore);

  @override
  void handle(BuildContext context, Map<String, dynamic> msg, void Function(Map<String, dynamic> payload) reply) {
    var name = msg.getOrElse("name", () => "") as String;
    var payload = msg.getOrElse("payload", () => {}) as Map<String, dynamic>;
    switch (name) {
      case "setAuthentication":
        var token = payload.getOrElse("token", () => "") as String;
        authStore.login(token);

        logger.i("setAuthentication, token: $token");
        reply({});
        break;
    }
  }
}
