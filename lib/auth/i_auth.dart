import 'package:audiobooks/models/user.dart';
import 'package:flutter_login/flutter_login.dart';

abstract class IAuth {
  final AuthProviders provider;
  IAuth(this.provider);

  Future<String> getToken();
  Future<User> getCurrentUser();
  Future<User> signIn([LoginData loginData]);
  Future<bool> isLoggedIn();
  Future<void> signOut();
}

enum AuthProviders { GOOGLE, FACEBOOK, API }

enum AuthMode { Register, Login }
