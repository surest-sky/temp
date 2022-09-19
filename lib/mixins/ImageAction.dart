
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../http/apis.dart';

mixin ImageAction {
  late final String _imagePath;
  late final String _imgBase64;

  imageSelect({required Function(String _path, String _base64) complete,}) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? _tempImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (_tempImage != null) {
      _imagePath = _tempImage.path;
      var _imageFile = File(_imagePath);
      var imageBytes = await _imageFile.readAsBytes();
      _imgBase64 = base64Encode(imageBytes);
      complete(_imgBase64, _imagePath);
    }
  }

  Future<String> uploadImage() async {
    FormData formData = FormData.fromMap({
      "base64_str": _imgBase64
    });
    final map = await Apis.uploadApi(formData);
    if (map.code != 200) {
      EasyLoading.showToast("服务器响应超时");
      return "";
    }

    return map.data['url'];
  }

  getImagePath() {
    return _imagePath;
  }

  getImgBase64() {
    return _imgBase64;
  }
}