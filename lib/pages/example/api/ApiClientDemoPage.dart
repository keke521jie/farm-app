import "package:app/base/api/ApiClient.dart";
import "package:app/base/cutil/LoggerFactory.dart";
import "package:app/uikit/getIt.dart";
import "package:app/uikit/util/AfterLayoutMixin.dart";
import "package:flutter/material.dart";

class ApiClientDemoPage extends StatefulWidget {
  const ApiClientDemoPage({super.key});

  @override
  _ApiClientDemoState createState() => _ApiClientDemoState();
}

class _ApiClientDemoState extends State<ApiClientDemoPage> with AfterLayoutMixin {
  final _logger = LoggerFactory.getLogger();

  @override
  Future<void> afterFirstLayout(BuildContext context) async {
    var apiClient = getIt<ApiClient>();

    // try {
    //   dynamic data = {
    //     'phone': '+17079263321',
    //     'otp': '666666',
    //   };
    //
    //   var echoResult = await apiClient.user.localizedError(data);
    //   _logger.i("-------------- $echoResult");
    // } catch (error) {
    //   if (error is RestRequestError) {
    //     _logger.i("-------------- ${error.localizedDescription}");
    //   }
    //   _logger.i("-------------- $error");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return const Center();
  }
}
