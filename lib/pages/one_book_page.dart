import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/chapter.dart';
import 'package:audiobooks/pages/chapter_page.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/widgets/review_form_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add_comment),
        onPressed: () async => await Get.dialog(
          ReviewForm(book: book),
        ),
      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                titleText: book.title,
                subtitleText: 'by ' + book.bookAuthor,
                description: AutoSizeText(
                  book.textHint,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                avatar: FadeInImage.assetNetwork(
                  image: corsBridge + book.bookImage,
                  placeholder: 'asset/images/book_placeholder.jpg',
                  imageErrorBuilder: (context, _, __) {
                    return const Image(
                        image: const AssetImage(
                            'asset/images/book_placeholder.jpg'));
                  },
                  height: size.height * .35,
                  width: size.width * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * .1),
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
  final bookLanguage = book.language.split(':');
  final bookPublishYear = book.publishYear.split(':');
  final bookReadability = book.readability.split(':');
  final bookCountryOfOrigin = book.countryOfOrigin.split(':');
  final bookWordsCount = book.wordCount.split(':');
  final textStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black45,
  );
  final headerStyle = const TextStyle(
    color: const Color(0xFF263238),
    // color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  return Container(
    color: Colors.black26,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(text: 'Genre: ', style: headerStyle),
              TextSpan(text: bookGenre, style: textStyle)
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(
                text: bookLanguage.first,
                style: headerStyle,
              ),
              const TextSpan(text: ': '),
              TextSpan(text: bookLanguage.last, style: textStyle)
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(
                text: bookPublishYear.first,
                style: headerStyle,
              ),
              const TextSpan(text: ': '),
              TextSpan(text: bookPublishYear.last, style: textStyle)
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(
                text: bookWordsCount.first,
                style: headerStyle,
              ),
              const TextSpan(text: ': '),
              TextSpan(text: bookWordsCount.last, style: textStyle)
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(
                text: bookCountryOfOrigin.first,
                style: headerStyle,
              ),
              const TextSpan(text: ': '),
              TextSpan(text: bookCountryOfOrigin.last, style: textStyle)
            ]),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          child: AutoSizeText.rich(
            TextSpan(children: [
              TextSpan(
                text: bookReadability.first,
                style: headerStyle,
              ),
              const TextSpan(text: ': '),
              TextSpan(text: bookReadability[1], style: textStyle),
              TextSpan(text: ' ' + bookReadability.last, style: textStyle),
            ]),
          ),
        ),
      ],
    ),
  );
}

Widget _chapterTile(Chapter chapter) {
  return GFListTile(
    onTap: () async => await _navigateToChapterPage(chapter),
    title: AutoSizeText(
      chapter.title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    subtitleText: 'Chapter Id: ' + chapter.id,
    description: AutoSizeText(
      chapter.textHint,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black45),
    ),
  );
}

Future<void> _navigateToChapterPage(Chapter chapter) async {
  return await Get.to(ChapterPage(chapter: chapter));
}
