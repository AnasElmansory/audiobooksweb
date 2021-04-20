import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/widgets/book_widget.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage();
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with SingleTickerProviderStateMixin {
  final _pagingController = PagingController<int, Book>(firstPageKey: 1);

  @override
  void initState() {
    _handleBooksPagination(_pagingController, context);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Center(
        child: PagedGridView(
          pagingController: _pagingController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.75,
          ),
          builderDelegate: PagedChildBuilderDelegate<Book>(
            itemBuilder: (context, book, index) {
              return Container(
                child: BookWidget(book: book),
                // ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void _handleBooksPagination(
  PagingController _pagingController,
  BuildContext context,
) async {
  final bookProvider = context.read<BooksProvider>();
  _pagingController.itemList = bookProvider.books.toList();
  _pagingController.nextPageKey =
      ((bookProvider.books.length / 10) + 1).floor();
  if (bookProvider.books.isEmpty) {
    final books = await bookProvider.getBooks();
    _pagingController.appendPage(books, 2);
  }
  try {
    _pagingController.addPageRequestListener((pageKey) async {
      final books = await bookProvider.getBooks(page: pageKey);
      final isLastPage = books.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(books);
      } else {
        _pagingController.appendPage(books, pageKey + 1);
      }
    });
  } catch (error) {
    _pagingController.error = error;
  }
}
