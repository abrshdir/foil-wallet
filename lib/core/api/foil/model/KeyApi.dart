class KeyApi {
  String? privateKey;
  String? address;
  String? seed;
  String? pubKey;

  KeyApi({this.privateKey, this.address, this.seed, this.pubKey});

  KeyApi.fromJson(Map<String, dynamic> json) {
    privateKey = json['privateKey'];
    address = json['address'];
    seed = json['seed'];
    pubKey = json['pubKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['privateKey'] = this.privateKey;
    data['address'] = this.address;
    data['seed'] = this.seed;
    data['pubKey'] = this.pubKey;
    return data;
  }
}
