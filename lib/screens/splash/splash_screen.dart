import 'dart:async';
import 'package:flutter/material.dart';
import '../authgate/auth_gate.dart';
import '../dashboard/dashboard.dart';
import '/configs/size_config.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AuthGate())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Colors.deepOrange,
              Colors.deepOrangeAccent,
              Colors.orange,
              Colors.orangeAccent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Image(
                image: AssetImage('assets/icons/logo.png'),
                width: 125,
                height: 125,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              color: Colors.white70,
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 20,
              ),
              child: Text(
                'Etiqa To-Do App',
                style: Theme.of(context).textTheme.headline2!.copyWith(
                      color: Colors.white,
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
