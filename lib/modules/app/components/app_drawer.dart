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
      backgroundColor: 
        Theme.of(context)
          .scaffoldBackgroundColor,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context)
                      .colorScheme
                      .primary,

                  Theme.of(context)
                      .colorScheme
                      .secondary,
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
                CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              child: Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context)
                  .iconTheme
                  .color,
            ),
            title: Text("Dashboard"),
            onTap: () {
              onItemSelected(0);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.radio,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Radio"),
            onTap: () {
              onItemSelected(1);
            },
          ),

          ListTile(
            leading: Icon(
              Icons.article,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Noticias"),
            onTap: () {
              onItemSelected(2);
            },
          ),

          ListTile(
            leading:  Icon(
              Icons.person,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text("Perfil"),
            onTap: () {
              onItemSelected(3);
            },
          ),

          SwitchListTile(
            value: theme.isDarkMode,
            secondary:
                const Icon(Icons.dark_mode),
            title: Text(
              "Modo oscuro",
            ),
            onChanged: (value) {
              theme.toggleTheme(value);
            },
          ),

          ListTile(
            leading:
                Icon(
                  Icons.share,
                  color: Theme.of(context).iconTheme.color,
                ),
            title:
                Text("Compartir app"),
            onTap: () {},
          ),

          const Spacer(),

          Divider(
            color: Theme.of(context).dividerColor,
          ),

          ListTile(
            leading:
                Icon(
                  Icons.info,
                  color: Theme.of(context)
                    .iconTheme
                    .color,
                ),
            title:
                Text("Versión 1.0.0"),
          ),

          if (auth.isLoggedIn)
            ListTile(
              leading:
                  Icon(
                    Icons.logout,
                    color: Theme.of(context).iconTheme.color,
                  ),
              title:
                  Text("Cerrar sesión"),
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