import 'package:audiobooks/models/auth_data.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:audiobooks/api/auth/i_api_auth.dart';
import 'package:audiobooks/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'i_auth.dart';

class ApiAuth extends IAuth {
  final IApiAuth _apiAuth;
  ApiAuth(
    this._apiAuth,
  ) : super(AuthProviders.API);

  @override
  Future<User> signIn([LoginData loginData]) async {
    final user = await _apiAuth.login(loginData);
    return user;
  }

  Future<User> register(LoginData loginData) async {
    final userData = User(
      id: Uuid().v1(),
      username: loginData.name,
      email: loginData.name,
      password: loginData.password,
    );
    final user = await _apiAuth.register(userData);
    return user;
  }

  @override
  Future<void> signOut() async {
    final shared = await SharedPreferences.getInstance();
    shared.clear();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final user = await _apiAuth.getMe(token);
    if (user == null)
      return false;
    else
      return true;
  }

  @override
  Future<User> getCurrentUser() async {
    final token = await getToken();
    final user = await _apiAuth.getMe(token);
    return user;
  }

  @override
  Future<String> getToken() async {
    final shared = await SharedPreferences.getInstance();
    final token = AuthData.fromJson(shared.getString('AuthData')).token;
    return token;
  }
}
