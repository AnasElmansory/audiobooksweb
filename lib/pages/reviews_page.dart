import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage();
  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  final _pagingController = PagingController<int, Review>(firstPageKey: 1);

  @override
  void initState() {
    _handleReviewsPagination(_pagingController, context);
    super.initState();
  }

  @override
  void dispose() {
    _pagingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dividerIndent = size.width * 0.2;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: PagedListView.separated(
          pagingController: _pagingController,
          separatorBuilder: (context, index) => Divider(
            indent: dividerIndent,
            endIndent: dividerIndent,
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
  return GFListTile(
    onTap: () {},
    hoverColor: Colors.blueGrey.shade200,
    titleText: review.username,
    subtitleText: 'rate: ' + review.rate.toString() + '  ' + '${review.bookId}',
    description: Text(review.comment),
    icon: const Icon(Icons.delete, color: Colors.red),
    avatar: CircleAvatar(
      radius: 30,
      backgroundImage: NetworkImage(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI4JuatGP6M5_Q0wYSkx2jAVzJff1FBaPYXV7zFbMngh5RV6J7'),
    ),
  );
}

void _handleReviewsPagination(
  PagingController _pagingController,
  BuildContext context,
) async {
  final reviewsProvider = context.read<ReviewsProvider>();
  _pagingController.itemList = reviewsProvider.reviews.toList();
  _pagingController.nextPageKey =
      ((reviewsProvider.reviews.length / 10) + 1).floor();
  if (reviewsProvider.reviews.isEmpty) {
    final users = await reviewsProvider.getReviews();
    _pagingController.appendPage(users, 2);
  }
  try {
    _pagingController.addPageRequestListener((pageKey) async {
      final reviews = await reviewsProvider.getReviews(page: pageKey);
      final isLastPage = reviews.length < 10;
      if (isLastPage) {
        _pagingController.appendLastPage(reviews);
      } else {
        _pagingController.appendPage(reviews, pageKey + 1);
      }
    });
  } catch (error) {
    _pagingController.error = error;
  }
}
