class WhatsNew {
  int? id;
  int? build;
  DateTime? timestamp;
  String? text_en;
  String? text_ru;
  String? text_zh;

  WhatsNew.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    build = json['build'];
    timestamp = DateTime.parse(json['timestamp']);
    text_en = json['text_en'];
    text_ru = json['text_ru'];
    text_zh = json['text_zh'];
  }
}
