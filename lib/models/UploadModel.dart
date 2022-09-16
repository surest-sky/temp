class UploadModel {
  UploadModel({
    required this.url,
  });

  UploadModel.fromJson(dynamic json) {
    url = json['url'];
  }

  late String url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }
}
