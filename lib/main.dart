import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/fcm_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint('Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FCMService _fcmService = FCMService();

  String statusText = 'Waiting for a cloud message';
  String imagePath = 'assets/images/default.png';

  @override
  void initState() {
    super.initState();

    _initializeFCM();
  }

  void _initializeFCM() async {
    await _fcmService.initialize(onData: (message) {
      setState(() {
        statusText =
            message.notification?.title ?? 'Payload received';

        imagePath = 'assets/images/promo.png';
      });
    });

    await _printToken();
  }

  Future<void> _printToken() async {
    final token = await _fcmService.getToken();
    print("\n========== FCM TOKEN ==========");
    print(token);
    print("================================\n");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FCM Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(statusText),
            const SizedBox(height: 20),
            Image.asset(
              imagePath,
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}