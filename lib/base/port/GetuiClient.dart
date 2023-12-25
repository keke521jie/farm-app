import "dart:io";

import "package:app/base/kernel/Logger.dart";
import "package:app/base/kernel/Settings.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:getuiflut/getuiflut.dart";
import "package:injectable/injectable.dart";

class GetuiState {
  String clientId = "";
  String deviceToken = "";

  GetuiState copyWith({String? clientId, String? deviceToken}) {
    return GetuiState()
      ..clientId = clientId ?? this.clientId
      ..deviceToken = deviceToken ?? this.deviceToken;
  }
}

abstract class GetuiClient extends BlocBase<GetuiState> {
  GetuiClient() : super(GetuiState());

  void configure();

  Future<String> getClientId();
}