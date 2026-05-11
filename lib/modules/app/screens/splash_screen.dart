import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    startApp();
  }

  Future<void> startApp() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final prefs =
        await SharedPreferences.getInstance();

    final seenOnboarding =
        prefs.getBool('seenOnboarding') ??
            false;

    final user =
        FirebaseAuth.instance.currentUser;

    if (user != null) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );

      return;
    }

    if (!seenOnboarding) {

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
              const OnboardingScreen(),
        ),
      );

      return;
    }

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF12324A),

      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.radio,
              size: 100,
              color: Colors.white,
            ),

            const SizedBox(height: 20),

            const Text(

              "Freepi App",

              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(

              "Noticias y Radio",

              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}