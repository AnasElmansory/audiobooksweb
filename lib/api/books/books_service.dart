import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class BooksService {
  final Dio _dio;

  const BooksService(this._dio);

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

  Future<List<Book>> getBooks(
    String token, {
    int page,
    int pageSize,
  }) async {
    final queryParameters = {
      'page': page,
      'pageSize': pageSize,
    };
    try {
      final response = await _dio.get(
        baseUrl + '/books',
        queryParameters: queryParameters,
        options: Options(
          headers: _constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );

      final books = (response.data as List)
          .map<Book>((book) => Book.fromMap(book))
          .toList();
      return books;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    } catch (er) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${er.toString()}');
      return null;
    }
  }

  Future<Book> getBookById(
    int id, {
    @required String token,
  }) async {
    final headers = _constructHeaders(token, await getAuthProvider());
    try {
      final response = await _dio.get(
        baseUrl + '/books/$id',
        options: Options(headers: headers),
      );
      final book = response.constructBook();
      return book;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }
}
