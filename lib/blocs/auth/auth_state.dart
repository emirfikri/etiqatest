part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

// When the user presses the signin or signup button the state is changed to loading first and then to Authenticated.
class Loading extends AuthState {}

// When the user is authenticated the state is changed to Authenticated.
class Authenticated extends AuthState {
  final User user;

  const Authenticated({required this.user});
}

// This is the initial state of the bloc. When the user is not authenticated the state is changed to Unauthenticated.
class UnAuthenticated extends AuthState {
  final String? message;

  const UnAuthenticated({this.message});
}

// If any error occurs the state is changed to AuthError.
class AuthError extends AuthState {
  final String error;

  const AuthError({required this.error});
}
