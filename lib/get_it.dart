import 'package:audiobooks/api/books/books_service.dart';
import 'package:audiobooks/api/fcm/push_notification_service.dart';
import 'package:audiobooks/api/reviews/reviews_service.dart';
import 'package:audiobooks/api/users/users_service.dart';
import 'package:audiobooks/auth/facebook_auth.dart';
import 'package:audiobooks/auth/google_auth.dart';
import 'package:audiobooks/providers/books_provider.dart';
import 'package:audiobooks/providers/page_view_provider.dart';
import 'package:audiobooks/providers/push_notification_provider.dart';
import 'package:audiobooks/providers/reviews_provider.dart';
import 'package:audiobooks/providers/user_provider.dart';
import 'package:audiobooks/providers/utils_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:audiobooks/auth/api_auth.dart';
import 'package:audiobooks/api/auth/i_api_auth.dart';

final getIt = GetIt.instance;

void initGet() {
  getIt.registerFactory<PageViewProvider>(() => PageViewProvider());
  getIt.registerFactory<ChapterProvider>(() => ChapterProvider(getIt<Dio>()));
  getIt.registerFactory<BooksProvider>(
      () => BooksProvider(getIt<BooksService>()));
  getIt.registerFactory<PushNotificationProvider>(
      () => PushNotificationProvider(getIt<PushNotificationService>()));
  getIt.registerFactory<ReviewsProvider>(
      () => ReviewsProvider(getIt<ReviewsService>()));
  getIt.registerFactory<UserProvider>(
      () => UserProvider.empty(getIt<UsersService>()));

  getIt.registerLazySingleton<UsersService>(() => UsersService(getIt<Dio>()));
  getIt.registerLazySingleton<BooksService>(() => BooksService(getIt<Dio>()));
  getIt.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService(getIt<Dio>()));
  getIt.registerLazySingleton<ReviewsService>(
      () => ReviewsService(getIt<Dio>()));
  getIt.registerLazySingleton<Dio>(() => Dio());

  getIt.registerLazySingleton<GoogleAuth>(() => GoogleAuth(
        getIt<GoogleSignIn>(),
        getIt<UsersService>(),
      ));
  getIt.registerLazySingleton<ApiAuth>(() => ApiAuth(getIt<IApiAuth>()));
  getIt.registerLazySingleton<FacebookAuthentication>(() =>
      FacebookAuthentication(getIt<FacebookAuth>(), getIt<UsersService>()));

  getIt.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn.standard(scopes: ['email', 'profile']));
  getIt.registerLazySingleton<FacebookAuth>(() => FacebookAuth.instance);
  getIt.registerLazySingleton<IApiAuth>(() => IApiAuth(getIt<Dio>()));
}
