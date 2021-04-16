import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class UsersService {
  final Dio dio;
  UsersService(this.dio);

  Map<String, dynamic> constructHeaders(String token, AuthProviders provider) {
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

  Future<User> getMe(
    String token,
    AuthProviders provider,
  ) async {
    try {
      final response = await dio.get(
        baseUrl + '/auth/me',
        options: Options(headers: constructHeaders(token, provider)),
      );
      return User.fromJson(json.encode(response.data));
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<List<User>> getUsers(
    String token,
    AuthProviders provider,
  ) async {
    try {
      final response = await dio.get(
        baseUrl + '/users',
        options: Options(headers: constructHeaders(token, provider)),
      );
      final users = (response.data as List)
          .map<User>((user) => User.fromJson(user))
          .toList();
      return users;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<User> getUsersById(
    String id,
    String token,
    AuthProviders provider,
  ) async {
    try {
      final response = await dio.get(
        baseUrl + '/users/$id',
        options: Options(headers: constructHeaders(token, provider)),
      );
      return User.fromJson(json.encode(response.data));
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<User> saveUser(
    User user,
    String token,
    AuthProviders provider,
  ) async {
    final body = json.encode(user.toMap());
    try {
      final response = await dio.post(
        baseUrl + '/users',
        data: body,
        options: Options(headers: constructHeaders(token, provider)),
      );

      return User.fromJson(json.encode(response.data));
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }
}
