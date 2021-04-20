import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/pages/one_book_page.dart';
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
            elevation: 2,
            image: Image(
              image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI4JuatGP6M5_Q0wYSkx2jAVzJff1FBaPYXV7zFbMngh5RV6J7',
              ),
              fit: BoxFit.cover,
            ),
            buttonBar: GFButtonBar(
              children: [
                AutoSizeText(
                  book.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (aspectRatio < 0.8)
                  AutoSizeText(
                    book.textHint,
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
