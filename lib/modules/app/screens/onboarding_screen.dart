import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {

  final PageController controller =
      PageController();

  bool isLastPage = false;

  Future<void> finishOnboarding() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      'seenOnboarding',
      true,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),
    );
  }

  Widget buildPage({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {

    return Padding(

      padding: const EdgeInsets.all(30),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Container(

            padding: const EdgeInsets.all(30),

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              color: Colors.white.withOpacity(0.08),

              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withOpacity(0.25),
                  blurRadius: 30,
                ),
              ],
            ),

            child: Icon(
              icon,
              size: 100,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 50),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 17,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,

            colors: [
              Color(0xFF081C2C),
              Color(0xFF12324A),
              Color(0xFF1F5A7A),
            ],
          ),
        ),

        child: SafeArea(

          child: Column(

            children: [

              Expanded(

                child: PageView(

                  controller: controller,

                  onPageChanged: (index) {
                    setState(() {
                      isLastPage = index == 3;
                    });
                  },

                  children: [

                    buildPage(
                      icon: Icons.radio,
                      title: "Radio en vivo",
                      subtitle:
                          "Escucha tus estaciones favoritas desde cualquier lugar.",
                    ),

                    buildPage(
                      icon: Icons.newspaper,
                      title: "Noticias actualizadas",
                      subtitle:
                          "Descubre información y novedades en tiempo real.",
                    ),

                    buildPage(
                      icon: Icons.favorite,
                      title: "Guarda favoritos",
                      subtitle:
                          "Accede rápidamente a tus noticias y programas favoritos.",
                    ),

                    buildPage(
                      icon: Icons.dark_mode,
                      title: "Experiencia personalizada",
                      subtitle:
                          "Disfruta una app moderna con modo oscuro y diseño premium.",
                    ),
                  ],
                ),
              ),

              Padding(

                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 30,
                ),

                child: Row(

                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                  children: [

                    TextButton(
                      onPressed: finishOnboarding,
                      child: const Text(
                        "Saltar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),

                    SmoothPageIndicator(
                      controller: controller,
                      count: 4,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: Colors.white,
                        dotColor: Colors.white38,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),

                    ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(

                        backgroundColor:
                            Colors.white,

                        foregroundColor:
                            const Color(0xFF12324A),
                      ),

                      onPressed: () async {

                        if (isLastPage) {
                          finishOnboarding();
                        } else {
                          controller.nextPage(
                            duration: const Duration(
                              milliseconds: 500,
                            ),
                            curve: Curves.easeInOut,
                          );
                        }
                      },

                      child: Text(
                        isLastPage
                            ? "Comenzar"
                            : "Siguiente",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}