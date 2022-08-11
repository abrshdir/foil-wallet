class NewsModel {
  int? id;
  String? header;
  String? preview;
  DateTime? timestamp;
  String? previewImageUrl;
  String? content;

  NewsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    header = json['header'];
    preview = json['preview'];
    timestamp = DateTime.tryParse(json['timestamp']);
    previewImageUrl = json['preview_image_url'];
    content = json['content'];
  }
}
