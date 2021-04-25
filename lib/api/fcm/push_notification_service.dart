import 'package:audiobooks/auth/i_auth.dart';
import 'package:audiobooks/utils/constants.dart';
import 'package:audiobooks/utils/helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast_web.dart';

class PushNotificationService {
  final Dio _dio;

  const PushNotificationService(this._dio);
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

  Future<String> sendNotification(String token, RemoteMessage message) async {
    final data = message.toJson();
    try {
      final response = await _dio.post(
        baseUrl + '/fcm',
        data: data,
        options: Options(
          headers: await _constructHeaders(token),
        ),
      );
      final messageId = response.data as String;
      return messageId;
    } on DioError catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '${error.response.data}');
      return null;
    }
  }
}
