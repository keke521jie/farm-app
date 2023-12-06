import "package:hydrated_bloc/hydrated_bloc.dart";
import "package:injectable/injectable.dart";

class SettingsState {
  int brotherThought = 3;
  String openAIEngine = "gpt-3.5-turbo";
  bool domainRanking = false;

  SettingsState copyWith({int? brotherThought, String? openAIEngine, bool? domainRanking}) {
    return SettingsState()
      ..openAIEngine = openAIEngine ?? this.openAIEngine
      ..brotherThought = brotherThought ?? this.brotherThought
      ..domainRanking = domainRanking ?? this.domainRanking;
  }
}

@Singleton()
class SettingsStore extends BlocBase<SettingsState> with HydratedMixin {
  SettingsStore() : super(SettingsState());

  @override
  SettingsState fromJson(Map<String, dynamic> json) {
    return SettingsState()
      ..openAIEngine = json["openAIEngine"] ?? "gpt-3.5-turbo"
      ..brotherThought = json["brotherThought"] ?? 3
      ..domainRanking = json["domainRanking"] ?? false;
  }

  @override
  Map<String, dynamic> toJson(SettingsState state) {
    return {
      "brotherThought": state.brotherThought,
      "openAIEngine": state.openAIEngine,
      "domainRanking": state.domainRanking
    };
  }

  setBrotherThought(int value) {
    emit(state.copyWith(brotherThought: value));
  }

  void setOpenAIEngine(String value) {
    emit(state.copyWith(openAIEngine: value));
  }

  void setDomainRanking(bool value) {
    emit(state.copyWith(domainRanking: value));
  }
}
