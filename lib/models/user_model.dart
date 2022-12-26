import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int userId;
  final String? avatar;
  final String email;
  final String username;
  final String uid;
  final String password;

  const User({
    required this.userId,
    required this.avatar,
    required this.email,
    required this.username,
    required this.uid,
    required this.password,
  });

  User copyWith({
    int? userId,
    String? avatar,
    String? email,
    String? username,
    String? uid,
    String? password,
  }) =>
      User(
        userId: userId ?? this.userId,
        avatar: avatar ?? this.avatar,
        email: email ?? this.email,
        username: username ?? this.username,
        uid: uid ?? this.uid,
        password: password ?? this.password,
      );
  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
        userId: data['userId'],
        username: data['username'],
        avatar: data['avatar'],
        email: data['email'],
        uid: data['uid'] ?? [],
        password: data['password'],
      );

  Map<String, dynamic> toDatabaseJson() => {
        "userId": userId,
        "username": username,
        "email": email,
        "avatar": avatar,
        "uid": uid,
        "password": password,
      };

  @override
  String toString() =>
      "userId: $userId, username: $username, email: $email, avatar: $avatar, uid: $uid, password: $password";

  @override
  List<Object?> get props => [userId, avatar, email, username, uid, password];
}
