import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/auth_data.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IApiAuth {
  final Dio dio;
  const IApiAuth(this.dio);

  Map<String, dynamic> setupHeaders(String token) {
    final headers = {
      'Authorization': 'Bearer ' + token,
      'provider': 'api',
    };
    return headers;
  }

  Future<void> saveAuthData(String token) async {
    final shared = await SharedPreferences.getInstance();
    final authData = AuthData(
      isLoggedIn: true,
      provider: AuthProviders.API.index,
      token: token,
    );
    await shared.setString('AuthData', authData.toJson());
  }

  Future<User> getMe(String token) async {
    try {
      final result = await dio.get(
        baseUrl + '/auth/me',
        options: Options(headers: setupHeaders(token)),
      );
      final user = User.fromMap(result?.data);
      return user;
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    } catch (anotherError) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '$anotherError');
      return null;
    }
  }

  Future<User> login(LoginData loginData) async {
    final prebody = {
      'id': 'dummyId',
      'email': loginData.name,
      'password': loginData.password,
    };
    final body = json.encode(prebody);
    try {
      final response = await dio.post(
        baseUrl + '/auth/login',
        data: body,
      );
      await saveAuthData(response.data['token']);
      return User.fromJson(json.encode(response.data['user']));
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<User> register(User user) async {
    final data = json.encode(user.toMap());
    try {
      final response = await dio.post(
        baseUrl + '/auth/register',
        data: data,
      );
      await saveAuthData(response.data['token']);
      return User.fromJson(json.encode(response.data['mongoUser']));
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }
}
