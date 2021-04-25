import 'dart:convert';

import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class UsersService {
  final Dio _dio;
  const UsersService(this._dio);

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

  Future<User> getMe(String token) async {
    try {
      final response = await _dio.get(
        baseUrl + '/auth/me',
        options: Options(
          headers: constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );
      if (response?.data == null) return null;
      return User.fromMap(response.data);
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    } catch (anotherError) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '$anotherError');
      return null;
    }
  }

  Future<List<User>> getUsers(
    String token, {
    int page,
  }) async {
    try {
      final response = await _dio.get(
        baseUrl + '/users',
        queryParameters: {'page': page},
        options: Options(
          headers: constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );
      final users = (response.data as List)
          .map<User>((user) => User.fromMap(user))
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
  ) async {
    try {
      final response = await _dio.get(
        baseUrl + '/users/$id',
        options: Options(
          headers: constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );

      return User.fromMap(response.data);
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<User> saveUser(
    User user,
    String token,
  ) async {
    final body = json.encode(user.toMap());
    final provider = await getAuthProvider();
    try {
      final response = await _dio.post(
        baseUrl + '/users',
        data: body,
        options: Options(
          headers: constructHeaders(
            token,
            provider,
          ),
        ),
      );
      return User.fromMap(response.data);
    } on DioError catch (e) {
      print('error: $e');
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    } catch (error) {
      print('anotherError: $error');
      return null;
    }
  }

  Future<User> grantAdmin(
    String id,
    String token,
  ) async {
    final data = json.encode({'isAdmin': true});
    try {
      final response = await _dio.put(
        baseUrl + '/users/$id',
        data: data,
        options: Options(
          headers: constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );
      return User.fromMap(response.data);
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }

  Future<User> deleteUser(
    String id,
    String token,
  ) async {
    try {
      final response = await _dio.delete(
        baseUrl + '/users/$id',
        options: Options(
          headers: constructHeaders(
            token,
            await getAuthProvider(),
          ),
        ),
      );
      return User.fromMap(response.data);
    } on DioError catch (e) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${e.response.data}');
      return null;
    }
  }
}
