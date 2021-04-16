import 'package:audiobooks/api/users/users_service.dart';
import 'package:audiobooks/models/auth_data.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i_auth.dart';

class FacebookAuthentication extends IAuth {
  final FacebookAuth _facebookAuth;
  final UsersService _usersService;

  FacebookAuthentication(
    this._facebookAuth,
    this._usersService,
  ) : super(AuthProviders.FACEBOOK) {
    this._facebookAuth.webInitialize(
          appId: "237869291357835", //<-- YOUR APP_ID
          cookie: true,
          xfbml: true,
          version: "v10.0",
        );
  }

  @override
  Future<User> signIn([LoginData loginData]) async {
    final result = await _facebookAuth.login();
    if (result == null) {
      await FluttertoastWebPlugin()
          .addHtmlToast(msg: 'login was canceled by user!');
      return null;
    }
    final shared = await SharedPreferences.getInstance();
    final authData = AuthData(
      isLoggedIn: await isLoggedIn(),
      provider: AuthProviders.FACEBOOK.index,
      token: result.accessToken.token,
    );
    await shared.setString('AuthData', authData.toJson());
    final accessToken = await _facebookAuth.accessToken;
    final facebookUser = await _facebookAuth.getUserData();
    final userData = User(
      id: facebookUser['id'],
      email: facebookUser['email'],
      username: facebookUser['name'],
      password: kFacebookPassword,
    );
    final user = await _usersService.saveUser(
      userData,
      accessToken.token,
      provider,
    );
    return user;
  }

  @override
  Future<void> signOut() async {
    await _facebookAuth.logOut();
    final shared = await SharedPreferences.getInstance();
    shared.clear();
  }

  @override
  Future<bool> isLoggedIn() async =>
      (await _facebookAuth.accessToken) == null ? false : true;

  @override
  Future<User> getCurrentUser() async {
    if (!await isLoggedIn()) return null;
    final token = await getToken();
    final user = await _usersService.getMe(token, provider);
    return user;
  }

  @override
  Future<String> getToken() async {
    final accessToken = await _facebookAuth.accessToken;
    return accessToken?.token;
  }
}
