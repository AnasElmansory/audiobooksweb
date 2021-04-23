import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/pages/one_book_page.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class BookWidget extends StatefulWidget {
  final Book book;

  const BookWidget({Key key, this.book}) : super(key: key);
  @override
  _BookWidgetState createState() => _BookWidgetState();
}

class _BookWidgetState extends State<BookWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Book get book => widget.book;
  String elementId;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bookHeight = size.height * 0.25;
    final bookWidth = size.width * 0.25;
    final aspectRatio = (bookHeight / bookWidth);

    return InkWell(
      onTap: () async => await Get.to(OneBookPage(bookId: book.id)),
      hoverColor: Colors.blueGrey.shade100,
      onHover: (isHoverd) async {
        if (isHoverd)
          await _controller.animateBack(0.75);
        else
          await _controller.animateTo(1);
      },
      child: ScaleTransition(
        scale: _controller,
        child: Container(
          constraints: BoxConstraints.expand(
            height: size.height * 0.25,
            width: bookWidth,
          ),
          child: GFCard(
            elevation: 5,
            image: Image(
              image: NetworkImage(corsBridge + book.bookImage),
              errorBuilder: (context, _, __) => const Image(
                  image: const AssetImage("asset/images/book_placeholder.jpg")),
              fit: BoxFit.cover,
            ),
            buttonBar: GFButtonBar(
              children: [
                AutoSizeText(
                  book.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (aspectRatio < 0.8)
                  AutoSizeText(
                    book.textHint,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
