import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class GlobalState {
  String httpProxy = "";

  GlobalState copyWith({String? httpProxy}) {
    return GlobalState()..httpProxy = httpProxy ?? this.httpProxy;
  }
}

@Singleton()
class GlobalStore extends BlocBase<GlobalState> with HydratedMixin {
  GlobalStore() : super(GlobalState());

  @override
  GlobalState fromJson(Map<String, dynamic> json) {
    return GlobalState()..httpProxy = json["httpProxy"];
  }

  @override
  Map<String, dynamic> toJson(GlobalState state) {
    return {"httpProxy": state.httpProxy};
  }

  setHttpProxy(String value) {
    emit(state.copyWith(httpProxy: value));
  }
}
