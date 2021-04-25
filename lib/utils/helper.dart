import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/auth_data.dart';
import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/chapter.dart';
import 'package:audiobooks/models/model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension BookX on Response {
  Book _extractBook() {
    final book = Book.fromMap(
        (this.data as List).singleWhere((bk) => bk['loai'] == 'book'));
    return book;
  }

  List<Chapter> _extractChapters() {
    final chaptersObjects =
        (this.data as List).where((chapter) => (chapter['loai'] == 'chapter'));
    final chapters = chaptersObjects
        .map<Chapter>((chapter) => Chapter.fromMap(chapter))
        .toList();
    return chapters;
  }

  Book constructBook() {
    final book = _extractBook();
    final chapters = _extractChapters();

    return book.copyWith(chapters: chapters);
  }
}

Future<AuthProviders> getAuthProvider() async {
  final shared = await SharedPreferences.getInstance();
  final provider = AuthProviders
      .values[AuthData.fromJson(shared.getString('AuthData')).provider];
  return provider;
}

extension SetX on Set {
  void update(Model value) {
    this.removeWhere((element) => element.id == value.id);
    this.add(value);
  }
}

extension RemoteMessageX on RemoteMessage {
  Map<String, dynamic> toMap() => {
        'message': {
          'notification': {
            'title': this.notification.title,
            'body': this.notification.body,
          },
          'data': this.data,
          'topic': this.from,
        }
      };

  String toJson() => json.encode(toMap());

  RemoteMessage fromJson(String source) => fromMap(json.decode(source));

  RemoteMessage fromMap(Map<String, dynamic> map) {
    final message = map['message'];
    final notification = message['notification'];
    return RemoteMessage(
      from: message['topic'],
      data: message['data'],
      notification: RemoteNotification(
        title: notification['title'],
        body: notification['body'],
      ),
    );
  }
}
