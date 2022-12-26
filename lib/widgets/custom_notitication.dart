import 'package:flutter/material.dart';

import '../helpers/style.dart';

class MessageNotification extends StatelessWidget {
  final VoidCallback onReply;
  final String id;
  final String title;
  final String desc;
  const MessageNotification({
    Key? key,
    required this.onReply,
    required this.id,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: kprimarytheme,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SafeArea(
        child: Opacity(
          opacity: 1.0,
          child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(color: Colors.white),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          title,
                          maxLines: 5,
                          style: const TextStyle(
                              fontFamily: "worksans",
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(desc),
                          ],
                        ),
                        trailing: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              onReply();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
