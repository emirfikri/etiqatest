import 'package:flutter/material.dart';

import '../../blocs/export_bloc.dart';

void showLogoutConfirm(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      backgroundColor: Colors.white54,
      title: const Text(
        'Confirm Logout ?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.greenAccent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.close),
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            BlocProvider.of<AuthBloc>(context).add(
              SignOutRequested(),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              color: Colors.redAccent,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.done),
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(
                      SignOutRequested(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
