class UserConfig {
  UserConfig({
    required this.id,
    required this.uId,
    required this.paas,
    required this.val,
    required this.status,
    required this.isExpire,
    required this.remark,
    required this.updatedAt,
    required this.sessdata,
  });

  UserConfig.fromJson(dynamic json) {
    id = json['id'] ?? "";
    uId = json['u_id'] ?? "";
    paas = json['paas'] ?? "";
    val = json['val'] ?? "";
    final _status = json['status'] ?? "";
    final _is_expire = json['is_expire'] ?? "";
    status = _status == "off";
    isExpire = _is_expire == "no";
    remark = json['remark'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    sessdata = json['sessdata'] ?? "";
  }

  late String id;
  late String uId;
  late String paas;
  late String val;
  late bool status;
  late bool isExpire;
  late String remark;
  late String updatedAt;
  late String sessdata;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['u_id'] = uId;
    map['paas'] = paas;
    map['val'] = val;
    map['status'] = status ? 'on' : 'off';
    map['is_expire'] = isExpire ? 'yes' : 'no';
    map['remark'] = remark;
    map['updated_at'] = updatedAt;
    map['sessdata'] = sessdata;
    return map;
  }
}
