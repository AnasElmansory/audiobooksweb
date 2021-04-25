import 'package:audiobooks/app.dart';
import 'package:audiobooks/get_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initGet();
  runApp(const App());
}
