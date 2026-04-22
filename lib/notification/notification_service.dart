import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  //  INIT
  static Future<void> init() async {
    // Request permission (IMPORTANT)
    await _firebaseMessaging.requestPermission();

    //  Get FCM Token
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM TOKEN: $token");

    //  Local notification setup
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(settings);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // Background tap (when app opened from notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("Notification clicked!");
    });
  }

  //  SHOW LOCAL NOTIFICATION
  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'channel_id',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      0,
      message.notification?.title ?? "No Title",
      message.notification?.body ?? "No Body",
      details,
    );
  }
}