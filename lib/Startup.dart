import "dart:async";
import "dart:io";

import "package:app/base/cutil/LoggerFactory.dart";
import "package:app/base/kernel/EventBus.dart";
import "package:app/base/kernel/Logger.dart";
import "package:app/base/msg/UnauthorizedMsg.dart";
import "package:app/base/store/AuthStore.dart";
import "package:app/infra/getui/GetuiClient.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";
import "package:path_provider/path_provider.dart";

import "Local.dart";

@Singleton()
class Startup {
  late final AuthStore _authStore;
  late final GetuiClient _getuiClient;

  Startup(this._authStore, this._getuiClient);

  Future<void> onCreated() async {
    if (kDebugMode) {
      await Local.onWillCreated();
    }

    var logger = LoggerFactory.getLogger();
    logger.i("launching");

    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (FlutterErrorDetails details) {
      handleError(details);
    };

    Directory directory = await getApplicationDocumentsDirectory();
    Directory store = Directory("${directory.path}/store");
    if (!await store.exists()) {
      store.create();
    }

    Bloc.observer = AppBlocObserver();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: store,
    );

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
        ),
      );
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    }

    eventbus.on<UnauthorizedMsg>(_handleUnauthorizedMsg);

    _getuiClient.configure();

    if (kDebugMode) {
      await Local.onDidCreated();
    }
  }
}

extension HandleError on Startup {
  handleError(FlutterErrorDetails details) {
    if (kReleaseMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  }
}

extension HandleMsg on Startup {
  Future<void> _handleUnauthorizedMsg(msg) async {
    logger.i("StartedHomeMsg");
  }
}

class AppBlocObserver extends BlocObserver {}
