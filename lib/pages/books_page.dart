import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/widgets/book_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage();
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _handleBooksPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BooksProvider>().controller;
    return Container(
      color: Colors.black12,
      child: Center(
        child: PagedGridView(
          pagingController: controller,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.7,
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

void _handleBooksPagination() async {
  final booksProvider = Get.context.read<BooksProvider>();
  final controller = booksProvider.controller;
  try {
    controller.addPageRequestListener((pageKey) async {
      final books = await booksProvider.getBooks(page: pageKey);
      final isLastPage = books.length < 10;
      if (isLastPage) {
        controller.appendLastPage(books);
      } else {
        controller.appendPage(books, pageKey + 1);
      }
    });
  } catch (error) {
    controller.error = error;
  }
}
