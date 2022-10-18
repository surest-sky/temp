class Validate {
  RegExp phone = RegExp(
      r"((13[4-9]|14[7-8]|15[0-27-9]|178|18[2-47-8]|198|13[0-2]|14[5-6]|15[5-6]|166|17[5-6]|18[5-6]|133|149|153|17[37]|18[0-19]|199|17[0-1])[0-9]{8})");

  dynamic validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return '手机号码不要为空';
    }

    if (!phone.hasMatch(value)) {
      return '手机号码格式错误';
    }

    return null;
  }

  dynamic validateName(String? value) {
    if (value == null || value.isEmpty) {
      return '用户名称不要为空';
    }

    if (value.length < 1 || value.length > 16) {
      return '用户名称请保持在 1~16 ';
    }

    return null;
  }

  dynamic validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '密码不要为空';
    }

    if (value.length < 6 || value.length > 16) {
      return '密码长度请保持在 6~16 ';
    }

    return null;
  }

  dynamic validateConfirmPassword(String? value, String? password) {
    final message = validatePassword(value);
    if (message != null) {
      return message;
    }

    if (value != password) {
      return "确认密码和密码输入不一致";
    }
    return null;
  }

  dynamic validateAreaCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请选择区号';
    }

    return null;
  }

  dynamic validateCode(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入验证码';
    }

    return null;
  }

  dynamic validateRequired(String? value, {String? label}) {
    if (value == null || value.isEmpty) {
      return label ?? "请输入";
    }

    return null;
  }
}
