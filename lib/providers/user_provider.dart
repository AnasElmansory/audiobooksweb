import 'package:audiobooks/api/users/users_service.dart';
import 'package:audiobooks/auth/api_auth.dart';
import 'package:audiobooks/auth/facebook_auth.dart';
import 'package:audiobooks/auth/google_auth.dart';
import 'package:audiobooks/get_it.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  IAuth _auth;
  final UsersService _usersService;
  UserProvider.empty(this._usersService);
  set authType(AuthProviders provider) {
    if (provider == AuthProviders.GOOGLE)
      this._auth = getIt<GoogleAuth>();
    else if (provider == AuthProviders.FACEBOOK)
      this._auth = getIt<FacebookAuthentication>();
    else
      this._auth = getIt<ApiAuth>();
    notifyListeners();
  }

  final _pagingController = PagingController<int, User>(firstPageKey: 1);
  PagingController<int, User> get controller => this._pagingController;

  User _user;
  User get user => this._user;
  set user(User value) {
    this._user = value;
    notifyListeners();
  }

  Set<User> _users = Set<User>();
  Set<User> get users => this._users;
  set users(Set<User> value) {
    this._users.addAll(value);
    notifyListeners();
  }

  Future<String> getToken() async => await _auth.getToken();

  Future<bool> isLoggedIn() async => await _auth.isLoggedIn();

  Future<User> getUser() async {
    user = await _auth.getCurrentUser();
    return user;
  }

  Future<User> signIn([LoginData loginData]) async {
    user = await _auth.signIn(loginData);
    return user;
  }

  Future<User> register(LoginData loginData) async {
    final apiAuth = _auth as ApiAuth;
    user = await apiAuth.register(loginData);
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    final shared = await SharedPreferences.getInstance();
    await shared.clear();
    user = null;
  }

  Future<List<User>> getUsers({int page}) async {
    final token = await getToken();
    final result = await _usersService.getUsers(token, page: page);
    users = result.toSet();
    return users.toList();
  }

  Future<User> deleteUser(String userId) async {
    final token = await getToken();
    final result = await _usersService.deleteUser(userId, token);
    if (result != null) {
      this._users.removeWhere((u) => u.id == result.id);
      notifyListeners();
      await _showToast('user has been deleted!');
    }
    return result;
  }

  Future<User> grantAdmin(String userId) async {
    final token = await getToken();
    final result = await _usersService.grantAdmin(userId, token);
    if (result != null) {
      this.users.update(result);
      notifyListeners();
      await _showToast('admin permission granted');
    }
    return result;
  }

  Future<void> _showToast(String message) async =>
      await FluttertoastWebPlugin().addHtmlToast(msg: message);
  @override
  void dispose() {
    this._pagingController.dispose();
    super.dispose();
  }
}
