import 'package:flutter/material.dart';
import '../services/firebase/favorites_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesService _service = FavoritesService();

  Set<String> favorites = {};

  List<Map<String, dynamic>> favoriteItems = [];

  Future<void> loadFavorites(String type) async {
    //Carga global segura
    await loadAllFavorites();
  }

  Future<void> toggleFavorite({
    required String itemId,
    required String type,
    required String title,
    required String image,
  }) async {

    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }

    if (favorites.contains(itemId)) {

    await _service.removeFavorite(itemId);

  } else {

    await _service.addFavorite(
      type: type,
      itemId: itemId,
      title: title,
      image: image,
    );

    favorites.add(itemId);
  }
  //Recarga global real
  await loadAllFavorites();
  }

  bool isFavorite(String itemId) {
    return favorites.contains(itemId);
  }

  Future<void> loadAllFavorites() async {

    if (FirebaseAuth.instance.currentUser == null){
      favorites.clear();
      favoriteItems.clear();
      notifyListeners();
      return;
    }

    final newsFavorites =
        await _service.getFavoritesByType( 
      "news",
    );

    final programFavorites =
        await _service.getFavoritesByType(
      "program",
    );

    favorites = {
      ...newsFavorites,
      ...programFavorites,
    };

    favoriteItems =
        await _service.getAllFavorites();
    notifyListeners();
  }
}