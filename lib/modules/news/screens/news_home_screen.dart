import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../provider/post_provider.dart';
import '../../app/provider/favorites_provider.dart';
import '../provider/category_provider.dart';
import 'favorites_screen.dart';
import '../components/search_delegate.dart';
import '../components/news_card.dart';

import 'package:firebase_auth/firebase_auth.dart';

class NewsHomeScreen extends StatefulWidget {
  const NewsHomeScreen({super.key});

  @override
  State<NewsHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState 
    extends State<NewsHomeScreen>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
              _scrollController.position.maxScrollExtent - 200 &&
              !Provider.of<PostProvider>(
                context,
                listen: false,
              ).isLoading) {
        // Cuando llega al final, carga más posts
        Provider.of<PostProvider>(context, listen: false).loadMorePosts();
      }
    });

    Future.microtask(() {
      Provider.of<PostProvider>(context, listen: false).getPosts();
      Provider.of<FavoritesProvider>(
        context,
        listen: false,
      ).loadFavorites("news");
      Provider.of<CategoryProvider>(context, listen: false).getCategories();
    });
  }

  // 2. LIMPIAR EL CONTROLADOR
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildShimmerList() {

    return ListView.builder(
      itemCount: 6,

      itemBuilder: (_, __) {

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),

          child: Shimmer.fromColors(

            baseColor: Theme.of(context).dividerColor,
            highlightColor: Theme.of(context).cardColor,

            child: Container(

              height: 160,

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius:
                    BorderRadius.circular(16),
              ),

              child: Row(
                children: [

                  // IMAGEN
                  Container(
                    width: 120,
                    height: 120,

                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,

                      borderRadius:
                          BorderRadius.horizontal(
                        left: Radius.circular(16),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(12),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                            height: 16,
                            width: double.infinity,
                            color: Theme.of(context).cardColor,
                          ),

                          const SizedBox(height: 10),

                          Container(
                            height: 16,
                            width: 150,
                            color: Theme.of(context).cardColor,
                          ),

                          const SizedBox(height: 20),

                          Container(
                            height: 12,
                            width: double.infinity,
                            color: Theme.of(context).cardColor,
                          ),

                          const SizedBox(height: 8),

                          Container(
                            height: 12,
                            width: 180,
                            color: Theme.of(context).cardColor,
                          ),

                          const SizedBox(height: 8),

                          Align(
                            alignment:
                                Alignment.bottomRight,
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration:
                                  BoxDecoration(
                                color: Theme.of(context).cardColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final postProvider = Provider.of<PostProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate:
                    NewsSearchDelegate(),
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.favorite,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          //CATEGORÍAS
          SizedBox(
            height: 50,
            child: categoryProvider.categories.isEmpty
                ? ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (_, __) {

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 8,
                      ),

                      child: Shimmer.fromColors(
                        baseColor: Theme.of(context).dividerColor,
                        highlightColor: Theme.of(context).cardColor,

                        child: Container(
                          width: 90,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final cat = categoryProvider.categories[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: ChoiceChip(
                          label: Text(cat.name),
                          selected: categoryProvider.selectedCategoryId == cat.id,
                          onSelected: (_) async {
                            final posts =
                                await categoryProvider.filterByCategory(cat.id);
                            postProvider.posts = posts;
                          },
                        ),
                      );
                    },
                  ),
          ),

          //LISTA
          Expanded(
            child: _buildBody(postProvider, favProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(PostProvider postProvider, FavoritesProvider favProvider) {

    //LOADING
    if (postProvider.isLoading && postProvider.posts.isEmpty) {
      return buildShimmerList();
    }

    //ERROR
    if (postProvider.error != null && postProvider.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 50),
            const SizedBox(height: 10),
            Text(
              postProvider.error!,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => postProvider.getPosts(), 
              child: const Text("Reintentar"),
            )
          ],
        ),
      );
    }

    //VACÍO
    if (postProvider.posts.isEmpty) {
      return const Center(child: Text("No hay noticias disponibles"));
    }

    return Column(
      children: [

        if (postProvider.error != null && postProvider.posts.isNotEmpty)
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.all(8),
          child: Text(
            postProvider.error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: () async => await postProvider.getPosts(),
            child: ListView.builder(
              controller: _scrollController,
              //physics: const AlwaysScrollableScrollPhysics(),
              itemCount: postProvider.posts.length + 1,
              itemBuilder: (context, index) {

                //LOADER FINAL
                if (index == postProvider.posts.length) {
                  return postProvider.hasMore
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : const SizedBox();
                }

                //Proteccion extra
                if (index >= postProvider.posts.length) {
                  return const SizedBox();
                }

                final post = postProvider.posts[index];
                final isFav = favProvider.isFavorite("news_${post.id}");

                return Dismissible(
                  key: Key(post.id.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Theme.of(context).colorScheme.error,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.favorite, color: Colors.white),
                  ),

                  confirmDismiss: (_) async {
                    
                    if (FirebaseAuth.instance.currentUser == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Theme.of(context).cardColor,
                          content: Text(
                            "Inicia sesión para guardar favoritos",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                      );
                      return false;
                    }

                    final wasFav = favProvider.isFavorite("news_${post.id}");
                    await favProvider.toggleFavorite(
                      itemId: "news_${post.id}",
                      type: "news",
                      title: post.title,
                      image: post.imageUrl ?? '',
                    );

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
                          onPressed: () async {
                            await favProvider.toggleFavorite(
                              itemId: "news_${post.id}",
                              type: "news",
                              title: post.title,
                              image: post.imageUrl ?? '',
                            );
                          },
                        ),
                      ),
                    );
                    return false; //No elimina el item Visualmente
                  },
                  child: NewsCard(
                    post: post,
                    isFav: isFav,
                    onFavorite: () async {
                      if (FirebaseAuth.instance.currentUser == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).cardColor,
                            content: Text(
                              "Inicia sesión para guardar favoritos",
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyMedium?.color,
                              ),
                            ),
                          ),
                        );
                        return;
                      }
                      await favProvider.toggleFavorite(
                        itemId: "news_${post.id}",
                        type: "news",
                        title: post.title,
                        image: post.imageUrl ?? '',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    ) ;
  }
} 