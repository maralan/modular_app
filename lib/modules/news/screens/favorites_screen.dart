import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';
import '../../app/provider/favorites_provider.dart';
import '../components/news_card.dart';

import 'package:flutter/services.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);

    final favoritePosts = postProvider.posts
        .where((post) => favProvider.isFavorite("news_${post.id}"))
        .toList();

    final validFavorites = favoritePosts.where((post) {
      // ignore: unnecessary_null_comparison
      return post.id != null;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoritos"),
      ),

      body: validFavorites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No tienes favoritos",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                //refresca la lista base por si cambio algo
                await postProvider.getPosts();
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: validFavorites.length,
                itemBuilder: (context, index) {

                  final post = validFavorites[index];
                  final isFav = favProvider.isFavorite("news_${post.id}");

                  return Dismissible(
                    key: ValueKey('fav_${post.id}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),

                    confirmDismiss: (_) async {
                      final wasFav = favProvider.isFavorite("news_${post.id}");

                      favProvider.toggleFavorite(
                        itemId: "news_${post.id}",
                        type: "news",
                        title: post.title,
                        image: post.imageUrl ?? '',
                      );

                      HapticFeedback.lightImpact();

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            wasFav
                              ? "Eliminado de favoritos"
                              : "Agregado a favoritos",
                          ),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: "Deshacer",
                            onPressed: () {
                              favProvider.toggleFavorite(
                                itemId: "news_${post.id}",
                                type: "news",
                                title: post.title,
                                image: post.imageUrl ?? '',
                              );
                            },
                          ),
                        ),
                      );

                      return false;
                    },

                    child: NewsCard(
                      post: post,
                      isFav: isFav,
                      onFavorite: () => favProvider.toggleFavorite(
                        itemId: "news_${post.id}",
                        type: "news",
                        title: post.title,
                        image: post.imageUrl ?? '',
                      ),
                    ),
                  );
                },
              ),
            ),
          
    );
  }
}