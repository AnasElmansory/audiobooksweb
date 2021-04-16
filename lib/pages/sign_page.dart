import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/pages/home_page.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignPage extends StatelessWidget {
  const SignPage();
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        onLogin: (loginData) async {
          final userProivder = UserProvider(AuthProviders.API);
          final user = await userProivder.signIn(loginData);
          if (user == null) return 'Login Failed!';
          await navigateToHomePage(context, userProivder);
          return 'success!';
        },
        onSignup: (loginData) async {
          final userProivder = UserProvider(AuthProviders.API);
          final user = await userProivder.register(loginData);
          if (user == null) return 'Login Failed!';
          await navigateToHomePage(context, userProivder);
          return 'success!';
        },
        onRecoverPassword: (string) async => string,
        loginProviders: [
          LoginProvider(
              icon: FontAwesomeIcons.google,
              callback: () async {
                final userProvider = UserProvider(AuthProviders.GOOGLE);
                await userProvider.signIn();
                await navigateToHomePage(context, userProvider);
                return 'done!';
              }),
          LoginProvider(
              icon: FontAwesomeIcons.facebook,
              callback: () async {
                final userProvider = UserProvider(AuthProviders.FACEBOOK);
                await userProvider.signIn();
                await navigateToHomePage(context, userProvider);
                return 'done!';
              }),
        ]);
  }
}

Future<void> navigateToHomePage(
  BuildContext context,
  UserProvider userProvider,
) async =>
    await Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
              value: userProvider,
              child: const HomePage(),
            )));
