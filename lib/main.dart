import 'package:audiobooks/app.dart';
import 'package:audiobooks/get_it.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initGet();
  runApp(const App());
}
