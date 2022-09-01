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


class FoilTransactionResponse {
  String? typeName;
  String? seqNo;
  Null? assetIcon;
  String? signature;
  int? balancePos;
  int? forgedFee;
  int? flags;
  String? property1B;
  int? type;
  String? title;
  int? deadLine;
  String? recipientBirthday;
  int? assetKey;
  int? property2;
  int? property1;
  String? assetName;
  int? recipientKey;
  bool? isText;
  int? timestamp;
  int? height;
  String? creator;
  String? amount;
  String? recipientImage;
  String? property2B;
  String? publickey;
  String? assetIconMediaType;
  int? royaltyFee;
  int? confirmations;
  String? message;
  int? version;
  String? recordType;
  List<String>? tags;
  int? sequence;
  int? size;
  bool? encrypted;
  String? flagsB;
  String? recipient;
  int? invitedFee;
  String? recipientName;
  int? asset;
  String? subTypeName;
  int? feePow;
  String? actionName;

  FoilTransactionResponse(
      {this.typeName,
        this.seqNo,
        this.assetIcon,
        this.signature,
        this.balancePos,
        this.forgedFee,
        this.flags,
        this.property1B,
        this.type,
        this.title,
        this.deadLine,
        this.recipientBirthday,
        this.assetKey,
        this.property2,
        this.property1,
        this.assetName,
        this.recipientKey,
        this.isText,
        this.timestamp,
        this.height,
        this.creator,
        this.amount,
        this.recipientImage,
        this.property2B,
        this.publickey,
        this.assetIconMediaType,
        this.royaltyFee,
        this.confirmations,
        this.message,
        this.version,
        this.recordType,
        this.tags,
        this.sequence,
        this.size,
        this.encrypted,
        this.flagsB,
        this.recipient,
        this.invitedFee,
        this.recipientName,
        this.asset,
        this.subTypeName,
        this.feePow,
        this.actionName});

  FoilTransactionResponse.fromJson(Map<String, dynamic> json) {
    typeName = json['type_name'];
    seqNo = json['seqNo'];
    assetIcon = json['asset_icon'];
    signature = json['signature'];
    balancePos = json['balancePos'];
    forgedFee = json['forgedFee'];
    flags = json['flags'];
    property1B = json['property1B'];
    type = json['type'];
    title = json['title'];
    deadLine = json['deadLine'];
    recipientBirthday = json['recipient_birthday'];
    assetKey = json['assetKey'];
    property2 = json['property2'];
    property1 = json['property1'];
    assetName = json['asset_name'];
    recipientKey = json['recipient_key'];
    isText = json['isText'];
    timestamp = json['timestamp'];
    height = json['height'];
    creator = json['creator'];
    amount = json['amount'];
    recipientImage = json['recipient_image'];
    property2B = json['property2B'];
    publickey = json['publickey'];
    assetIconMediaType = json['asset_iconMediaType'];
    royaltyFee = json['royaltyFee'];
    confirmations = json['confirmations'];
    message = json['message'];
    version = json['version'];
    recordType = json['record_type'];
    tags = json['tags'].cast<String>();
    sequence = json['sequence'];
    size = json['size'];
    encrypted = json['encrypted'];
    flagsB = json['flagsB'];
    recipient = json['recipient'];
    invitedFee = json['invitedFee'];
    recipientName = json['recipient_name'];
    asset = json['asset'];
    subTypeName = json['sub_type_name'];
    feePow = json['feePow'];
    actionName = json['actionName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_name'] = this.typeName;
    data['seqNo'] = this.seqNo;
    data['asset_icon'] = this.assetIcon;
    data['signature'] = this.signature;
    data['balancePos'] = this.balancePos;
    data['forgedFee'] = this.forgedFee;
    data['flags'] = this.flags;
    data['property1B'] = this.property1B;
    data['type'] = this.type;
    data['title'] = this.title;
    data['deadLine'] = this.deadLine;
    data['recipient_birthday'] = this.recipientBirthday;
    data['assetKey'] = this.assetKey;
    data['property2'] = this.property2;
    data['property1'] = this.property1;
    data['asset_name'] = this.assetName;
    data['recipient_key'] = this.recipientKey;
    data['isText'] = this.isText;
    data['timestamp'] = this.timestamp;
    data['height'] = this.height;
    data['creator'] = this.creator;
    data['amount'] = this.amount;
    data['recipient_image'] = this.recipientImage;
    data['property2B'] = this.property2B;
    data['publickey'] = this.publickey;
    data['asset_iconMediaType'] = this.assetIconMediaType;
    data['royaltyFee'] = this.royaltyFee;
    data['confirmations'] = this.confirmations;
    data['message'] = this.message;
    data['version'] = this.version;
    data['record_type'] = this.recordType;
    data['tags'] = this.tags;
    data['sequence'] = this.sequence;
    data['size'] = this.size;
    data['encrypted'] = this.encrypted;
    data['flagsB'] = this.flagsB;
    data['recipient'] = this.recipient;
    data['invitedFee'] = this.invitedFee;
    data['recipient_name'] = this.recipientName;
    data['asset'] = this.asset;
    data['sub_type_name'] = this.subTypeName;
    data['feePow'] = this.feePow;
    data['actionName'] = this.actionName;
    return data;
  }
}

