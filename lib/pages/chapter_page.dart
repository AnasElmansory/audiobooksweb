import 'package:audiobooks/models/chapter.dart';
import 'package:audiobooks/providers/utils_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class ChapterPage extends StatefulWidget {
  final Chapter chapter;

  const ChapterPage({Key key, this.chapter}) : super(key: key);

  @override
  _ChapterPageState createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  Chapter get chapter => widget.chapter;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chapterProvider = context.watch<ChapterProvider>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'pdf',
        child: const Icon(FontAwesomeIcons.filePdf),
        onPressed: () async {
          await chapterProvider.downloadChapter(chapter.pdfLink);
        },
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
                title: AutoSizeText(
                  chapter.title,
                  style: const TextStyle(
                    color: const Color(0xFF263238),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
      // bottomNavigationBar: _playerController(chapter.audioLink),
    );
  }
}

Widget _playerController(String url) {
  final chapterProvider = Get.context.watch<ChapterProvider>();
  final size = Get.context.mediaQuerySize;
  return Container(
    height: size.height * .15,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: GFButtonBar(
            children: [
              IconButton(
                icon: Icon(Icons.stop),
                onPressed:
                    (chapterProvider.isPlaying || chapterProvider.isPlaying)
                        ? () async => await chapterProvider.stop()
                        : null,
              ),
              IconButton(
                icon: chapterProvider.isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow),
                onPressed: () async {
                  if (chapterProvider.isStopped)
                    await chapterProvider.start(url: url);
                  else if (chapterProvider.isPaused)
                    await chapterProvider.resume();
                  else if (chapterProvider.isPlaying)
                    await chapterProvider.pause();
                  else
                    print('nothing');
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Slider(
            value: chapterProvider.position?.inMilliseconds?.toDouble() ?? 0,
            max: chapterProvider.duration?.inMilliseconds?.toDouble() ?? 1,
            onChanged: (value) {
              //todo seek :)
            },
          ),
        ),
      ],
    ),
  );
}
