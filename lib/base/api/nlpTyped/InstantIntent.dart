import "package:json_annotation/json_annotation.dart";

part "InstantIntent.g.dart";

@JsonSerializable()
class InstantIntent {
  String? api;
  String? description;
  String? engine;
  num? frequency_penalty;
  num max_tokens;
  String? model_name;
  num? presence_penalty;
  String? prompt;
  List<String>? stop;
  num? temp;
  num temperature;

  InstantIntent({
    this.api,
    this.description,
    this.engine,
    this.frequency_penalty,
    this.max_tokens = 0,
    this.model_name,
    this.presence_penalty,
    this.prompt,
    this.stop,
    this.temp,
    this.temperature = 0,
  });

  factory InstantIntent.fromJson(Map<String, dynamic> json) => _$InstantIntentFromJson(json);

  Map<String, dynamic> toJson() => _$InstantIntentToJson(this);
}
