class Settings {
  var baseUrl = "";

  Settings.fromJson(Map<String, dynamic> json) {
    baseUrl = json["baseUrl"] ?? "";
  }
}

Settings settings = Settings.fromJson({
  "baseUrl": "https://api-dev.braininc.net",
});
