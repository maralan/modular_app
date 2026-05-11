import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/post.dart';
import '../services/api_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Category> categories = [];
  int? selectedCategoryId;

  Future<void> getCategories() async {
    try {
      categories = await _apiService.fetchCategories();
      print("CATEGORIAS: ${categories.length}");
      notifyListeners();
    } catch (e) {
      print("ERROR: $e");
    }
  }

  Future<List<Post>> filterByCategory(int categoryId) async {
    selectedCategoryId = categoryId;
    notifyListeners();
    return await _apiService.fetchPostsByCategory(categoryId);
  }
}