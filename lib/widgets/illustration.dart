import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../helpers/style.dart';

class ToDoIllustration extends StatelessWidget {
  const ToDoIllustration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/illustrations/list.svg',
              height: 350, width: 350),
          const SizedBox(height: 10),
          const Text('Create To Do List Now',
              style: TextStyle(
                  color: klightGray,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
