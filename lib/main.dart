import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'pages/login_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (!Platform.isAndroid) return;

  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'orders_channel',
    'New Orders',
    channelDescription: 'New order notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound(
      'mixkit_doorbell_single_press_333',
    ),
  );

  const NotificationDetails details =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    '🔔 नवीन ऑर्डर आली',
    message.notification?.body ?? 'नवीन ऑर्डर तपासा',
    details,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    const AndroidNotificationChannel channel =
        AndroidNotificationChannel(
      'orders_channel',
      'New Orders',
      description: 'New order notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(
        'mixkit_doorbell_single_press_333',
      ),
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'orders_channel',
        'New Orders',
        channelDescription: 'New order notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound(
          'mixkit_doorbell_single_press_333',
        ),
      );

      const NotificationDetails details =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        '🔔 नवीन ऑर्डर आली',
        message.notification?.body ?? 'नवीन ऑर्डर तपासा',
        details,
      );
    });

    final token = await FirebaseMessaging.instance.getToken();

    print("================================");
    print("FCM TOKEN: $token");
    print("================================");
  } catch (e, s) {
    print("ERROR = $e");
    print("STACK = $s");
  }
await FirebaseMessaging.instance.requestPermission();

String? token = await FirebaseMessaging.instance.getToken();

if (token != null) {
  await FirebaseFirestore.instance
      .collection('admin_tokens')
      .doc('billing_app')
      .set({
    'token': token,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}

debugPrint("FCM TOKEN = $token");

FirebaseMessaging.instance.onTokenRefresh.listen((token) {
  debugPrint("NEW TOKEN = $token");
});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shreenath Veg Billing",
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}