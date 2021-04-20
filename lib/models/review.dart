import 'dart:convert';

import 'package:audiobooks/models/model.dart';

class Review extends Model {
  @override
  final String id;
  final String username;
  final String userId;
  final String bookId;
  final String comment;
  final double rate;
  Review({
    this.id,
    this.username,
    this.userId,
     this.bookId,
    this.comment,
    this.rate,
  });

  Review copyWith({
    String id,
    String username,
    String userId,
    String bookId,
    String comment,
    double rate,
  }) {
    return Review(
      id: id ?? this.id,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      comment: comment ?? this.comment,
      rate: rate ?? this.rate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'userId': userId,
      'bookId': bookId,
      'comment': comment,
      'rate': rate,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      id: map['id'],
      username: map['username'],
      userId: map['userId'],
      bookId: map['bookId'],
      comment: map['comment'],
      rate: map['rate'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) => Review.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Review(id: $id, username: $username, userId: $userId, bookId: $bookId, comment: $comment, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Review &&
      other.id == id &&
      other.username == username &&
      other.userId == userId &&
      other.bookId == bookId &&
      other.comment == comment &&
      other.rate == rate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      username.hashCode ^
      userId.hashCode ^
      bookId.hashCode ^
      comment.hashCode ^
      rate.hashCode;
  }
}
