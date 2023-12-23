import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class IdentityState {
  String id = "";
  IdentityState copyWith({String? id}) {
    return IdentityState()..id = id ?? this.id;
  }
}

@Singleton()
class IdentityStore extends BlocBase<IdentityState> with HydratedMixin {
  IdentityStore() : super(IdentityState());

  void save({required String id}) {
    emit(state.copyWith(id: id));
  }

  @override
  IdentityState fromJson(Map<String, dynamic> json) {
    return IdentityState()..id = json["id"];
  }

  @override
  Map<String, dynamic> toJson(IdentityState state) {
    return {"id": state.id};
  }
}
