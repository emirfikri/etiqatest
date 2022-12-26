part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Initialized extends AuthEvent {}

class AddedToken extends AuthEvent {
  final int userId;
  final String token;
  const AddedToken({required this.userId, required this.token});
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String username;
  final String password;

  const SignInRequested(this.username, this.password);
}

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  const SignUpRequested(
    this.username,
    this.email,
    this.password,
  );
}

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends AuthEvent {}

class ChangePasswordRequested extends AuthEvent {
  final String newPassword;
  final int userId;

  const ChangePasswordRequested(
    this.newPassword,
    this.userId,
  );
}
