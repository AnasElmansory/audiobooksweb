import 'dart:convert';

import 'package:audiobooks/models/model.dart';

class Review extends Model {
  @override
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String bookName;
  final String bookId;
  final String comment;
  final double rate;
  Review({
    this.id,
    this.userId,
    this.username,
    this.userAvatar,
    this.bookName,
    this.bookId,
    this.comment,
    this.rate,
  });

  Review copyWith({
    String id,
    String userId,
    String username,
    String userAvatar,
    String bookName,
    String bookId,
    String comment,
    double rate,
  }) {
    return Review(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      bookName: bookName ?? this.bookName,
      bookId: bookId ?? this.bookId,
      comment: comment ?? this.comment,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userAvatar': userAvatar,
      'bookName': bookName,
      'bookId': bookId,
      'comment': comment,
      'rate': rate,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      userId: map['userId'],
      username: map['username'],
      userAvatar: map['userAvatar'],
      bookName: map['bookName'],
      bookId: map['bookId'],
      comment: map['comment'],
      rate: map['rate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(id: $id, userId: $userId, username: $username, userAvatar: $userAvatar, bookName: $bookName, bookId: $bookId, comment: $comment, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Review &&
        other.id == id &&
        other.userId == userId &&
        other.username == username &&
        other.userAvatar == userAvatar &&
        other.bookName == bookName &&
        other.bookId == bookId &&
        other.comment == comment &&
        other.rate == rate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        username.hashCode ^
        userAvatar.hashCode ^
        bookName.hashCode ^
        bookId.hashCode ^
        comment.hashCode ^
        rate.hashCode;
  }
}
