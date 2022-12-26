import 'dart:io';

import 'package:etiqa/blocs/export_bloc.dart';
import '../../models/models.dart';
import '../../widgets/custom_notitication.dart';
import '../todo/todo_page.dart';
import '/screens/loginregister/login_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../configs/local_notification.dart';
import '../../cubit/dashboard/dashboard_cubit.dart';
import '../../helpers/style.dart';
import '../../models/user_model.dart';
import '../profile/profile_page.dart';
import 'package:overlay_support/overlay_support.dart';

class Dashboard extends StatelessWidget {
  final User user;
  const Dashboard({Key? key, required this.user}) : super(key: key);

  static Route<void> route({required User user}) {
    return MaterialPageRoute(
      builder: (context) => Dashboard(
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginView()));
          }
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DashboardCubit()),
            BlocProvider(create: (_) => NotificationBloc(userId: user.userId)),
          ],
          child: DashboardView(user: user),
        ),
      ),
    );
  }
}

class DashboardView extends StatefulWidget {
  final User user;
  const DashboardView({
    Key? key,
    required this.user,
  }) : super(key: key);

  static Route<void> route({required User user}) {
    return MaterialPageRoute(
      builder: (context) => DashboardView(
        user: user,
      ),
    );
  }

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  String? _token;
  late Stream<String> _tokenStream;
  @override
  void initState() {
    FirebaseMessaging.onMessage
        .listen(LocalNotificationServices().showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('CLICKED!');
    });

    requestPerm();
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BGpdLRsMJKvFDD9odfPk92uBg-JbQbyoiZdah0XlUyrjG4SDgUsE1iC_kdRgt4Kn0CO7K3RTswPZt61NNuO0XoA')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);
    super.initState();
  }

  Future requestPerm() async {
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token;
    });
    if (Platform.isAndroid) {
      BlocProvider.of<AuthBloc>(context).add(
        AddedToken(userId: widget.user.userId, token: token!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab =
        context.select((DashboardCubit cubit) => cubit.state.tab);

    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state is NewNotificationTodoTrigger) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showoverlay(state.todo, state.message, state.desc);
          });
        }
      },
      child: dashboardScaffold(selectedTab, context),
    );
  }

  showoverlay(Todo todo, String? message, String? desc) {
    return showOverlayNotification(position: NotificationPosition.bottom,
        (context) {
      return MessageNotification(
        onReply: () {
          OverlaySupportEntry.of(context)!.dismiss();
          toast('you checked this message');
        },
        id: todo.id,
        title: message ?? todo.title,
        desc: desc ?? '',
      );
    }, duration: const Duration(seconds: 3));
  }

  dashboardScaffold(selectedTab, context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: IndexedStack(
        index: selectedTab.index,
        children: [
          TodoPage(user: widget.user),
          ProfileScreen(user: widget.user)
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 9,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _HomeTabButton(
              groupValue: selectedTab,
              value: DashboardTab.todo,
              icon: const Icon(Icons.pending_actions),
              label: 'To-do',
            ),
            _HomeTabButton(
              groupValue: selectedTab,
              value: DashboardTab.profile,
              icon: const Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTabButton extends StatelessWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
    required this.label,
  });

  final DashboardTab groupValue;
  final DashboardTab value;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => context.read<DashboardCubit>().setTab(value),
          iconSize: 32,
          color: groupValue != value ? Colors.grey : kprimarytheme,
          icon: icon,
        ),
        Text(
          label,
          style: TextStyle(
            color: groupValue != value ? null : kprimarytheme,
          ),
        ),
      ],
    );
  }
}
