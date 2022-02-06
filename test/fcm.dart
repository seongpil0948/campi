import 'package:flutter_test/flutter_test.dart';

void main() async {
  test('Counter value should be incremented', () {
    final counter = Counter();

    counter.increment();

    expect(counter.value, 1);
  });
  // final response = await http.post(
  //   Uri.parse('https://api.rnfirebase.io/messaging/send'),
  //   headers: <String, String>{
  //     'Content-Type': 'application/json; charset=UTF-8',
  //     'Authorization':
  //         'AAAAwrAkBJI:APA91bElzJIvB9Emm26zxdjg40kHwdc--nrlyqhVYntdNuNwSEfqV5ATOMFtv8UokacRc0rCAZwKl9MiREkOEHdTzXjzDbjVAq1ZW5VMbFGZTQc8LJ2pnPfdkYKhsUxR2lf4oaTiap2D'
  //   },
  //   body: constructFCMPayload(
  //       "fuTCZ2jpRPOV_pemnFmVGH:APA91bHIz19gW8p31I6xfb9Ia1mIjlvhDX9gSH85pjJ1GekO_KeyaiMYSxa9K9vSGLj416334GorN4qk3bOf-MVzRjNnYTIA_9mvX7sex-KZYHGeH5AYTe7T8ik6-T0qaYSJCyVZQOpp"),
  // );
  // debugPrint(
  //     "Response: ${response.statusCode} ${response.reasonPhrase} ${response.body}");
}

// String constructFCMPayload(String? token) {
//   return jsonEncode({
//     'token': token,
//     'data': {
//       'via': 'FlutterFire Cloud Messaging!!!',
//       'count': 100,
//     },
//     'notification': {
//       'title': 'Hello FlutterFire!',
//       'body': 'This notification (100) was created via FCM!',
//     },
//   });
// }

class Counter {
  int value = 0;

  void increment() => value++;

  void decrement() => value--;
}
