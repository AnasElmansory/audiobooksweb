import 'package:audiobooks/models/book.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';

class ReviewForm extends StatefulWidget {
  final Book book;
  final bool isEdit;
  final Review review;
  const ReviewForm({
    Key key,
    this.book,
    this.isEdit = false,
    this.review,
  }) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  TextEditingController _commentController;
  Book get book => widget.book;
  Review get review => widget.review;

  double _rate;
  @override
  void initState() {
    _rate = widget.isEdit ? review.rate : 0;
    _commentController = TextEditingController(text: review?.comment ?? '');
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Get.context.read<UserProvider>().user;
    final size = Get.context.mediaQuerySize;
    final paddingWidth = size.width * 0.25;
    final paddingHeight = size.height * 0.1;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: paddingWidth,
        vertical: paddingHeight,
      ),
      child: Center(
        child: Container(
          width: size.width * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircularProfileAvatar(
                user.avatar ?? '',
                initialsText: Text('${user?.username?.capitalizeFirst[0]}'),
              ),
              AutoSizeText('Username: ' + '${user?.username}'),
              GFRating(
                allowHalfRating: false,
                color: Colors.blue,
                controller: _commentController,
                value: _rate,
                showTextForm: true,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                inputDecorations: const InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'comment',
                ),
                onChanged: (rate) => setState(() => _rate = rate),
              ),
              GFButton(
                  text: 'Comment',
                  color: Colors.blue,
                  onPressed: () async {
                    if (!widget.isEdit) {
                      await _submitCommentCreate(
                        _commentController,
                        _rate,
                        book,
                      );
                      Get.back();
                    }
                    if (widget.isEdit) {
                      await _submitCommentEdit(
                        _commentController,
                        _rate,
                        review,
                      );
                      Get.back();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _submitCommentCreate(
  TextEditingController commentController,
  double rate,
  Book book,
) async {
  final reviewsProvider = Get.context.read<ReviewsProvider>();
  final user = Get.context.read<UserProvider>().user;
  final comment = await _validateComment(commentController.text ?? '');

  final review = Review(
    id: Uuid().v1(),
    userId: user.id,
    username: user.username,
    userAvatar: user.avatar,
    bookId: book.id,
    bookName: book.title,
    comment: comment,
    rate: rate,
  );

  await reviewsProvider.addReview(review);
}

Future<void> _submitCommentEdit(
  TextEditingController commentController,
  double rate,
  Review preEditReview,
) async {
  final reviewsProvider = Get.context.read<ReviewsProvider>();
  final comment = await _validateComment(commentController.text ?? '');
  final review = preEditReview.copyWith(rate: rate, comment: comment);
  await reviewsProvider.updateReview(review);
}

Future<String> _validateComment(String value) async {
  const empty = 'Type Something To add Comment!';
  const tooLong = 'Your Comment Is Too Long!';
  if (value.isBlank || value.length > 150)
    return await FluttertoastWebPlugin()
        .addHtmlToast(msg: value.isBlank ? empty : tooLong);
  else
    return value;
}
