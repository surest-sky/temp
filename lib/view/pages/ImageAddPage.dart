import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kwh/http/apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/services/ListService.dart';

class ImageAddPage extends StatefulWidget {
  const ImageAddPage({Key? key}) : super(key: key);

  @override
  State<ImageAddPage> createState() => _ImageAddPageState();
}

class _ImageAddPageState extends State<ImageAddPage> {
  final ImagePicker _picker = ImagePicker();
  final service = ListService();
  String _imagePath = "";
  late String _imgBase64;

  _imageSelect() async {
    final XFile? _tempImage =
    await _picker.pickImage(source: ImageSource.gallery);
    if (_tempImage != null) {
      setState(() {
        _imagePath = _tempImage.path;
      });
      var _imageFile = File(_imagePath);
      var imageBytes = await _imageFile.readAsBytes();
      _imgBase64 = base64Encode(imageBytes);
    }
  }

  Future<String> uploadImage() async {
    FormData formData = FormData.fromMap({
      "base64_str": _imgBase64
    });
    final map = await Apis.uploadFileApi(formData);
    if (map.code != 200) {
      EasyLoading.showToast("服务器响应超时");
      return "";
    }

   return map.data['url'];
  }

  _submitOcr() async {
    // EasyLoading.show(status: "图片上传中...");
    // final String url = await _uploadImage().whenComplete(() => EasyLoading.dismiss());
    // if(url.isEmpty) {
    //   return;
    // }
    EasyLoading.show(status: "图片上传中...");
    final map = await service.submitOcr(_imgBase64).whenComplete(() => EasyLoading.dismiss());
    if(map.code == 200) {
      EasyLoading.showToast("提交完成");
      setState(() {
        _imagePath = "";
      });
    }else{
      EasyLoading.showToast("服务器响应超时");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2),
          child: DottedBorder(
            color: Colors.black26,
            strokeWidth: 1,
            child: InkWell(
              onTap: _imageSelect,
              child: Container(
                width: width,
                height: 250,
                child: _imagePath.isNotEmpty
                    ? Image.asset(
                  _imagePath,
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload),
                    Text(
                      "图片上传",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        GFButton(
          onPressed: _submitOcr,
          text: "提交",
          fullWidthButton: true,
        ),
      ],

    );
  }
}
