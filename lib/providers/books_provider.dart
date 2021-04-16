import 'dart:collection';

import 'package:audiobooks/api/books/books_service.dart';
import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/get_it.dart';
import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class BooksProvider extends ChangeNotifier {
  final BooksService _booksService = getIt<BooksService>();
  final BuildContext _context;
  final AuthProviders _authProvider;
  BooksProvider(this._context, this._authProvider);

  Set _books = Set();
  Set get books => this._books;
  set books(Set value) {
    _books.addAll(value);
    notifyListeners();
  }

  Future<List<Book>> getBooks() async {
    final userProvider = _context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _booksService.getBooks(
      token: token,
      provider: _authProvider,
    );
    books = result.toSet();
    return this.books.toList();
  }

  Future<Book> getBookById(
    int id,
  ) async {
    final userProvider = _context.read<UserProvider>();
    final token = await userProvider.getToken();
    final book = await _booksService.getBookById(
      id,
      token: token,
      provider: _authProvider,
    );
    return book;
  }
}
