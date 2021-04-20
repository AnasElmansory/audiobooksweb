import 'package:audiobooks/api/reviews/reviews_service.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  Future<Review> getReviewById(int id) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final review = await _reviewsService.getReviewById(token, id);
    return review;
  }

  Future<Review> addReview(int id, Review review) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _reviewsService.addReview(token, review);
    return result;
  }

  Future<Review> updateReview(int id, Review review) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final result = await _reviewsService.updateReview(token, review);
    return result;
  }

  Future<Review> deleteReview(int id) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final review = await _reviewsService.deleteReview(token, id);
    return review;
  }
}
