import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/post_provider.dart';
import '../../app/provider/favorites_provider.dart';
import '../components/news_card.dart';

class NewsSearchDelegate extends SearchDelegate {

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = "",
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResults(context);
  }

  Widget _buildResults(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final theme = Theme.of(context);

    // SIN TEXTO
    if (query.isEmpty) {
      return Center(
        child: Text(
          "Escribe para buscar noticias",
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
      );
    }

    final results = postProvider.posts.where((post) {
      return post.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // SIN RESULTADOS
    if (results.isEmpty) {
      return Center(
        child: Text(
          "No se encontraron resultados",
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
          ),
        )
      );
    }

    // RESULTADOS
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final post = results[index];
        final isFav = favProvider.isFavorite("news_${post.id}");

        return NewsCard(
          post: post,
          isFav: isFav,
          onFavorite: () => favProvider.toggleFavorite(
            itemId: "news_${post.id}",
            type: "news",
            title: post.title,
            image: post.imageUrl ?? '',
          ),
        );
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);

    return theme.copyWith(
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: theme.textTheme.bodyMedium
              ?.color
              ?.withOpacity(0.7),
        ),
        border: InputBorder.none,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: theme.textTheme.bodyLarge?.color,
          fontSize: 18,
        ),
      ),
    );
  }
}