import 'package:cached_network_image/cached_network_image.dart';
import '../../helpers/style.dart';
import 'package:flutter/material.dart';
import '../../helpers/constants.dart';
import '../../models/user_model.dart';
import '../../widgets/showlogoutpopup.dart';
import 'profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  static String routeName = "/profile";

  const ProfileScreen({super.key, required this.user});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProfileBody(
          user: user,
        ),
      ),
    );
  }
}

class ProfileBody extends StatelessWidget {
  final User user;
  const ProfileBody({super.key, required this.user});

  static const Grey = Color.fromRGBO(157, 157, 157, 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(user.username,
            style:
                const TextStyle(fontFamily: "worksans", color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.transparent),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                width: 150,
                height: 150,
                child: Image.asset("assets/images/defaultprofile.png"),
              ),
              const SizedBox(height: 15),
              Text(
                user.email,
                style: const TextStyle(
                    fontFamily: "worksans",
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: Constants.height * 0.05,
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(kprimarytheme),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      color: Colors.white,
                    )),
                  ),
                  child: Text(
                    'UID: ${user.uid}',
                    style: const TextStyle(
                        fontFamily: "worksans",
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w300),
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Column(
                  children: <Widget>[
                    const Divider(height: 0.1, color: Grey),
                    const SizedBox(height: 10),
                    ProfileMenu(
                      text: "Log Out",
                      icon: "assets/icons/Log out.svg",
                      press: () {
                        showLogoutConfirm(context);
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
