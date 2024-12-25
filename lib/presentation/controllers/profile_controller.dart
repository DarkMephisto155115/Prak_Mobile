import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final logger = Logger();

  var userID = ''.obs;
  var name = ''.obs;
  var username = ''.obs;
  var imagesURL = ''.obs;
  var coins = 0.obs;
  var followers = 0.obs;
  var following = 0.obs;
  var stories = <Map<String, dynamic>>[].obs;

 var length = 0.obs;



  @override
  void onInit() {
    super.onInit();
    _getUserData();
    fetchStories();

  Future<void> _getUserData() async {
    String? localUserId = await getLocalData('userId');
    print("user Id: $localUserId");
    if (localUserId == null) {
      print("Tidak ada user ID di SharedPreferences");
      return;
    }

    userID.value = localUserId;

    Map<String, dynamic>? userData = await getDataFirestore(localUserId);
    print(userData);

    if (userData != null) {
      name.value = userData['name'] ?? '';
      username.value = userData['username'] ?? '';
      imagesURL.value =
          userData['imagesURL'] ?? 'assets/images/default_profile.jpeg';
      coins.value = userData['coins'] ?? 0;
      followers.value = userData['followers'] ?? 0;
      following.value = userData['following'] ?? 0;
    } else {
      print("Data user tidak ditemukan di Firestore");
    }
  }

  Future<String?> getLocalData(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    } catch (e) {
      print("Error accessing SharedPreferences: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getDataFirestore(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document =
          await _firestore.collection('users').doc(userId).get();
      if (document.exists) {
        print(document.data());
        return document.data()!;
      } else {
        print("Data tidak ditemukan dari id: $userId");
        return null;
      }
    } catch (e) {
      print("Error fetching data: $e");
      return null;
    }
  }

  Future<void> fetchStories() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('stories')
          .where('writerId', isEqualTo: userID.value)
          .get();

      // Update the reactive list with fetched stories
      stories.value = querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();


    } catch (e) {
      print('Error fetching stories: $e');
    }
  }
}