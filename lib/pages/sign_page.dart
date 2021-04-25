import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/pages/home_page.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SignPage extends StatelessWidget {
  const SignPage();
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        theme: LoginTheme(
          pageColorLight: Colors.blueGrey,
        ),
        onLogin: (loginData) async => await _handleSign(
              AuthProviders.API,
              loginData: loginData,
              authMode: AuthMode.Login,
            ),
        onSignup: (loginData) async => await _handleSign(
              AuthProviders.API,
              loginData: loginData,
              authMode: AuthMode.Register,
            ),
        onRecoverPassword: (string) async => string,
        loginProviders: [
          LoginProvider(
            icon: FontAwesomeIcons.google,
            callback: () async => await _handleSign(AuthProviders.GOOGLE),
          ),
          LoginProvider(
            icon: FontAwesomeIcons.facebook,
            callback: () async => await _handleSign(AuthProviders.FACEBOOK),
          ),
        ]);
  }
}

Future<String> _handleSign(
  AuthProviders authProvider, {
  LoginData loginData,
  AuthMode authMode,
}) async {
  User user;
  final userProvider = Get.context.read<UserProvider>()
    ..authType = authProvider;
  if (authProvider == AuthProviders.API) {
    if (authMode == AuthMode.Register)
      user = await userProvider.register(loginData);
    else if (authMode == AuthMode.Login)
      user = await userProvider.signIn(loginData);
    if (user == null) return 'Authentication Failed!';
    await _navigateToHomePage();
    return 'success!';
  }
  user = await userProvider.signIn(loginData);
  if (user == null) return 'Authentication Failed!';
  await _navigateToHomePage();
  return 'success!';
}

Future<void> _navigateToHomePage() async => await Get.off(const HomePage());
