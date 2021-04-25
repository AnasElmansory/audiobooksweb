import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/push_notification_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage();
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _topic;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksProvider>().books;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(25),
        child: Container(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: size.width * .25,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: TextField(
                          controller: _titleController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'title',
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * .25,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        child: TextField(
                          controller: _bodyController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'body',
                          ),
                        ),
                      ),
                      Container(
                        child: GFDropdown(
                          hint: const Text('topic'),
                          value: _topic ??= books.first.title,
                          items: books
                              .map<DropdownMenuItem<String>>(
                                (book) => DropdownMenuItem(
                                  child: AutoSizeText(book.title),
                                  value: book.title,
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _topic = value);
                          },
                        ),
                      ),
                      Container(
                        child: GFButton(
                          text: 'Send',
                          onPressed: () async {
                            final notificationProvider =
                                context.read<PushNotificationProvider>();
                            print(_titleController.text);
                            print(_topic);
                            print(_bodyController.text);
                            await notificationProvider.sendNotification(
                              title: _titleController.text,
                              body: _bodyController.text,
                              topic: _topic,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GFBorder(
                        type: GFBorderType.rRect,
                        dashedLine: [1],
                        child: GFListTile(
                          titleText: _titleController.text,
                          description: Text(_bodyController.text),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
