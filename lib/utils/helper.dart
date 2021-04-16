import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/chapter.dart';
import 'package:dio/dio.dart';

extension BookX on Response {
  Book _extractBook() {
    final book = (this.data as List)
        .map<Book>(
            (book) => (book['loai'] == 'book') ? Book.fromMap(book) : null)
        .toList()
        .single;
    return book;
  }

  List<Chapter> _extractChapters() {
    final chapters = (this.data as List).map<Chapter>((chapter) =>
        (chapter['loai'] == 'chapter') ? Chapter.fromMap(chapter) : null);
    return chapters;
  }

  Book constructBook() {
    final book = _extractBook();
    final chapters = _extractChapters();
    return book.copyWith(chapters: chapters);
  }
}
