import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //String get uid => _auth.currentUser!.uid; //VERDADERO PROBLEMA DE QUE TRUENA
  String? get uid => _auth.currentUser?.uid;

  Future<void> addFavorite({
    required String type,
    required String itemId,
    required String title,
    required String image,

  }) async {
    await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .doc(itemId)

        .set({
          'type': type,
          'itemId': itemId,
          'title': title,
          'image': image,
          'createdAt':
              FieldValue.serverTimestamp(),
        });
  }

  Future<void> removeFavorite(String itemId) async {
    await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .doc(itemId)
        .delete();
  }

  Future<bool> isFavorite(String itemId) async {
    final doc = await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .doc(itemId)
        .get();

    return doc.exists;
  }

  Future<List<String>> getFavoriteByType(String type) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .where('type', isEqualTo: type)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<String>> getFavoritesByType(String type) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .where('type', isEqualTo: type)
        .get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<Map<String, dynamic>>>
      getFavoritesFull(String type) async {

    final snapshot = await _db
        .collection('users')
        .doc(uid ?? '')
        .collection('favorites')
        .where('type', isEqualTo: type)
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .toList();
  }

  Future<List<Map<String, dynamic>>>
    getAllFavorites() async {

  final snapshot = await _db
      .collection('users')
      .doc(uid ?? '')
      .collection('favorites')
      .get();

  return snapshot.docs
      .map((doc) => doc.data())
      .toList();
}
}