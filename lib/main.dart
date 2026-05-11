import 'package:flutter/material.dart';
import 'package:modular_app/app_theme.dart';
import 'package:modular_app/modules/app/provider/auth_provider.dart';
import 'package:modular_app/modules/app/provider/events_provider.dart';
import 'package:modular_app/modules/app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'modules/app/services/notifications/firebase_messaging_service.dart';
import 'modules/app/services/notifications/notification_service.dart';

import 'package:audio_service/audio_service.dart';
import 'modules/radio/services/audio_handler.dart';

import 'modules/app/screens/home_screen.dart';
import 'modules/app/provider/favorites_provider.dart';

import 'modules/news/provider/post_provider.dart';
import 'modules/news/provider/category_provider.dart';

import 'modules/radio/provider/audio_provider.dart';
import 'modules/radio/provider/station_provider.dart';
import 'modules/radio/provider/program_provider.dart';

import 'modules/app/provider/notes_provider.dart';
import 'modules/app/provider/reminders_provider.dart';
import 'modules/app/provider/theme_provider.dart';

import 'modules/app/screens/register_screen.dart';

//HANDLER BACKGROUND
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  //Aqui inicializa Firebase si es que se usara servicio de Firebase dentro de handler
  debugPrint("BACKGROUND MESSAGE: ${message.messageId}");
}

late final MyAudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await NotificationService.init();

  // Inicializa notificaciones
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessagingService().init();

  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'radio_app.channel.audio',
      androidNotificationChannelName: 'Radio Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => ProgramProvider()),
        ChangeNotifierProvider(create: (_) => StationProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => RemindersProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) {
          final provider = FavoritesProvider();
          provider.loadAllFavorites();
          return provider;
        }),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider =
      Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Freepi App Modular',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.currentTheme,
      routes: {
        '/home': (_) => const HomeScreen(),
        '/register': (_) => const RegisterScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

