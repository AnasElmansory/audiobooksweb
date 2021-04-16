import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class BooksService {
  final Dio dio;

  BooksService(this.dio);

  Map<String, dynamic> _constructHeaders(String token, AuthProviders provider) {
    final providerString = StringBuffer();
    if (provider == AuthProviders.GOOGLE)
      providerString.write('google');
    else if (provider == AuthProviders.FACEBOOK)
      providerString.write('facebook');
    else if (provider == AuthProviders.API) providerString.write('api');
    return <String, dynamic>{
      'Authorization': 'Bearer ' + token,
      'provider': providerString.toString(),
    };
  }

  Future<List<Book>> getBooks({
    @required String token,
    @required AuthProviders provider,
    int page,
    int pageSize,
  }) async {
    final queryParameters = {
      'page': page,
      'pageSize': pageSize,
    };
    try {
      final response = await dio.get(
        baseUrl + '/books',
        queryParameters: queryParameters,
        options: Options(headers: _constructHeaders(token, provider)),
      );
      final books = (response.data as List)
          .map<Book>((book) => Book.fromJson(jsonEncode(book)))
          .toList();
      return books;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<Book> getBookById(
    int id, {
    @required String token,
    @required AuthProviders provider,
  }) async {
    final headers = _constructHeaders(token, provider);
    print(headers);
    try {
      final response = await dio.get(
        baseUrl + '/books/$id',
        options: Options(headers: headers),
      );
      print(response.data);
      final book = response.constructBook();
      print("book: $book");
      return book;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }
}
