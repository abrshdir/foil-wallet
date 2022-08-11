class InnerUpdate {
  int? actualVersion;
  bool? force;
  String? url;
  String? md5;

  InnerUpdate.fromJson(Map<String, dynamic> json) {
    actualVersion = json['version'] is int ? json['version'] : int.tryParse(json['version'] ?? '-1');
    force = json['force'];
    url = json['link'];
    md5 = json['md5'];
  }
}
