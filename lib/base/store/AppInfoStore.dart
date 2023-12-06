import "package:app/base/cutil/Lazyload.dart";
import "package:app/base/cutil/StoreBase.dart";
import "package:injectable/injectable.dart";
import "package:package_info_plus/package_info_plus.dart";

class AppInfoState {
  String appId = "";
  String version = "";
  String build = "";

  AppInfoState copyWith({
    String? appId,
    String? version,
    String? build,
  }) {
    return AppInfoState()
      ..appId = appId ?? this.appId
      ..version = version ?? this.version
      ..build = build ?? this.build;
  }
}

@Singleton()
class AppInfoStore extends StoreBase<AppInfoState> {
  AppInfoStore() : super(AppInfoState());

  late final _lazyload = Lazyload<AppInfoState>(() async {
    final info = await PackageInfo.fromPlatform();
    var projectCode = info.buildNumber;
    var projectAppID = info.packageName;
    var newState = state.copyWith(
      appId: projectAppID,
      version: info.version,
      build: projectCode,
    );
    emit(newState);
    return newState;
  });

  @override
  Future<AppInfoState> get() {
    return _lazyload.get();
  }

  @override
  dirty() {
    _lazyload.dirty();
  }
}
