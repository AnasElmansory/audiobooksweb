import 'package:audiobooks/models/chapter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';

class ChapterPage extends StatelessWidget {
  final Chapter chapter;

  const ChapterPage({Key key, this.chapter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Container(
        width: 70,
        child: ButtonBar(
          // buttonPadding: const EdgeInsets.symmetric(vertical: 16),
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'pdf',
              child: const Icon(FontAwesomeIcons.filePdf),
              onPressed: () {
                //TODO: download chapter pdf
              },
            ),
            FloatingActionButton(
              heroTag: 'playback',
              child: const Icon(Icons.play_arrow),
              onPressed: () {
                //TODO: download chapter pdf
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(chapter.title),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.15,
            vertical: 16,
          ),
          child: Column(
            children: [
              GFListTile(
                title: Text(
                  chapter.title,
                  style: const TextStyle(
                    color: const Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitleText: chapter.textHint,
              ),
              const SizedBox(height: 10),
              Container(
                child: HtmlWidget(
                  chapter.contentAsHtml ?? nullChapterHtml,
                  customStylesBuilder: (element) {
                    if (element.className == 'smallcaps')
                      return {'color': 'hsl(263238)', 'font-weight': 'bold'};
                    else
                      return null;
                  },
                  textStyle: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
