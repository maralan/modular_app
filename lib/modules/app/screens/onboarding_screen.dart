import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> finishOnboarding(
    BuildContext context,
  ) async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'seenOnboarding',
      true,
    );

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

      body: Padding(

        padding: const EdgeInsets.all(24),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            const Icon(
              Icons.radio,
              size: 120,
              color: Color(0xFF12324A),
            ),

            const SizedBox(height: 40),

            const Text(

              "Bienvenido a Freepi",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(

              "Escucha radio, descubre noticias y guarda tus favoritos.",

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(0xFF12324A),

                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),

                onPressed: () {
                  finishOnboarding(context);
                },

                child: const Text(
                  "Comenzar",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}