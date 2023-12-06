import "package:get_it/get_it.dart";
import "package:injectable/injectable.dart";

import "Injector.config.dart";

@InjectableInit()
void configureDependencies() {
  var getIt = GetIt.instance;
  getIt.init();
}
