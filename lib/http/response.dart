class ResponseMap {
  late final int code;
  late final String message;
  late final dynamic data;
  ResponseMap(this.code, this.message, this.data);

  ResponseMap.formJson(Map<String, dynamic> json) {
    code = json['code'] as int;
    message = json['message'] as String;
    data = json['data'] as dynamic;
  }

  toJson() {
    return {'code': code, 'message': message, data: data.isEmpty ? {} : data};
  }
}
