import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'notification_service.dart';

class FirebaseMessagingService {

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {

    // Pedir permisos
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint("Permission: ${settings.authorizationStatus}");

    // Obtener token
    String? token = await _messaging.getToken();

    debugPrint("FCM TOKEN:");
    debugPrint(token);

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      print("🔥🔥🔥 MENSAJE RECIBIDO 🔥🔥🔥");
      print(message.notification?.title);
      print(message.notification?.body);
      print(message.data);

      if (message.notification != null) {
        debugPrint(message.notification!.title);
        debugPrint(message.notification!.body);

        await NotificationService.showNotification(
          id: 0,
          title: message.notification!.title ?? "Sin título",
          body: message.notification!.body ?? "Sin contenido",
        );
      }
    });

    // Cuando el usuario toca la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      debugPrint("NOTIFICACIÓN ABIERTA");
    });
  }
}