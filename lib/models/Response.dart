class Response {
  Response({
    required this.code,
    required this.time,
    required this.msg,
    required this.data,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  late int code;
  late int time;
  late String msg;
  late List<dynamic> data;
  late int page;
  late int pageSize;
  late int total;

  Response.fromJson(dynamic json) {
    code = json['code'];
    time = json['time'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = json['data'];
    }
    page = json['page'];
    pageSize = json['page_size'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['time'] = time;
    map['msg'] = msg;
    map['data'] = [];
    map['page'] = page;
    map['page_size'] = pageSize;
    map['total'] = total;
    return map;
  }
}
