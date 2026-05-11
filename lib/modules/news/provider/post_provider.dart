import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/post.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Post> posts = [];
  bool isLoading = false;
  String? error;

  int currentPage = 1;
  bool hasMore = true;

  // GUARDAR EN CACHE
  Future<void> _saveCache(List<Post> posts) async {
    final prefs = await SharedPreferences.getInstance();

    final data = posts.map((e) => {
      "id": e.id,
      "title": {"rendered": e.title},
      "content": {"rendered": e.content},
      "excerpt": {"rendered": e.excerpt},
      "_embedded": {
        "wp:featuredmedia": [
          {"source_url": e.imageUrl}
        ]
      }
    }).toList();

    prefs.setString('cached_posts', jsonEncode(data));
  }

  // CARGAR CACHE
  Future<List<Post>> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString('cached_posts');

    if (cached == null) return [];

    final List data = jsonDecode(cached);
    return data.map((e) => Post.fromJson(e)).toList();
  }

  Future<void> getPosts() async {
    //if (posts.isNotEmpty && currentPage == 1) return;

    isLoading = true;
    error = null;
    currentPage = 1;
    hasMore = true;
    notifyListeners();

    try {
      posts = await _apiService.fetchPosts(currentPage);//obtener de API
      await _saveCache(posts); //guardar en cache
    } on SocketException {
      posts = await _loadCache();// sin internet --> cargar cache

      if (posts.isNotEmpty) {
        error = "Modo offline (mostrando datos guardados)";
      } else {
        error = "Sin conexión y sin datos guardados";
      }

    } catch (e) {
      error = "Error al cargar noticias";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMorePosts() async {
    if (!hasMore || isLoading) return;

    isLoading = true;
    notifyListeners();

    currentPage++;

    try {
      final newPosts = await _apiService.fetchPosts(currentPage);

      if (newPosts.isEmpty) {
        hasMore = false;
      } else {
        posts.addAll(newPosts);
        //guardar cache ctualizado
        //se hace aqui para que  solo guarde si realmente hubo cambios
        await _saveCache(posts);
      }
    } on SocketException {
      hasMore = false;
    } catch (e) {
      hasMore = false;
    }

    isLoading = false;
    notifyListeners();
  }
}