import 'package:flutter/cupertino.dart';

class PageViewProvider extends ChangeNotifier {
  final controller = PageController();

  int _page = 0;
  int get page => this._page;
  set page(int value) {
    this._page = value;
    notifyListeners();
  }

  Future<void> toPage(int pageIndex) async {
    await controller.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    page = pageIndex;
  }
}
