import 'package:flutter/material.dart';
import '../../blocs/export_bloc.dart';
import '../loginregister/login_page.dart';
import '../dashboard/dashboard.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is Authenticated) {
        return Dashboard(
          user: state.user,
        );
      }
      return const LoginView();
    });
  }
}
