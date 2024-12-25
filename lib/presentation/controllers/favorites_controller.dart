import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _userFavorites {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User is not logged in");
    }
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('Favorite');
  }

  Stream<QuerySnapshot> getFavoritesStream() {
    return _userFavorites.snapshots();
  }

  Future<void> addFavorite(String? title, String? author, String? description) async {
    if (title == null || title.isEmpty || author == null || author.isEmpty || description == null || description.isEmpty) {
      Get.snackbar("Error", "All fields must be filled out");
      return;
    }

    try {
      await _userFavorites.add({
        'title': title,
        'author': author,
        'description': description,
      });
      Get.snackbar("Success", "Favorite added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add favorite: $e");
    }
  }

  Future<void> updateFavorite(String id, String? title, String? author, String? description) async {
    if (title == null || title.isEmpty || author == null || author.isEmpty || description == null || description.isEmpty) {
      Get.snackbar("Error", "All fields must be filled out");
      return;
    }

    try {
      await _userFavorites.doc(id).update({
        'title': title,
        'author': author,
        'description': description,
      });
      Get.snackbar("Success", "Favorite updated successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to update favorite: $e");
    }
  }

  Future<void> deleteFavorite(String id) async {
    try {
      await _userFavorites.doc(id).delete();
      Get.snackbar("Success", "Favorite deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete favorite: $e");
    }
  }
}
