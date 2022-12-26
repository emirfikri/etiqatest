import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationRepository {
  sendNotification({List? token, title, body}) async {
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      var reposne = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Authorization':
              'key=AAAAwrZnveY:APA91bGxts14xNqxjgw4xHV90KvfGKoBxwyoxolsNfsT_KmVGPaqT6Lh4a3hkO9vuGikYP-TbHa-6Q-VaFdflinB-sA6wJxSi9V__qbf1l5S8-N9OBz73hitLXKm8l3_QAjHmGD2t0ye',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(
          token,
          title,
          body,
        ),
      );
      print('FCM request for device sent!');
      print("reposne ${reposne.body}");
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendPushMessage() async {}

  String constructFCMPayload(List? token, String title, String body) {
    String alltoken = '';
    var mapData;
    if (token != null) {
      alltoken = token.join(',');
    }
    print("alltoken == $alltoken");
    return jsonEncode({
      "to": alltoken,
      "collapse_key": "type_a",
      "notification": {
        "title": "$title",
        "body": "$body",
      },
      "data": {
        "title": "$title",
        "body": "$body",
      },
      // "Simulator Target Bundle": "com.me.mysample",
      // "aps": {
      //   "badge": 0,
      //   "alert": {
      //     "title": "Test Push $_messageCount",
      //     "body": "$_messageCount Success! Push notification in simulator! 🎉",
      //     "sound": "default"
      //   }
      // },
      "gcm.message_id": "123",
      "example-data-key": "example-data-value"
    });
  }
}
