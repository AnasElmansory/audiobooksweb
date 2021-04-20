import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/auth_data.dart';
import 'package:audiobooks/pages/home_page.dart';
import 'package:audiobooks/pages/sign_page.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitialLoader extends StatelessWidget {
  const InitialLoader();
  @override
  Widget build(BuildContext context) {
    checkAuthState(context);
    return Scaffold(
      body: const Center(
        child: const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

void checkAuthState(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    final shared = await SharedPreferences.getInstance();
    final authJson = shared.getString('AuthData');
    final authData =
        authJson != null ? AuthData.fromJson(authJson) : const AuthData();
    final provider = AuthProviders.values[authData.provider];
    if (authData.isLoggedIn)
      await _navigateToHomePage(provider);
    else
      return await Get.off(const SignPage());
  });
}

Future<void> _navigateToHomePage(AuthProviders authProvider) async {
  Get.context.read<UserProvider>()
    ..authType = authProvider
    ..getUser();
  return await Get.off(const HomePage());
}
