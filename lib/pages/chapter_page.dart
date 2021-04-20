import 'package:audiobooks/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

class ChapterPage extends StatelessWidget {
  final Chapter chapter;

  const ChapterPage({Key key, this.chapter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(FontAwesomeIcons.filePdf),
        onPressed: () {
          //TODO: download chapter pdf
        },
      ),
      appBar: AppBar(
        title: Text(chapter.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GFListTile(
              titleText: chapter.title,
              description: Text(chapter.textHint),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: HtmlWidget(
                chapter.contentAsHtml,
                textStyle: const TextStyle(),
                customStylesBuilder: (element) {
                  print(element.classes);
                  return null;
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
