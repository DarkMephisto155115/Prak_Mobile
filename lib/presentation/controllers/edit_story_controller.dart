import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class EditStoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final dateFormat = DateFormat('dd-MM-yyyy');

  // Data Story
  var storyId = ''.obs;
  var title = ''.obs;
  var content = ''.obs;
  var author = ''.obs;
  var date = ''.obs;
  var imagePath = ''.obs;
  var category = ''.obs;
  var favorite = 0.obs;

  // Profil penulis
  var writerId = ''.obs;
  var writerName = ''.obs;
  var writerUsername = ''.obs;
  var writerImage = ''.obs;
  var writerFollower = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Menggunakan ever untuk memantau perubahan pada storyId

    ever(storyId, (String id) {
      print("Story ID has changed to: $id"); // Log perubahan storyId
      if (id.isNotEmpty) {
        fetchStory();
      } else {
        print("Story ID is empty, fetch not triggered.");
      }
    });
  }

  // Mengubah ID cerita yang akan diambil
  void setStoryId(String id) {
    print("Setting storyId to: $id"); // Log ketika ID cerita diubah
    storyId.value = id;
    print("storyId.value set to: ${storyId.value}");
  }

  // Mengambil data cerita dari Firestore
  void fetchStory() async {
    try {
      if (storyId.value.isEmpty) {
        print("Data tidak ditemukan karena storyId kosong");
        return; // Menghindari query Firestore jika ID kosong
      }

      print("Fetching story with ID: ${storyId.value}");

      DocumentSnapshot<Map<String, dynamic>> document =
      await _firestore.collection('stories').doc(storyId.value).get();
      print("Fetched story document: ${document.data()}");

      if (document.exists) {
        var storyData = document.data()!;
        title.value = storyData['title'] ?? '';
        content.value = storyData['content'] ?? '';
        author.value = storyData['author'] ?? '';
        date.value = storyData['createdAt'] != null
            ? dateFormat.format(DateTime.parse(storyData['createdAt']))
            : '';
        imagePath.value = storyData['imageUrl'] ?? '';
        category.value = storyData['category'] ?? '';
        favorite.value = storyData['favorite'] ?? 0;

        print("Story data loaded: $storyData");

        // Mengambil writerId dari data cerita dan mengambil informasi penulis
        writerId.value = storyData['writerId'];
        fetchWriter(); // Fetch data penulis
      } else {
        print("Data tidak ditemukan untuk storyId: ${storyId.value}");
      }
    } catch (e) {
      print('Error fetching story: $e');
    }
  }

  // Mengambil data profil penulis dari Firestore
  void fetchWriter() async {
    try {
      if (writerId.value.isEmpty) {
        print("Writer ID is empty, fetch skipped.");
        return;
      }

      print("Fetching writer with ID: ${writerId.value}");

      DocumentSnapshot<Map<String, dynamic>> writerDocument =
      await _firestore.collection('users').doc(writerId.value).get();
      print("Fetched writer document: ${writerDocument.data()}");

      if (writerDocument.exists) {
        var writerData = writerDocument.data()!;
        writerName.value = writerData['name'];
        writerUsername.value = writerData['username'] ?? '';
        writerImage.value = writerData['imagesURL'] ?? '';
        writerFollower.value = writerData['follower'] ?? 0;

        print("Writer data loaded: $writerData");
      } else {
        print("Writer data not found for writerId: ${writerId.value}");
      }
    } catch (e) {
      print('Error fetching writer: $e');
    }
  }

  // Fungsi untuk mengedit cerita
  Future<void> editStory({
    required String newTitle,
    required String newContent,
    String? newImageUrl, // Opsional, jika ada gambar baru
  }) async {
    try {
      if (storyId.value.isEmpty) {
        print("Story ID is empty, cannot update the story.");
        return;
      }

      print("Updating story with ID: ${storyId.value}");

      Map<String, dynamic> updatedData = {
        'title': newTitle,
        'content': newContent,
        'updatedAt': DateTime.now().toIso8601String(), // Menambahkan waktu update
      };

      if (newImageUrl != null && newImageUrl.isNotEmpty) {
        updatedData['imageUrl'] = newImageUrl; // Menambahkan URL gambar jika ada
      }

      await _firestore.collection('stories').doc(storyId.value).update(updatedData);

      // Memperbarui data di controller setelah sukses
      title.value = newTitle;
      content.value = newContent;
      if (newImageUrl != null && newImageUrl.isNotEmpty) {
        imagePath.value = newImageUrl;
      }

      print("Story updated successfully with data: $updatedData");
    } catch (e) {
      print('Error updating story: $e');
    }
  }
}
