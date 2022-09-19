class ListItem {
  ListItem({
    required this.dataid,
    required this.uId,
    required this.md5,
    required this.paas,
    required this.url,
    required this.type,
    required this.title,
    required this.fullText,
    required this.updatedAt,
    this.errorMsg,
  });

  ListItem.fromJson(dynamic json) {
    dataid = json['dataid'].toString();
    uId = json['u_id'] ?? "";
    md5 = json['md5'] ?? "";
    paas = json['paas'] ?? "";
    url = json['url'] ?? "";
    type = json['type'] ?? "";
    title = json['title'] ?? "";
    fullText = json['full_text'] ?? "";
    updatedAt = json['updated_at'].toString();
    errorMsg = json['errorMsg'] ?? "";
  }

  late String dataid;
  late String uId;
  late String md5;
  late String paas;
  late String url;
  late String type;
  late String title;
  late String fullText;
  late String updatedAt;
  String? errorMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dataid'] = dataid;
    map['u_id'] = uId;
    map['md5'] = md5;
    map['paas'] = paas;
    map['url'] = url;
    map['type'] = type;
    map['title'] = title;
    map['full_text'] = fullText;
    map['updated_at'] = updatedAt;
    return map;
  }
}
