import 'package:audiobooks/api/fcm/push_notification_service.dart';
import 'package:audiobooks/models/review.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class PushNotificationProvider extends ChangeNotifier {
  final PushNotificationService _notificaitonService;

  PushNotificationProvider(this._notificaitonService);

  Future<void> sendReviewNotification(Review review) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final message = RemoteMessage(
        notification: RemoteNotification(
          android: AndroidNotification(imageUrl: review.userAvatar),
          title: review.username,
          body: review.comment +
              ' with rate: ' +
              review.rate.toString() +
              ' in book: ' +
              review.bookName,
        ),
        from: review.bookName,
        data: {
          'reviewId': review.id,
          'userId': review.userId,
        });
    final messageId =
        await _notificaitonService.sendNotification(token, message);
    return await FluttertoastWebPlugin().addHtmlToast(
      msg: 'message sent, id:' + messageId,
    );
  }

  Future<void> sendNotification({
    String title,
    String body,
    String topic,
  }) async {
    final userProvider = Get.context.read<UserProvider>();
    final token = await userProvider.getToken();
    final message = RemoteMessage(
      notification: RemoteNotification(
        // android: AndroidNotification(imageUrl: review.userAvatar),
        title: title,
        body: body,
      ),
      from: topic,
    );
    final messageId =
        await _notificaitonService.sendNotification(token, message);
    return await FluttertoastWebPlugin().addHtmlToast(
      msg: 'message sent, id:' + messageId,
    );
  }
}
