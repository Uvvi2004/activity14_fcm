import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<void> initialize({
    required void Function(RemoteMessage) onData,
  }) async {
    // request permission
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      onData(message);
    });

    // when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onData(message);
    });

    // when app opened from terminated state
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      onData(initialMessage);
    }
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }
}