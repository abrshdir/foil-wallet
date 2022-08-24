class FolTransactionInfo {
  String? typeName;
  String? creator;
  String? data;
  String? signature;
  String? fee;
  String? publickey;
  int? type;
  int? confirmations;
  int? version;
  String? recordType;
  int? sequence;
  int? size;
  int? timestamp;
  int? height;
  int? property1;
  int? property2;
  String? subTypeName;
  String? title;
  String? message;
  bool? encrypted;
  String? recipient;
  bool? isText;
  String? head;

  FolTransactionInfo(
      {this.typeName,
        this.creator,
        this.data,
        this.signature,
        this.fee,
        this.publickey,
        this.type,
        this.confirmations,
        this.version,
        this.recordType,
        this.sequence,
        this.size,
        this.timestamp,
        this.height,
        this.property1,
        this.property2,
        this.subTypeName,
        this.title,
        this.message,
        this.encrypted,
        this.recipient,
        this.isText,
        this.head});

  FolTransactionInfo.fromJson(Map<String, dynamic> json) {
    typeName = json['type_name'];
    creator = json['creator'];
    data = json['data'];
    signature = json['signature'];
    fee = json['fee'];
    publickey = json['publickey'];
    type = json['type'];
    confirmations = json['confirmations'];
    version = json['version'];
    recordType = json['record_type'];
    sequence = json['sequence'];
    size = json['size'];
    timestamp = json['timestamp'];
    height = json['height'];
    property1 = json['property1'];
    property2 = json['property2'];
    subTypeName = json['sub_type_name'];
    title = json['title'];
    message = json['message'];
    encrypted = json['encrypted'];
    recipient = json['recipient'];
    isText = json['isText'];
    head = json['head'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_name'] = this.typeName;
    data['creator'] = this.creator;
    data['data'] = this.data;
    data['signature'] = this.signature;
    data['fee'] = this.fee;
    data['publickey'] = this.publickey;
    data['type'] = this.type;
    data['confirmations'] = this.confirmations;
    data['version'] = this.version;
    data['record_type'] = this.recordType;
    data['sequence'] = this.sequence;
    data['size'] = this.size;
    data['timestamp'] = this.timestamp;
    data['height'] = this.height;
    data['property1'] = this.property1;
    data['property2'] = this.property2;
    data['sub_type_name'] = this.subTypeName;
    data['title'] = this.title;
    data['message'] = this.message;
    data['encrypted'] = this.encrypted;
    data['recipient'] = this.recipient;
    data['isText'] = this.isText;
    data['head'] = this.head;
    return data;
  }
}
