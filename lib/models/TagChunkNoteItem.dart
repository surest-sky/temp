import 'package:kwh/models/NoteItem.dart';

class TagChunkNoteItem {
  TagChunkNoteItem({required this.chunkDate, required this.notes});

  TagChunkNoteItem.fromJson(String _chunkDate, List<NoteItem> _notes) {
    chunkDate = _chunkDate;
    notes = _notes;
  }

  late String chunkDate;
  late List<NoteItem> notes;
}
