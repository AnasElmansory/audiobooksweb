import 'package:audiobooks/api/books/books_service.dart';
import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class BooksProvider extends ChangeNotifier {
  final BooksService _booksService;
  BooksProvider(this._booksService);

  final _pagingController = PagingController<int, Book>(firstPageKey: 1);
  PagingController<int, Book> get controller => this._pagingController;

  Set<Book> _books = Set<Book>();
  Set<Book> get books => this._books;
  set books(Set<Book> value) {
    this._books.addAll(value);
    notifyListeners();
  }

  Book oneBook(String bookId) => _books.singleWhere((bk) => bk.id == bookId);

  Future<List<Book>> getBooks({int page, int pageSize}) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _booksService.getBooks(
      token,
      page: page,
      pageSize: pageSize,
    );
    books = result?.toSet();
    return result;
  }

  Future<Book> getBookById(int id) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final book = await _booksService.getBookById(
      id,
      token: token,
    );
    final updatedBook = books
        .firstWhere((bk) => bk.id == book.id)
        .copyWith(chapters: book.chapters);

    books.update(updatedBook);
    notifyListeners();
    return book;
  }

  @override
  void dispose() {
    this._pagingController.dispose();
    super.dispose();
  }
}
