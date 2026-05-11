import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/category.dart';

class ApiService {
  static const String baseUrl =
      'https://news.freepi.io/wp-json/wp/v2/posts';

  //Obtener todas las noticias
  Future<List<Post>> fetchPosts(int page) async {
    final response = await http.get(
      Uri.parse('$baseUrl?_embed&page=$page'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar noticias');
    }
  }

  //Obtener categorías
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://news.freepi.io/wp-json/wp/v2/categories'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Category.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar categorías');
    }
  }

  // Filtrar noticias por categoría
  Future<List<Post>> fetchPostsByCategory(int categoryId) async {
    final response = await http.get(
      Uri.parse(
        'https://news.freepi.io/wp-json/wp/v2/posts?categories=$categoryId&_embed',
      ),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Error al filtrar noticias');
    }
  }
}