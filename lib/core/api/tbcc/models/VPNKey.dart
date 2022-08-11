class VPNKey {
  late String key;
  late int validity;
  String? txHash;
  DateTime? timestamp;

  VPNKey(this.key, this.validity, this.txHash);

  VPNKey.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    validity = json['validity'];
    txHash = json['txHash'];
    timestamp = DateTime.tryParse(json['timestamp'] ?? '');
  }
}
