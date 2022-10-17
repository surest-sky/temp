import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:getwidget/getwidget.dart';
import 'package:kwh/enums/NoteType.dart';
import 'package:kwh/http/apis.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kwh/services/NoteService.dart';

import '../../components/widgets/CustomModule.dart';

class ImageAddPage extends StatefulWidget {
  const ImageAddPage({Key? key}) : super(key: key);

  @override
  State<ImageAddPage> createState() => _ImageAddPageState();
}

class _ImageAddPageState extends State<ImageAddPage> {
  final ImagePicker _picker = ImagePicker();
  final service = NoteService();
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
    final map = await Apis.uploadFileApi(_imgBase64);
    if (map.code != 200) {
      EasyLoading.showToast("服务器响应超时");
      return "";
    }
    return map.data['oss_url'];
  }

  _submitOcr() async {
    // EasyLoading.show(status: "图片上传中...");
    // final String url = await _uploadImage().whenComplete(() => EasyLoading.dismiss());
    // if(url.isEmpty) {
    //   return;
    // }
    EasyLoading.show(status: "图片上传中...");
    final map = await service
        .submitOcr(_imgBase64)
        .whenComplete(() => EasyLoading.dismiss());
    if (map.code == 200) {
      EasyLoading.showToast("提交完成");
      setState(() {
        _imagePath = "";
      });
    } else {
      EasyLoading.showToast("服务器响应超时");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 0.5;
    return Container(
      height: height,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.only(top: 0, right: 20, left: 20, bottom: 20),
        child: Column(children: [
          SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "取消",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Text(
                  CustomModule.noteTitle(NoteType.ocr),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                GFButton(
                  size: GFSize.SMALL,
                  onPressed: () => _submitOcr(),
                  child: const Text("保存"),
                )
              ],
            ),
          ),
          DottedBorder(
            color: Colors.black26,
            strokeWidth: 1,
            child: InkWell(
              onTap: _imageSelect,
              child: Container(
                width: width,
                height: height - 100,
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
          )
        ],),
      ),
    );
  }
}
