import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

import '../provider/auth_provider.dart';
import '../provider/theme_provider.dart';

import '../../app/provider/favorites_provider.dart';

import '../../radio/provider/audio_provider.dart';
import '../../radio/provider/program_provider.dart';

import '../../news/provider/post_provider.dart';
import '../../news/screens/favorites_screen.dart';
import '../../news/screens/detail_screen.dart';

import 'dart:convert';

class DashboardScreen extends StatefulWidget{
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen>
      createState() =>
          _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? lastStationName;
  String? lastStationImage;
  String? lastStationSlogan;

  List<Map<String, dynamic>>
      recentNews = [];

  @override
  void initState() {
    super.initState();
    loadLastStation();
    SchedulerBinding.instance
        .addPostFrameCallback((_) {
      if (mounted) {
        context
            .read<FavoritesProvider>()
            .loadAllFavorites();
      }
    });
  }

  Future<void>
      loadLastStation() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    setState(() {

      lastStationName =
          prefs.getString(
        'last_station_name',
      );

      lastStationImage =
          prefs.getString(
        'last_station_image',
      );

      lastStationSlogan =
          prefs.getString(
        'last_station_slogan',
      );

      final recent =
        prefs.getStringList(
              'recent_news',
            ) ??
            [];

    recentNews = recent
        .map(
          (e) => jsonDecode(e)
              as Map<String, dynamic>,
        )
        .toList();
    });
  }

  @override
  Widget build(
    BuildContext context,
    ) {

    final auth = Provider.of<AuthProvider>(context);
    final audio = Provider.of<AudioProvider>(context);
    final posts = Provider.of<PostProvider>(context);
    final favorites = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            if (lastStationName != null)
              Container(
                margin:
                    const EdgeInsets.only(
                  bottom: 25,
                ),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(24),
                  color:
                      Theme.of(context)
                          .cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.horizontal(
                        left: Radius.circular(24),
                      ),
                      child: (lastStationImage != null &&
                            lastStationImage!.isNotEmpty)
                        ? Image.network(
                            lastStationImage!,
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,

                            errorBuilder: (
                              context,
                              error,
                              stackTrace,
                            ) {
                              return Container(
                                width: 110,
                                height: 110,
                                color: Theme.of(context).dividerColor,
                                child: const Icon(
                                  Icons.radio,
                                  size: 40,
                                ),
                              );
                            },
                          )
                        : Container(
                            width: 110,
                            height: 110,
                            color: Theme.of(context).dividerColor,
                            child: const Icon(
                              Icons.radio,
                              size: 40,
                            ),
                          ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Última estación",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              lastStationName ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Text(
                              lastStationSlogan ?? '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (recentNews.isNotEmpty) ...[

              const SizedBox(height: 10),

              Text(
                "Noticias recientes",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              const SizedBox(height: 18),

              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection:
                      Axis.horizontal,
                  itemCount:
                      recentNews.length,
                  itemBuilder:
                      (context, index) {
                    final news =
                        recentNews[index];
                    return Container(
                      width: 220,
                      margin:
                          const EdgeInsets.only(
                        right: 16,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(24),
                        color:
                            Theme.of(context)
                                .cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).shadowColor.withOpacity(0.1),
                            blurRadius: 12,
                          ),
                        ],
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: (news['image'] != null &&
                                news['image'].toString().isNotEmpty)
                            ? Image.network(
                                news['image'],
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                errorBuilder: (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                                  return Container(
                                    height: 130,
                                    color: Theme.of(context).dividerColor,
                                    child: const Icon(
                                      Icons.image,
                                      size: 40,
                                    ),
                                  );
                                },
                              )
                            : Container(
                                height: 130,
                                color: Theme.of(context).dividerColor,
                                child: const Icon(
                                  Icons.image,
                                  size: 40,
                                ),
                              ),
                          ),

                          Padding(
                            padding:
                                const EdgeInsets.all(14),
                            child: Text(
                              news['title'] ?? '',
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],

            // SALUDO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF12324A),
                    Color(0xFF1E5878),
                  ],
                ),

                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    "Bienvenido 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    auth.user?.email ??
                        "Usuario",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Tu aplicación modular está funcionando correctamente.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ).animate().fade().slideY(),

            const SizedBox(height: 30),

            Text(
              "Resumen general",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 20),

            // CARDS
            Row(
              children: [

                Expanded(
                  child: _buildCard(
                    icon: Icons.radio,
                    title: "Radio",
                    subtitle: audio.isPlaying
                        ? "Reproduciendo"
                        : "Pausado",
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: _buildCard(
                    icon: Icons.article,
                    title: "Noticias",
                    subtitle:
                        "${posts.posts.length} posts",
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Consumer<ThemeProvider>(
              builder: (
                context,
                themeProvider,
                _,
              ) {

                return Container(

                  padding:
                      const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,

                    borderRadius:
                        BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.08),
                        blurRadius: 10,
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      const Icon(
                        Icons.dark_mode,
                        size: 30,
                        color: Color(0xFF12324A),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            Text(
                              "Modo oscuro",
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Cambia la apariencia de la app",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Switch(
                        value:
                            themeProvider.isDarkMode,

                        onChanged: (value) {
                          themeProvider
                              .toggleTheme(value);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            Container(

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,

                borderRadius:
                    BorderRadius.circular(22),

                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.08),
                    blurRadius: 10,
                  ),
                ],
              ),

              child: Row(

                children: [

                  Icon(
                    Icons.notifications_active,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),

                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Text(
                          "Notificaciones",
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Firebase Messaging activo",
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // FAVORITOS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  "Favoritos recientes",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
 
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FavoritesScreen(),
                      ),
                    );
                  },

                  child: const Text(
                    "Ver todos",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            SizedBox(

              height: 220,

              child: favorites.favoriteItems.isEmpty

                  ? const Center(
                      child: Text(
                        "No hay favoritos aún",
                      ),
                    )

                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount:favorites.favoriteItems.length,
                      itemBuilder: (context, index) {

                        final fav = favorites.favoriteItems[index];
                        
                        final matchingPosts =
                            posts.posts.where(
                              (p) =>
                                  "news_${p.id}" ==
                                  fav['itemId'],
                            );

                        if (matchingPosts.isEmpty) {
                          return const SizedBox();
                        }

                        final post =
                            matchingPosts.first;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailScreen(
                                  post: post,
                                ),
                              ),
                            );
                          },

                          child: Container(
                            width: 170,
                            margin:
                                const EdgeInsets.only(
                              right: 14,
                            ),

                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius:
                                  BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor.withOpacity(0.08),
                                  blurRadius: 10,
                                ),
                              ],
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                        const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),

                                    child: (fav['image'] != null &&
                                          fav['image'].toString().isNotEmpty)
                                      ? Image.network(
                                          fav['image'],
                                          height: 130,
                                          width: double.infinity,
                                          fit: BoxFit.cover,

                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return Container(
                                              height: 130,
                                              color: Theme.of(context).dividerColor,
                                              child: const Icon(
                                                Icons.image,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        )
                                      : Container(
                                          height: 130,
                                          color: Theme.of(context).dividerColor,
                                          child: const Icon(
                                            Icons.image,
                                            size: 40,
                                          ),
                                        ),
                                  ),
                                ),

                                Padding(
                                  padding:
                                      const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fav['title'] ??  '',
                                        maxLines: 2,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Text(
                                        "Favorito guardado",
                                        maxLines: 1,
                                        overflow:TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.color
                                              ?.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 30),

            Text(
              "Programas destacados",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 260,
              child: Consumer<ProgramProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).dividerColor,
                          highlightColor: Theme.of(context).cardColor,
                          child: Container(
                            width: 220,
                            margin: const EdgeInsets.only(
                              right: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        );
                      },
                    );
                  }

                  if (provider.programs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay programas",
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.programs.length,
                    itemBuilder: (context, index) {
                      final program =
                          provider.programs[index];
                      return Container(
                        width: 220,
                        margin:
                            const EdgeInsets.only(
                          right: 16,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(24),
                          color:
                              Theme.of(context)
                                  .cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.08),
                              blurRadius: 12,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),

                              child: program.imageUrl.isNotEmpty
                                  ? Image.network(
                                      program.imageUrl,
                                      height: 140,
                                      width: double.infinity,
                                      fit: BoxFit.cover,

                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 140,
                                          color: Theme.of(context).dividerColor,
                                          child: const Icon(
                                            Icons.image,
                                            size: 40,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      height: 140,
                                      color: Theme.of(context).dividerColor,
                                      child: const Icon(
                                        Icons.image,
                                        size: 40,
                                      ),
                                    ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    program.title,
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    program.description,
                                    maxLines: 3,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Programas favoritos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 220,
              child: Consumer<FavoritesProvider>(
                builder: (
                  context,
                  favProvider,
                  _,
                ) {
                  final programFavorites =
                      favProvider.favoriteItems
                          .where(
                            (fav) =>
                                fav['type'] ==
                                'program',
                          )
                          .toList();

                  if (programFavorites.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay programas favoritos",
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection:
                        Axis.horizontal,
                    itemCount:
                        programFavorites.length,
                    itemBuilder:
                        (context, index) {
                      final fav =
                          programFavorites[index];
                      return Container(
                        width: 200,
                        margin:
                            const EdgeInsets.only(
                          right: 16,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(24),
                          color:
                              Theme.of(context)
                                  .cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor.withOpacity(0.08),
                              blurRadius: 12,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),

                              child: (fav['image'] != null &&
                                    fav['image'].toString().isNotEmpty)
                                ? Image.network(
                                    fav['image'],
                                    height: 130,
                                    width: double.infinity,
                                    fit: BoxFit.cover,

                                    errorBuilder: (
                                      context,
                                      error,
                                      stackTrace,
                                    ) {
                                      return Container(
                                        height: 130,
                                        color: Theme.of(context).dividerColor,
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    height: 130,
                                    color: Theme.of(context).dividerColor,
                                    child: const Icon(
                                      Icons.image,
                                      size: 40,
                                    ),
                                  ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    fav['title'] ?? '',
                                    maxLines: 2,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    "Programa favorito",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {

    return Container(

      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.08),
            blurRadius: 10,
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          CircleAvatar(
            backgroundColor:
                color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}