import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fireAuth;

import '../../models/user_model.dart';
import '../../repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository;
  AuthBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UnAuthenticated()) {
    final fireAuth.FirebaseAuth firebAuth = fireAuth.FirebaseAuth.instance;

    on<Initialized>((event, emit) async {
      emit(Loading());
      final User? user = await _userRepository.getUser();

      if (user != null) {
        emit(Authenticated(user: user));
      } else {
        emit(const UnAuthenticated());
      }
    });

    on<AddedToken>((event, emit) async {
      var token = await _userRepository.getUserToken(
        userId: event.userId.toString(),
      );
      if (token != null) {
        if (!token.contains(event.token)) {
          token.add(event.token);
        }
      } else {
        token = [];
        token.add(event.token);
      }
      await _userRepository.updateUser(
          userId: event.userId.toString(), updateData: {'token': token});
    });

    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        User? user = await _userRepository.getfromFirestoreAuth(
            username: event.username, password: event.password);

        if (user != null) {
          print("user ${user.toString()}");
          await _userRepository.saveUser(
            user: user,
          );
          var thisuser = await userRepository.getUser();
          print("thisuser $thisuser");
          emit(Authenticated(user: thisuser!));
        } else {
          emit(const UnAuthenticated(message: "Wrong Username/Password"));
        }
      } catch (e) {
        emit(AuthError(error: e.toString()));
        emit(const UnAuthenticated());
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        fireAuth.UserCredential? usercredential = await userRepository.register(
            username: event.username,
            email: event.email,
            password: event.password);

        int userId = await userRepository.getCreateUserid();
        var bytes = utf8.encode(event.password);
        var hashedpassword = sha1.convert(bytes);

        if (usercredential?.user != null) {
          User newUser = User(
            userId: userId,
            uid: usercredential!.user!.uid,
            avatar: '',
            email: event.email,
            username: event.username,
            password: '$hashedpassword',
          );
          await _userRepository.saveUserToFirebase(user: newUser);
          await _userRepository.saveUser(
            user: newUser,
          );
          var thisuser = await userRepository.getUser();
          print("thisuser ${thisuser}");
          emit(Authenticated(user: thisuser!));
        } else {
          emit(const UnAuthenticated(message: "Failed to register!"));
        }
      } catch (e) {
        emit(AuthError(error: e.toString()));
        emit(const UnAuthenticated());
      }
    });

    // When User Presses the SignOut Button, we will send the SignOutRequested Event to the AuthBloc to handle it and emit the UnAuthenticated State
    on<SignOutRequested>((event, emit) async {
      final User? user = await _userRepository.getUser();
      print("user == $user");
      if (user != null) {
        await _userRepository.logoutfromApiandDeleteToken(id: user.userId);
      }
      emit(const UnAuthenticated(message: "Logout Successfully"));
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
