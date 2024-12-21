import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteController extends GetxController {
  final RxBool isConnected = false.obs; // Tracks connectivity status
  final RxBool isUploading = false.obs; // Tracks upload process
  var userId = ''.obs;

  final Connectivity _connectivity = Connectivity();
  final GetStorage _storage = GetStorage();
  // late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initializeStorage();
    _monitorConnection();
    _checkLocalPendingUploads();
    _getLocalData();
  }

  // void _getUserid() async {
  //   String? localUserId = await getLocalData('userId');
  //   if (localUserId == null) {
  //     print("Tidak ada user ID di SharedPreferences");
  //     return;
  //   }
  // }
  Future<String?> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? localUserId = prefs.getString('userId');
    if (localUserId == null) {
      print("Tidak ada userId");
    } else {
      print("User id: $localUserId");
      userId.value = localUserId;
    }
    return localUserId;

    // return prefs.getString();
  }

  // Initialize GetStorage
  Future<void> _initializeStorage() async {
    await GetStorage.init();
  }

  void _monitorConnection() {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        bool isConnectedNow = true;
        isConnected.value = isConnectedNow;
        _showConnectionSnackbar(isConnected.value);
        print("anda kembali online");
        _checkLocalPendingUploads();
      } else {
        bool isConnectedNow = false;
        isConnected.value = isConnectedNow;
        _showConnectionSnackbar(isConnected.value);
        print("anda ofline");
      }
    });
  }

  void _showConnectionSnackbar(bool status) {
    if (status) {
      Get.snackbar(
        "Internet Connected",
        "You are now online.",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Internet Disconnected",
        "You are offline.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Future<void> _checkInitialConnection() async {
  //   var result = await _connectivity.checkConnectivity();
  //   isConnected.value = result == ConnectivityResult.mobile ||
  //       result == ConnectivityResult.wifi;
  // }

  // Save Media Locally and Return File Path
  Future<String> saveFileLocally(File file, String filename) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/$filename";
      await file.copy(filePath);
      return filePath;
    } catch (e) {
      print("Error saving file locally: $e");
      rethrow;
    }
  }

  // Upload Data to Firebase Firestore
  Future<void> uploadData({
    required String title,
    required String content,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      isUploading.value = true;

      // Save media files locally and get file paths
      String? imagePath;
      String? audioPath;

      if (imageFile != null) {
        imagePath = await saveFileLocally(
            imageFile, 'image_${DateTime.now().millisecondsSinceEpoch}.png');
      }
      if (audioFile != null) {
        audioPath = await saveFileLocally(
            audioFile, 'audio_${DateTime.now().millisecondsSinceEpoch}.aac');
      }

      String createdAt = DateTime.now().toIso8601String();

      Map<String, dynamic> data = {
        "title": title,
        "content": content,
        "imagePath": imagePath,
        "audioPath": audioPath,
        "createdAt": createdAt,
      };

      if (isConnected.value) {
        // Upload to Firebase
        // await FirebaseFirestore.instance.collection('stories').add(data);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId.value)
            .collection('stories')
            .add(data);
        Get.snackbar("Upload Successful", "Data uploaded to Firestore.",
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        _saveDataLocally(data);
        print("yang disimpan di local untuk pending $data");
        Get.snackbar("No Internet", "Data saved locally for later upload.",
            backgroundColor: Get.theme.disabledColor,
            colorText: Get.theme.colorScheme.onError);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload data: $e",
          backgroundColor: Get.theme.disabledColor,
          colorText: Get.theme.colorScheme.onError);
      print("error: $e");
    } finally {
      isUploading.value = false;
    }
  }

  // Save Data Locally
  void _saveDataLocally(Map<String, dynamic> data) {
    List<String> pendingUploads =
        (_storage.read('pending_uploads') as List<dynamic>?)
                ?.map((item) => item.toString())
                .toList() ??
            [];
    pendingUploads.add(jsonEncode(data));
    print("data yang disimpan di local: $data");
    print("data ditulis dib local sementara");
    _storage.write('pending_uploads', pendingUploads);
  }

  // Check and Upload Local Pending Data
  void _checkLocalPendingUploads() async {
    if (isConnected.value) {
      List<String> pendingUploads =
          (_storage.read('pending_uploads') as List<dynamic>?)
                  ?.map((item) => item.toString())
                  .toList() ??
              [];
      if (pendingUploads.isNotEmpty) {
        for (String jsonData in pendingUploads) {
          try {
            Map<String, dynamic> data = jsonDecode(jsonData);
            print(data);
            // await FirebaseFirestore.instance.collection('stories').add(data);
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId.value)
                .collection('stories')
                .add(data);
          } catch (e) {
            print("Failed to upload pending data: $e");
          }
        }
        _storage.remove('pending_uploads');
        Get.snackbar("Pending Uploads", "All pending data has been uploaded.",
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary);
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
