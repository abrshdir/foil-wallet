import 'VPNKey.dart';

class TBCCUserModel {
  int? id;
  late String address;
  double? paidFee;
  double? paidSmartCard;
  double? gotTbcSmartCard;
  List<VPNKey>? vpnKeys;
  DateTime? subPurchaseDate;
  int? lottery_accepted_count;

  TBCCUserModel({
    this.id,
    required this.address,
    this.paidFee,
    this.paidSmartCard,
    this.gotTbcSmartCard,
    this.vpnKeys,
    this.subPurchaseDate,
    this.lottery_accepted_count,
  });

  TBCCUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    paidFee = json['paid_fee'];
    paidSmartCard = json['paid_smart_card'];
    subPurchaseDate = json['sub_purchase_date'] != null ? DateTime.tryParse(json['sub_purchase_date']) : null;
    if (json['vpn_keys'] != null) {
      vpnKeys = [for (var key in json['vpn_keys']) VPNKey.fromJson(key)];
    } else {
      vpnKeys = [];
    }
  }
}
