import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final CollectionReference favorites = FirebaseFirestore.instance.collection('favorites');

  Stream<QuerySnapshot> getFavoritesStream() {
    return favorites.snapshots();
  }

  Future<void> addFavorite(String? title, String? author, String? description) async {
    if (title == null || title.isEmpty || author == null || author.isEmpty || description == null || description.isEmpty) {
      Get.snackbar("Error", "All fields must be filled out");
      return;
    }

    try {
      await favorites.add({
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
      await favorites.doc(id).update({
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
      await favorites.doc(id).delete();
      Get.snackbar("Success", "Favorite deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete favorite: $e");
    }
  }
}
