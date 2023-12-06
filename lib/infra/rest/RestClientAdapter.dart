import "package:app/base/kernel/EventBus.dart";
import "package:app/base/msg/UnauthorizedMsg.dart";
import "package:app/base/store/AppInfoStore.dart";
import "package:app/base/store/AuthStore.dart";
import "package:dio/dio.dart";
import "package:injectable/injectable.dart";

@Singleton()
class RestClientAdapter {
  RestClientAdapter(this.authStore, this.appInfoStore);

  final AuthStore authStore;
  final AppInfoStore appInfoStore;

  Future<Map<String, String>> getHeaders() async {
    var headers = <String, String>{};

    var appInfo = await appInfoStore.get();
    headers.addAll({
      "App-Bundle": appInfo.appId,
      "App-Build": appInfo.build,
      "App-Version": appInfo.version,
    });

    //var amplitudeDeviceId = analytics.getAmplitudeDeviceId()
    headers["Content-Type"] = "application/json;charset=UTF-8";
    //headers['X-Brain-User-Tz'] = TimeZone.current.identifier;

    // if(executionId.value.nonEmpty) {
    // headers['X-Brain-Exec-Id'] = executionId.value;
    // }

    // if let value = store.state.app.localtion {
    // headers['X-Brain-User-Location'] = '\(value.latitude),\(value.longitude)'
    // }

    if (authStore.state.token.isNotEmpty) {
      headers["Authorization"] = "token ${authStore.state.token}";
    }

    // apollo

    // if store.state.app.nlpSessionId.nonEmpty {
    // headers['X-Brain-Nlp-Session-Id'] = store.state.app.nlpSessionId
    // }
    //
    // if store.state.app.interaction.nonEmpty {
    // headers['X-Brain-Interaction'] = store.state.app.interaction
    // }
    //
    // if !amplitudeDeviceId.isEmpty {
    // headers['X-Brain-Amplitude-Device-Id'] = amplitudeDeviceId
    // }

    return headers;
  }

  Future<void> onRequest(RequestOptions options) async {
    var headers = await getHeaders();
    options.headers.addAll(headers);
  }

  Future<void> onError(DioError error) async {
    var statusCode = error.response?.statusCode ?? 999;
    if ([403, 401].contains(statusCode) && authStore.state.token.isNotEmpty) {
      authStore.emit(authStore.state.copyWith(token: ""));
      eventbus.emit(UnauthorizedMsg(statusCode));
    }
  }
}
