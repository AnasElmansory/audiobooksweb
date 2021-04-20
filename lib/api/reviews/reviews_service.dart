import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class ReviewsService {
  final Dio _dio;

  const ReviewsService(this._dio);

  Future<Map<String, dynamic>> _constructHeaders(String token) async {
    final provider = await getAuthProvider();
    final providerString = StringBuffer();
    if (provider == AuthProviders.GOOGLE)
      providerString.write('google');
    else if (provider == AuthProviders.FACEBOOK)
      providerString.write('facebook');
    else if (provider == AuthProviders.API) providerString.write('api');
    return <String, dynamic>{
      'Authorization': 'Bearer ' + token,
      'provider': providerString.toString(),
    };
  }

  Future<List<Review>> getReviews(String token, {int page}) async {
    try {
      final response = await _dio.get(
        baseUrl + '/reviews',
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final reviews = (response.data as List)
          .map<Review>((review) => Review.fromMap(review))
          .toList();
      return reviews;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }

  Future<Review> getReviewById(String token, int id) async {
    try {
      final response = await _dio.get(
        baseUrl + '/reviews/$id',
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final review = Review.fromMap(response.data);
      return review;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }

  Future<Review> addReview(String token, Review review) async {
    final data = review.toJson();
    try {
      final response = await _dio.post(
        baseUrl + '/reviews',
        data: data,
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final reviewResponse = Review.fromMap(response.data);
      return reviewResponse;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }

  Future<Review> updateReview(String token, Review review) async {
    final data = review.toJson();
    try {
      final response = await _dio.put(
        baseUrl + '/reviews/${review.id}',
        data: data,
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final reviewResponse = Review.fromMap(response.data);
      return reviewResponse;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }

  Future<Review> deleteReview(String token, int id) async {
    try {
      final response = await _dio.delete(
        baseUrl + '/reviews/$id',
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final reviewResponse = Review.fromMap(response.data);
      return reviewResponse;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }
}
