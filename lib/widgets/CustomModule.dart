import '../../enums/NoteType.dart';

class CustomModule {
  static String noteTitle(String type) {
    if (type == NoteType.text) {
      return "添加笔记";
    }
    if (type == NoteType.ocr) {
      return "添加图片";
    }

    return "添加网址";
  }
}
