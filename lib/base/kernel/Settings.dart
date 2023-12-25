class Settings {
  var baseUrl = "";
  var getuiAppId = "";
  var getuiAppKey = "";
  var getuiAppSecret = "";

  Settings.fromJson(Map<String, dynamic> json) {
    baseUrl = json["baseUrl"] ?? "";
    getuiAppId = json["getuiAppId"] ?? "";
    getuiAppKey = json["getuiAppKey"] ?? "";
    getuiAppSecret = json["getuiAppSecret"] ?? "";
  }
}

Settings settings = Settings.fromJson({
  "baseUrl": "https://api-dev.braininc.net",
  "getuiAppId": "MBNiWcrEZo75YMXejwg4J2",
  "getuiAppKey": "aTMnEu9zSEAga4iXguaKQ6",
  "getuiAppSecret": "1llEjE2wna5arR5HgwbciA"
});
