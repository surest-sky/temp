class LoginUser {
  LoginUser({
    required this.name,
    required this.phone,
    required this.email,
    required this.idkey,
    required this.uId,
    required this.dataUrl,
    required this.createdAt,
    required this.wxopenid,
    required this.deletedAt,
    required this.avatar,
    required this.errorMsg,
  });

  LoginUser.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    phone = json['phone'] ?? "";
    email = json['email'] ?? "";
    idkey = json['idkey'] ?? "";
    uId = json['u_id'] ?? "";
    dataUrl = json['data_url'] ?? "";
    createdAt = json['created_at'] ?? "";
    wxopenid = json['wxopenid'] ?? "";
    deletedAt = json['deleted_at'] ?? "";
    avatar = json['avatar'] ?? "";
    errorMsg = json['errorMsg'] ?? "";
  }

  late String name;
  late String phone;
  late String email;
  late String idkey;
  late String uId;
  late String dataUrl;
  late String createdAt;
  late String wxopenid;
  late String deletedAt;
  late String avatar;
  late String errorMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['phone'] = phone;
    map['email'] = email;
    map['idkey'] = idkey;
    map['u_id'] = uId;
    map['data_url'] = dataUrl;
    map['created_at'] = createdAt;
    map['wxopenid'] = wxopenid;
    map['deleted_at'] = deletedAt;
    map['avatar'] = avatar;
    return map;
  }
}
