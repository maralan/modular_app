import 'package:flutter/material.dart';
import 'package:modular_app/modules/app/provider/favorites_provider.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';

class AppDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  const AppDrawer({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {

    final auth =
        Provider.of<AuthProvider>(context);

    final theme =
        Provider.of<ThemeProvider>(context);

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF12324A),
                  Color(0xFF1E5878),
                ],
              ),
            ),

            accountName: const Text(
              "Freepi User",
            ),

            accountEmail: Text(
              auth.user?.email ??
                  "Invitado",
            ),

            currentAccountPicture:
                const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 40,
                color: Color(0xFF12324A),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () {
              onItemSelected(0);
            },
          ),

          ListTile(
            leading: const Icon(Icons.radio),
            title: const Text("Radio"),
            onTap: () {
              onItemSelected(1);
            },
          ),

          ListTile(
            leading: const Icon(Icons.article),
            title: const Text("Noticias"),
            onTap: () {
              onItemSelected(2);
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Perfil"),
            onTap: () {
              onItemSelected(3);
            },
          ),

          SwitchListTile(
            value: theme.isDarkMode,
            secondary:
                const Icon(Icons.dark_mode),
            title: const Text(
              "Modo oscuro",
            ),
            onChanged: (value) {
              theme.toggleTheme(value);
            },
          ),

          ListTile(
            leading:
                const Icon(Icons.share),
            title:
                const Text("Compartir app"),
            onTap: () {},
          ),

          const Spacer(),

          const Divider(),

          ListTile(
            leading:
                const Icon(Icons.info),
            title:
                const Text("Versión 1.0.0"),
          ),

          if (auth.isLoggedIn)
            ListTile(
              leading:
                  const Icon(Icons.logout),
              title:
                  const Text("Cerrar sesión"),
              onTap: () {
                auth.logout();
                context
                    .read<FavoritesProvider>()
                    .favorites
                    .clear();

                context
                    .read<FavoritesProvider>()
                    .favoriteItems
                    .clear();
                Navigator.pop(context);
              },
            ),
        ],
      ),
    );
  }
}