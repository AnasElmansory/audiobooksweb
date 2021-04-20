import 'dart:convert';

import 'package:audiobooks/models/model.dart';

class User extends Model {
  final String mongoId;
  @override
  final String id;
  final String email;
  final String username;
  final String password;
  final bool isAdmin;

  User({
    this.mongoId,
    this.id,
    this.email,
    this.username,
    this.password,
    this.isAdmin = false,
  });

  User copyWith({
    String mongoId,
    String id,
    String email,
    String username,
    String password,
    bool isAdmin,
  }) {
    return User(
      mongoId: mongoId ?? this.mongoId,
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // '_id': mongoId,
      'id': id,
      'email': email,
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      mongoId: map['_id'],
      id: map['id'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
      isAdmin: map['isAdmin'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(mongoId: $mongoId, id: $id, email: $email, username: $username, password: $password, isAdmin: $isAdmin)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.mongoId == mongoId &&
        other.id == id &&
        other.email == email &&
        other.username == username &&
        other.password == password &&
        other.isAdmin == isAdmin;
  }

  @override
  int get hashCode {
    return mongoId.hashCode ^
        id.hashCode ^
        email.hashCode ^
        username.hashCode ^
        password.hashCode ^
        isAdmin.hashCode;
  }
}
