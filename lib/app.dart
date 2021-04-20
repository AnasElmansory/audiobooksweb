import 'package:audiobooks/get_it.dart';
import 'package:audiobooks/pages/initial_loader.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/page_view_provider.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<PageViewProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<BooksProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ReviewsProvider>()),
      ],
      child: GetMaterialApp(
        home: const InitialLoader(),
      ),
    );
  }
}
