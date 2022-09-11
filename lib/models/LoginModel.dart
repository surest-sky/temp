class LoginModel {
  LoginModel({
    this.name,
    this.phone,
    this.email,
    this.idkey,
    this.uId,
    this.dataUrl,
    this.createdAt,
    this.wxopenid,
    this.deletedAt,
    this.avatar,
    required this.errorMsg,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    idkey = json['idkey'];
    uId = json['u_id'];
    dataUrl = json['data_url'];
    createdAt = json['created_at'];
    wxopenid = json['wxopenid'];
    deletedAt = json['deleted_at'];
    avatar = json['avatar'];
    errorMsg = json['errorMsg'] ?? "";
  }

  String? name;
  String? phone;
  String? email;
  String? idkey;
  String? uId;
  String? dataUrl;
  String? createdAt;
  String? wxopenid;
  String? deletedAt;
  String? avatar;
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
