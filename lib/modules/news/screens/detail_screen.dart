import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/post.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Post post;

  const DetailScreen({
    super.key,
    required this.post,
  });

  @override
  State<DetailScreen> 
      createState() => 
      _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  @override
  void initState() {
    super.initState();
    saveRecentNews();
  }

  Future<void>
      saveRecentNews() async {

    final prefs =
        await SharedPreferences
            .getInstance();

    List<String> recent =
        prefs.getStringList(
              'recent_news',
            ) ??
            [];

    final newsData = jsonEncode({
      'id': widget.post.id,
      'title': widget.post.title,
      'image':
          widget.post.imageUrl,
    });

    recent.remove(newsData);
    recent.insert(0, newsData);

    if (recent.length > 10) {
      recent = recent.take(10).toList();
    }

    await prefs.setStringList(
      'recent_news',
      recent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          // APPBAR PRO
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.post.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              background: widget.post.imageUrl != null
                  ? Hero(
                      tag: 'post_${widget.post.id}',
                      child: Image.network(
                        widget.post.imageUrl!,
                        fit: BoxFit.cover,

                        // LOADING
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },

                        // ERROR
                        errorBuilder: (_, __, ___) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image_not_supported),
                            ),
                          );
                        },
                      ),
                    )
                  : Container(color: Colors.grey),
            ),
          ),

          // CONTENIDO
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Html(
                data: widget.post.content,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    lineHeight: const LineHeight(1.5),
                  ),
                  "p": Style(
                    margin: Margins.only(bottom: 12),
                  ),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}