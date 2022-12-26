import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../database/user_database_helper.dart';
import '../../models/user_model.dart';

class UserRepository {
  final userDao = UserDao();
  final fireAuth.FirebaseAuth firebAuth = fireAuth.FirebaseAuth.instance;

  Future<fireAuth.UserCredential?> register(
      {required String username,
      required String email,
      required String password}) async {
    try {
      fireAuth.UserCredential fireuser = await firebAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await fireuser.user?.updateDisplayName(username);
      return fireuser;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUserToFirebase({required User user}) async {
    await _firebase
        .collection("users")
        .doc(user.userId.toString())
        .set(user.toDatabaseJson());
  }

  Future<void> saveUser({required User user}) async {
    print("User added to db == ${user.toString()} ");
    if (kIsWeb) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      await prefs.setInt('userId', user.userId);
      await prefs.setString('avatar', user.avatar ?? '');
      await prefs.setString('email', user.email);
      await prefs.setString('username', user.username);
      await prefs.setString('uid', user.uid);
      await prefs.setString('password', user.password);
    } else {
      try {
        await userDao.createUser(user);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<User?> getUser({int? id}) async {
    User? result;
    // for web only supports sharedpreferences
    if (kIsWeb) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      int? userId = prefs.getInt('userId');
      String avatar = prefs.getString('avatar') ?? '';
      String email = prefs.getString('email') ?? '';
      String username = prefs.getString('username') ?? '';
      String uid = prefs.getString('uid') ?? '';
      String password = prefs.getString('password') ?? '';
      if (userId != null) {
        result = User(
            userId: userId,
            avatar: avatar,
            email: email,
            username: username,
            uid: uid,
            password: password);
      } else {
        result = null;
      }
    } else {
      result = await userDao.getUser(id);
    }
    return result;
  }

  Future<List?> getUserToken({required String userId}) async {
    var data = await _firebase
        .collection("users")
        .where('userId', isEqualTo: int.tryParse(userId))
        .limit(1)
        .get();
    if (data.docs.isEmpty) {
      return null;
    } else {
      return data.docs[0].data()['token'] ?? [];
    }
  }

  Future<void> updateUser(
      {required String userId,
      required Map<String, dynamic> updateData}) async {
    try {
      await _firebase.collection("users").doc(userId).update(updateData);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logoutfromApiandDeleteToken({required int id}) async {
    if (kIsWeb) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      await prefs.clear();
    } else {
      await userDao.logoutApiDeleteToken(id);
    }
  }

  final FirebaseFirestore _firebase = FirebaseFirestore.instance;
  Future<User?> getfromFirestoreAuth(
      {required String username, required String password}) async {
    var bytes = utf8.encode(password);
    var hashedpassword = sha1.convert(bytes);

    var data = await _firebase
        .collection("users")
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: '$hashedpassword')
        .limit(1)
        .get();
    if (data.docs.isEmpty) {
      return null;
    } else {
      return User.fromDatabaseJson(data.docs[0].data());
    }
  }

  Future<int> getCreateUserid() async {
    var data = await _firebase.collection("users").get();
    return data.docs.length + 1;
  }
}
