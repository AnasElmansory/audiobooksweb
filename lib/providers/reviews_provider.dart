import 'package:audiobooks/api/reviews/reviews_service.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ReviewsProvider extends ChangeNotifier {
  final ReviewsService _reviewsService;

  ReviewsProvider(this._reviewsService);

  Set<Review> _reviews = Set<Review>();
  Set<Review> get reviews => this._reviews;
  set reviews(Set<Review> value) {
    this._reviews.addAll(value);
    notifyListeners();
  }

  final _pagingController = PagingController<int, Review>(firstPageKey: 1);
  PagingController<int, Review> get controller => this._pagingController;

  Future<List<Review>> getReviews({int page, int pageSize}) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _reviewsService.getReviews(
      token,
      page: page,
    );
    reviews = result.toSet();
    return result;
  }

  Future<Review> getReviewById(String id) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final review = await _reviewsService.getReviewById(token, id);
    return review;
  }

  Future<Review> addReview(Review review) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _reviewsService.addReview(token, review);
    _notifyCreate(result);
    return result;
  }

  Future<Review> updateReview(Review review) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _reviewsService.updateReview(token, review);
    _notifyUpdate(review);
    return result;
  }

  Future<Review> deleteReview(String id) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final review = await _reviewsService.deleteReview(token, id);
    _notifyDelete(review);
    return review;
  }

  void _notifyCreate(Review review) async {
    if (review != null) {
      this._reviews.add(review);
      _pagingController.itemList = this._reviews.toList();
      notifyListeners();
      await _showToast('review Created successfuly!');
    }
  }

  void _notifyDelete(Review review) async {
    if (review != null) {
      this._reviews.removeWhere((rv) => rv.id == review.id);
      _pagingController.itemList = this._reviews.toList();
      notifyListeners();
      await _showToast('review Deleted successfuly!');
    }
  }

  void _notifyUpdate(Review review) async {
    if (review != null) {
      this._reviews.update(review);
      _pagingController.itemList = this._reviews.toList();
      notifyListeners();
      await _showToast('review Updated successfuly!');
    }
  }

  Future<void> _showToast(String message) async =>
      await FluttertoastWebPlugin().addHtmlToast(msg: message);

  @override
  void dispose() {
    this._pagingController.dispose();
    super.dispose();
  }
}
