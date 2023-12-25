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

    headers["Content-Type"] = "application/json;charset=UTF-8";

    if (authStore.state.token.isNotEmpty) {
      headers["Authorization"] = "token ${authStore.state.token}";
    }

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
