import 'dart:convert' as convert;

import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/chapter.dart';
import 'package:audiobooks/pages/chapter_page.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class OneBookPage extends StatefulWidget {
  final String bookId;

  const OneBookPage({Key key, this.bookId}) : super(key: key);

  @override
  _OneBookPageState createState() => _OneBookPageState();
}

class _OneBookPageState extends State<OneBookPage> {
  @override
  void initState() {
    final bookProvider = context.read<BooksProvider>();
    bookProvider.getBookById(int.parse(widget.bookId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final booksProvider = context.watch<BooksProvider>();
    final book = booksProvider.oneBook(widget.bookId);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(book.title),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GFListTile(
                titleText: book.title,
                subtitleText: 'Author: ' + book.bookAuthor,
                description: AutoSizeText(book.textHint),
                avatar: Container(
                  height: size.height * .35,
                  width: size.width * 0.2,
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: GFBorder(
                  type: GFBorderType.rRect,
                  radius: const Radius.circular(10),
                  color: (book.chapters != null)
                      ? Colors.blue
                      : Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _bookDetails(book),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: (book.chapters != null)
                            ? Column(
                                children: book.chapters
                                    .map<Widget>(
                                        (chapter) => _chapterTile(chapter))
                                    .toList(),
                              )
                            : const GFLoader(),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: const Text('play back buttons'),
    );
  }
}

Widget _bookDetails(Book book) {
  final bookGenre = book.genre.toString().substring(10);
  final textStyle = const TextStyle(color: Colors.white, fontSize: 16);
  return Card(
    color: Colors.blueGrey,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        children: [
          Container(child: AutoSizeText(bookGenre, style: textStyle)),
          const SizedBox(height: 8),
          Container(child: AutoSizeText(book.language, style: textStyle)),
          const SizedBox(height: 8),
          Container(child: AutoSizeText(book.publishYear, style: textStyle)),
          const SizedBox(height: 8),
          Container(child: AutoSizeText(book.wordCount, style: textStyle)),
          const SizedBox(height: 8),
          Container(
            child: AutoSizeText(
              book.countryOfOrigin,
              style: textStyle,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            child: AutoSizeText(
              "${book.readability}",
              style: textStyle,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _chapterTile(Chapter chapter) {
  return GFListTile(
    onTap: () async => await _navigateToChapterPage(chapter),
    titleText: chapter.title,
    subtitleText: 'Chapter Id: ' + chapter.id,
    description: AutoSizeText(chapter.textHint),
    avatar: const CircleAvatar(
      child: const Icon(FontAwesomeIcons.bookReader),
      backgroundColor: Colors.blueGrey,
    ),
    icon: const Icon(
      Icons.play_arrow,
      color: Colors.blueGrey,
    ),
  );
}

Future<void> _navigateToChapterPage(Chapter chapter) async {
  return await Get.off(ChapterPage(chapter: chapter));
}
