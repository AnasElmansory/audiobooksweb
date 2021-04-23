import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/chapter.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/pages/chapter_page.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/widgets/review_form_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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
                subtitleText: 'Author: ' + book.bookAuthor,
                description: AutoSizeText(book.textHint),
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
  final bookLanguage = book.language.split(':');
  final bookPublishYear = book.publishYear.split(':');
  final bookReadability = book.readability.split(':');
  final bookCountryOfOrigin = book.countryOfOrigin.split(':');
  final bookWordsCount = book.wordCount.split(':');
  final textStyle = const TextStyle(fontSize: 16);
  final headerStyle = const TextStyle(
    color: const Color(0xFF263238),
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );
  return Card(
    color: Colors.grey.shade200,
    child: Container(
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
    ),
  );
}

Widget _chapterTile(Chapter chapter) {
  return GFListTile(
    onTap: () async => await _navigateToChapterPage(chapter),
    titleText: chapter.title,
    subtitleText: 'Chapter Id: ' + chapter.id,
    description: AutoSizeText(chapter.textHint),
    icon: const Icon(FontAwesomeIcons.playCircle),
  );
}

Future<void> _navigateToChapterPage(Chapter chapter) async {
  return await Get.to(ChapterPage(chapter: chapter));
}
