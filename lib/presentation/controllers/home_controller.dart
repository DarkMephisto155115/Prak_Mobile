import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:terra_brain/presentation/controllers/favorites_controller.dart';
import 'package:video_player/video_player.dart';


class HomeController extends GetxController {
  final favoritesController = Get.find<FavoritesController>();
  final box = GetStorage(); 
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var selectedImagePath = ''.obs;
  var isImageLoading = false.obs;

  var selectedVideoPath = ''.obs;
  var isVideoPlaying = false.obs;
  VideoPlayerController? videoPlayerController;

  var stories = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _getStories();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    super.onClose();
  }

  void _getStories() {
  try {
    _firestore.collection('stories').snapshots().listen((snapshot) {
      final List<Map<String, dynamic>> updatedStories = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'title': doc['title'],
          'image': doc['imageUrl'],
          'author': doc['author'],
        };
      }).toList();

      if (!const ListEquality().equals(stories, updatedStories)) {
        // Update hanya jika ada perubahan
        stories.value = updatedStories;
      }
    });
  } catch (e) {
    // print("Error: $e");
  }
}



}
