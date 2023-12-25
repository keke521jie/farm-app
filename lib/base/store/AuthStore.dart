import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class AuthState {
  String token = "7d4adce86aab3c2a281d7b15e6a82012d86bcbf6";

  AuthState copyWith({String? token}) {
    return AuthState()..token = token ?? this.token;
  }
}

@Singleton()
class AuthStore extends BlocBase<AuthState> with HydratedMixin {
  AuthStore() : super(AuthState());

  void login(String token) {
    emit(state.copyWith(token: token));
  }

  void logout() {
    emit(state.copyWith(token: ""));
  }

  @override
  AuthState fromJson(Map<String, dynamic> json) {
    // return AuthState()..token = "7d4adce86aab3c2a281d7b15e6a82012d86bcbf6"; // json['token']
    return AuthState()..token = json["token"];
  }

  @override
  Map<String, dynamic> toJson(AuthState state) {
    return {"token": state.token};
  }

  bool get isLoggedIn {
    return state.token.isNotEmpty;
  }
}
