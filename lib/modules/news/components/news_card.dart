import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/post.dart';
import '../screens/detail_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NewsCard extends StatelessWidget {
  final Post post;
  final bool isFav;
  final VoidCallback onFavorite;

  const NewsCard({
    super.key,
    required this.post,
    required this.isFav,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 300),
              pageBuilder: (_, __, ___) => DetailScreen(post: post),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [

              // 🖼️ IMAGEN
              if (post.imageUrl != null)
                ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: Hero(
                      tag: 'post_${post.id}',
                      child: Image.network(
                        post.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Theme.of(context).dividerColor,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                ),

              // 📄 CONTENIDO
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Html(
                        data: post.excerpt,
                        style: {
                          "p": Style(
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                        },
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          icon: Icon(
                            isFav
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFav ? Theme.of(context).colorScheme.error : null,
                          ),
                          onPressed: () {
                            final user =
                                FirebaseAuth
                                    .instance
                                    .currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    content: Text(
                                      "Iniciar sesión para guardar favoritos",
                                    ),
                                  ),
                                );
                                return;
                            }
                            onFavorite();
                          },
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
    ).animate().fade(
      duration: 400.ms,
    ).slideY(
      begin: 0.1,
      end: 0,
    );
  }
}