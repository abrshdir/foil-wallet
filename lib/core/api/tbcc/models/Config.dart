class Config {
  late Map<String, dynamic> appSettingsJson;
  late Map<String, dynamic> updateJson;

  Config({required this.appSettingsJson, required this.updateJson});

  Config.fromJson(Map<String, dynamic> json) {
    appSettingsJson = json['app_settings'];
    updateJson = json['inner_update'];
  }
}
