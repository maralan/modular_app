import 'package:flutter/material.dart';

import 'package:modular_app/modules/radio/screens/radio_home_screen.dart';
import 'package:modular_app/modules/news/screens/news_home_screen.dart';
import 'package:modular_app/modules/app/screens/profile_screen.dart';
import '../../radio/components/mini_player.dart';
import '../components/app_drawer.dart';
import 'dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;

  final List<Widget> screens = [
    const DashboardScreen(),
    const RadioHomeScreen(),
    const NewsHomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(
          color:  Colors.white,
        ),
      ),
      drawer: AppDrawer(
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
          Navigator.pop(context);
        },
      ),

      body: Stack(
        clipBehavior: Clip.none,
        children: [
          screens[currentIndex],
          const Positioned(
            left: 12, 
            right: 12,
            bottom: 58,
            child: MiniPlayer(),
          )
        ],
      ),

      bottomNavigationBar: Padding(

        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 12,
        ),

        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              labelTextStyle:
                  WidgetStateProperty.resolveWith<TextStyle>(

                (states) {

                  if (states.contains(
                      WidgetState.selected)) {

                    return const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    );
                  }

                  return TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  );
                },
              ),
              destinations: [

                NavigationDestination(

                  icon: Icon(
                    Icons.dashboard_outlined,
                    color:
                        Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                  ),

                  selectedIcon: Icon(
                    Icons.dashboard,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),

                  label: "App",
                ),

                NavigationDestination(

                  icon: Icon(
                    Icons.radio_outlined,
                    color:
                        Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                  ),

                  selectedIcon: Icon(
                    Icons.radio,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),

                  label: "Radio",
                ),

                NavigationDestination(

                  icon: Icon(
                    Icons.newspaper_outlined,
                    color: Theme.of(context).brightness ==
                            Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),

                  selectedIcon: Icon(
                    Icons.newspaper,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),

                  label: "News",
                ),

                NavigationDestination(

                  icon: Icon(

                    Icons.person_outline,

                    color:
                        Theme.of(context).brightness ==
                                Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                  ), 

                  selectedIcon: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),

                  label: "Perfil",
                ),
              ],
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              height: 72,
              backgroundColor: Theme.of(context).cardColor,
              indicatorColor: const Color(0xFF1E3A5F),
            ),
          ),
        ),
      ),
    );
  }
}