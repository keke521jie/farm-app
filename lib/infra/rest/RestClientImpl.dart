import "dart:convert";
import "dart:io";

import "package:app/base/cutil/RestClient.dart";
import "package:app/base/kernel/Properties.dart";
import "package:app/base/kernel/Settings.dart";
import "package:dartx/dartx.dart";
import "package:dio/adapter.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:injectable/injectable.dart";
import "package:pretty_dio_logger/pretty_dio_logger.dart";

import "RestClientAdapter.dart";

@Singleton(as: RestClient)
class RestClientImpl extends RestClientBase {
  RestClientImpl({
    required RestClientAdapter restAdapter,
  }) : super(Dio()) {
    dio.options.baseUrl = settings.baseUrl;
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 90));
    (dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          restAdapter.onRequest(options);
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (e, handler) {
          restAdapter.onError(e);
          return handler.next(e);
        },
      ),
    );

    var adapter = dio.httpClientAdapter as DefaultHttpClientAdapter;
    adapter.onHttpClientCreate = (client) {
      client.badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port,
      ) {
        return true;
      };

      if (properties.findProxy.isNotNullOrBlank) {
        client.findProxy = (uri) {
          return properties.findProxy ?? "";
        };
      }
      return null;
    };
  }
}

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

_parseJson(String text) {
  return compute(_parseAndDecode, text);
}
