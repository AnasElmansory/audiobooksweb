import 'package:audiobooks/auth/api_auth.dart';
import 'package:audiobooks/auth/facebook_auth.dart';
import 'package:audiobooks/auth/google_auth.dart';
import 'package:audiobooks/get_it.dart';
import 'package:audiobooks/models/user.dart';
import 'package:flutter/material.dart';
import 'package:audiobooks/auth/i_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  final IAuth _auth;

  UserProvider._(this._auth);

  factory UserProvider(AuthProviders provider) {
    if (provider == AuthProviders.GOOGLE)
      return UserProvider._(getIt<GoogleAuth>());
    else if (provider == AuthProviders.FACEBOOK)
      return UserProvider._(getIt<FacebookAuthentication>());
    else
      return UserProvider._(getIt<ApiAuth>());
  }

  Future<String> getToken() async => await _auth.getToken();

  Future<bool> isLoggedIn() async => await _auth.isLoggedIn();

  Future<User> getUser() async {
    final user = await _auth.getCurrentUser();
    return user;
  }

  Future<User> signIn([LoginData loginData]) async =>
      await _auth.signIn(loginData);

  Future<User> register(LoginData loginData) async {
    final apiAuth = _auth as ApiAuth;
    final user = await apiAuth.register(loginData);
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final shared = await SharedPreferences.getInstance();
    await shared.clear();
  }
}
