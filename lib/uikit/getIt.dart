import "package:app/config/Injector.dart";
import "package:get_it/get_it.dart";

bool _init = false;

T getIt<T extends Object>({
  String? instanceName,
  dynamic param1,
  dynamic param2,
}) {
  if (!_init) {
    _init = true;
    configureDependencies();
  }
  return GetIt.instance.get<T>(instanceName: instanceName, param1: param1, param2: param2);
}
