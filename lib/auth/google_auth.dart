import 'dart:convert';

import 'package:audiobooks/api/users/users_service.dart';
import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/auth_data.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuth extends IAuth {
  final GoogleSignIn _googleSignIn;
  final UsersService _usersService;
  GoogleAuth(this._googleSignIn, this._usersService)
      : super(AuthProviders.GOOGLE);

  @override
  Future<User> signIn([LoginData loginData]) async {
    GoogleSignInAccount account;
    try {
      account = await _googleSignIn.signIn();
    } on PlatformException catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(
        msg: 'error: ${error.code}',
      );
      return null;
    }
    final authentication = await account.authentication;
    final shared = await SharedPreferences.getInstance();
    final authData = AuthData(
      idToken: authentication.idToken,
      token: authentication.accessToken,
      isLoggedIn: await isLoggedIn(),
      provider: AuthProviders.GOOGLE.index,
    );
    await shared.setString('AuthData', authData.toJson());
    final userData = User(
      id: account.id,
      username: account.displayName,
      avatar: account.photoUrl,
      email: account.email,
      password: kGooglePassword,
    );
    final user = await _usersService.saveUser(
      userData,
      authData.idToken,
    );
    return user;
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    final shared = await SharedPreferences.getInstance();
    shared.clear();
  }

  @override
  Future<bool> isLoggedIn() async => await _googleSignIn.isSignedIn();

  @override
  Future<User> getCurrentUser() async {
    if (!await isLoggedIn()) {
      FluttertoastWebPlugin().addHtmlToast(msg: 'you are not logged in ');
      return null;
    }
    final token = await getToken();
    final user = await _usersService.getMe(token);
    return user;
  }

  @override
  Future<String> getToken() async {
    final account = await _googleSignIn.signInSilently();
    final auth = await account.authentication;
    return auth.idToken;
  }
}
