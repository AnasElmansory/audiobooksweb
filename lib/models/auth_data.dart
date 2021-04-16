import 'dart:convert';

class AuthData {
  final String token;
  final String idToken;
  final int provider;
  final bool isLoggedIn;
  const AuthData({
    this.token,
    this.idToken,
    this.provider = 0,
    this.isLoggedIn = false,
  });

  AuthData copyWith({
    String token,
    String idToken,
    int provider,
    bool isLoggedIn,
  }) {
    return AuthData(
      token: token ?? this.token,
      idToken: idToken ?? this.idToken,
      provider: provider ?? this.provider,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'idToken': idToken,
      'provider': provider,
      'isLoggedIn': isLoggedIn,
    };
  }

  factory AuthData.fromMap(Map<String, dynamic> map) {
    return AuthData(
      token: map['token'],
      idToken: map['idToken'],
      provider: map['provider'],
      isLoggedIn: map['isLoggedIn'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthData.fromJson(String source) =>
      AuthData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AuthData(token: $token, idToken: $idToken, provider: $provider, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthData &&
        other.token == token &&
        other.idToken == idToken &&
        other.provider == provider &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        idToken.hashCode ^
        provider.hashCode ^
        isLoggedIn.hashCode;
  }
}
