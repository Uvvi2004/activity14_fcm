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

    // ✅ THIS FIXES FOREGROUND NOTIFICATIONS
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("FOREGROUND MESSAGE RECEIVED"); // debug
      onData(message);
    });

    // when app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("OPENED FROM BACKGROUND"); // debug
      onData(message);
    });

    // when app opened from terminated state
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print("OPENED FROM TERMINATED"); // debug
      onData(initialMessage);
    }
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }
}