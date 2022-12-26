import '../repositories/repositories.dart';
import '../screens/loginregister/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'blocs/export_bloc.dart';
import 'configs/firebase_options.dart';
import 'configs/local_notification.dart';
import 'screens/splash/splash_screen.dart';
import 'simple_bloc_observer.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp();
  }
  await LocalNotificationServices().initialize();
  LocalNotificationServices().showFlutterNotification(message);
  print('Handling a background message ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => UserRepository()),
          RepositoryProvider(create: (context) => TodoRepository()),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    AuthBloc(userRepository: context.read<UserRepository>())
                      ..add(Initialized()),
              ),
              BlocProvider(
                create: (context) =>
                    TodoBloc(todoRepository: context.read<TodoRepository>()),
              ),
            ],
            child: OverlaySupport.global(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: {
                  '/splash': (context) => const SplashScreen(),
                  '/auth': (context) => const LoginView(),
                },
                initialRoute: SplashScreen.routeName,
              ),
            )));
  }
}
