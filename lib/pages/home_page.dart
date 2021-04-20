import 'package:audiobooks/pages/books_page.dart';
import 'package:audiobooks/pages/reviews_page.dart';
import 'package:audiobooks/pages/sign_page.dart';
import 'package:audiobooks/pages/users_page.dart';
import 'package:audiobooks/providers/page_view_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/widgets/responsive_widget..dart';
import 'package:audiobooks/widgets/side_menu_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    _checkUserAuthState();
    final pageProvider = context.watch<PageViewProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Books'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: Row(
        children: [
          ResponsiveWidget.isLargeScreen(context)
              ? const Expanded(flex: 1, child: const SideBarMenu())
              : Container(),
          Expanded(
            flex: 3,
            child: _buildPageView(pageProvider),
          )
        ],
      ),
    );
  }
}

// checks if the user is not logged in and navigate to sign page
void _checkUserAuthState() {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    final userProvider = Get.context.read<UserProvider>();
    if (!await userProvider.isLoggedIn()) await _navigateToSignPage();
  });
}

Future<void> _navigateToSignPage() async => await Get.off(const SignPage());

Widget _buildPageView(PageViewProvider pageViewProvider) {
  final user = Get.context.read<UserProvider>().user;
  return PageView(
    controller: pageViewProvider.controller,
    onPageChanged: (page) => pageViewProvider.page = page,
    children: [
      const BooksPage(),
      const ReviewsPage(),
      const UsersPage(),
      if (user?.isAdmin ?? false) const Text('notification'),
    ],
  );
}
