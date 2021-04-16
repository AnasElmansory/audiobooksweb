import 'package:audiobooks/get_it.dart';
import 'package:audiobooks/pages/initial_loader.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<BooksProvider>())
      ],
      child: MaterialApp(
        home: const InitialLoader(),
      ),
    );
  }
}
