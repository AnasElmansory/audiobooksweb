import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/widgets/review_form_widget.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage();
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  @override
  void initState() {
    _handleReviewsPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final reviewProivder = context.watch<ReviewsProvider>();
    final size = MediaQuery.of(context).size;
    final dividerIndent = size.width * 0.2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: PagedListView.separated(
          pagingController: reviewProivder.controller,
          separatorBuilder: (context, index) => Divider(
            indent: dividerIndent,
            endIndent: dividerIndent,
            height: 0,
          ),
          builderDelegate: PagedChildBuilderDelegate<Review>(
            itemBuilder: (context, review, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
                  child: _reviewWidget(review));
            },
          ),
        ),
      ),
    );
  }
}

Widget _reviewWidget(Review review) {
  final reviewProivder = Get.context.watch<ReviewsProvider>();
  final booksProivder = Get.context.watch<BooksProvider>();
  final book = booksProivder.oneBook(review.bookId);
  final user = Get.context.watch<UserProvider>().user;
  return GFListTile(
    titleText: review.username,
    subtitleText:
        'rate: ' + review.rate.toString() + '\nbook: ' + '${review.bookName}',
    description: Text(review.comment),
    avatar: CircularProfileAvatar(
      review.userAvatar ?? '',
      errorWidget: (context, url, error) => const Image(
        image: const AssetImage('asset/images/user_placeholder.png'),
      ),
      initialsText: Text('${review.username.capitalizeFirst[0]}'),
      backgroundColor: Colors.blueGrey,
    ),
    icon: GFButtonBar(
      children: [
        if (user.id == review.userId)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () async {
              if (user.id == review.userId)
                await Get.dialog(
                  ReviewForm(
                    book: book,
                    isEdit: true,
                    review: review,
                  ),
                );
            },
          ),
        if (user.isAdmin)
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () async => await reviewProivder.deleteReview(review.id),
          ),
      ],
    ),
  );
}

void _handleReviewsPagination() {
  final reviewProvider = Get.context.read<ReviewsProvider>();
  final controller = reviewProvider.controller;
  try {
    controller.addPageRequestListener((pageKey) async {
      final reviews = await reviewProvider.getReviews(page: pageKey);
      final isLastPage = reviews.length < 10;
      if (isLastPage) {
        controller.appendLastPage(reviews);
      } else {
        controller.appendPage(reviews, pageKey + 1);
      }
    });
  } catch (error) {
    controller.error = error;
  }
}
