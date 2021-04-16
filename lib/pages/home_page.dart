import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/user.dart';
import 'package:audiobooks/pages/sign_page.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    checkUserAuthState(context);
    final userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Books'),
        backgroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<User>(
                future: userProvider.getUser(),
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  return UserAccountsDrawerHeader(
                    accountName: Text('${user?.username}'),
                    accountEmail: Text('${user?.email}'),
                  );
                },
              ),
              ListTile(
                title: const Text('SignOut'),
                leading: const Icon(Icons.power_settings_new),
                onTap: () async {
                  await context.read<UserProvider>().signOut();
                  await _navigateToSignPage(context);
                },
              ),
              ListTile(
                title: const Text('get book'),
                leading: const Icon(Icons.power_settings_new),
                onTap: () async {
                  final book = context.read<BooksProvider>().getBookById(1);
                  print(book);
                  // await _navigateToSignPage(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<Book>(
          future: context.watch<BooksProvider>().getBookById(1),
          builder: (_, snapshot) {
            return Text(snapshot.data.toString());
            // return ListView.builder(
            //   itemCount: snapshot.data.length,
            //   itemBuilder: (context, index) => ListTile(
            //     title: snapshot.data[index]['book_id_book'],
            //   ),
            // );
          }),
    );
  }
}

void checkUserAuthState(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    final userProvider = context.read<UserProvider>();
    if (!await userProvider.isLoggedIn()) await _navigateToSignPage(context);
  });
}

Future<void> _navigateToSignPage(context) async {
  await Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (_) => const SignPage()));
}
