import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userID = ''.obs;
  var name = ''.obs;
  var username = ''.obs;
  var imagesURL = ''.obs;
  var coins = 0.obs;
  var followers = 0.obs;

  Future<void> getUserData() async {
    // Ambil userID dari SharedPreferences
    String? localUserId = await getLocalData('userId');
    if (localUserId == null) {
      print("Tidak ada user ID di SharedPreferences");
      return;
    }

    // Update userID di controller
    userID.value = localUserId;

    // Ambil data user dari Firestore berdasarkan userID
    Map<String, dynamic>? userData = await getDataFirestore(localUserId);

    // Jika data ditemukan, update variabel-variabel terkait
    if (userData != null) {
      name.value = userData['name'] ?? '';
      username.value = userData['username'] ?? '';
      imagesURL.value = userData['imagesURL'] ?? 'assets/images/default_profile.jpeg';
      coins.value = userData['coins'] ?? 0;
      followers.value = userData['followers'] ?? 0;
    } else {
      print("Data user tidak ditemukan di Firestore");
    }
  }

  Future<String?> getLocalData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Map<String, dynamic>?> getDataFirestore(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document =
          await _firestore.collection('users').doc(userId).get();
      return document.data();
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }
}
