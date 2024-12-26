import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteController extends GetxController {
  final RxBool isConnected = false.obs;
  final RxBool isUploading = false.obs;
  var userId = ''.obs;
  var username = ''.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();
  final GetStorage _storage = GetStorage();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _initializeStorage();
    _monitorConnection();
    _checkLocalPendingUploads();
    _getLocalData();
    _getWriterName();
  }

  Future<String?> _getLocalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? localUserId = prefs.getString('userId');
    if (localUserId == null) {
    } else {
      userId.value = localUserId;
    }
    return localUserId;
  }

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
        // print("anda kembali online");
        _checkLocalPendingUploads();
      } else {
        bool isConnectedNow = false;
        isConnected.value = isConnectedNow;
        _showConnectionSnackbar(isConnected.value);
        // print("anda ofline");
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

  Future<void> _checkInitialConnection() async {
    // print("Memeriksa koneksi awal...");
    var result = await _connectivity.checkConnectivity();
    // print("Koneksi awal: $result");
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile)) {
      bool conection = true;
      isConnected.value = conection;
      // print("isConnected awal: ${isConnected.value}");
      _showConnectionSnackbar(isConnected.value);
    } else {
      bool conection = false;
      isConnected.value = conection;
      // print("isConnected awal: ${isConnected.value}");
      _showConnectionSnackbar(isConnected.value);
    }
  }

  Future<void> _getWriterName () async {
    try{
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId.value).get();
      username.value = userDoc['username'];
    } catch (e){}   
  }

  Future<String?> _uploadFileToStorage(File file, String path) async {
    try {
      // Cek koneksi
      if (isConnected.value) {
        // Upload ke Firebase Storage
        final Reference storageRef = FirebaseStorage.instance.ref().child(path);
        final UploadTask uploadTask = storageRef.putFile(file);
        final TaskSnapshot snapshot = await uploadTask;
        final String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        // Jika offline, simpan file secara lokal
        Directory dir = await getApplicationDocumentsDirectory();
        String localPath = "${dir.path}/${path.split('/').last}";
        await file.copy(localPath);

        // Simpan informasi ke pending uploads
        _addToPendingUploads(localPath, path);

        // Kembalikan null untuk menandakan file belum diunggah
        return null;
      }
    } catch (e) {
      // Tangani error jika terjadi
      rethrow;
    }
  }

  void _addToPendingUploads(String localPath, String firebasePath) {
    List<Map<String, String>> pendingUploads =
        (_storage.read('pending_files') as List<dynamic>? ?? [])
            .map((item) => Map<String, String>.from(item))
            .toList();

    // Tambahkan file ke daftar pending uploads
    pendingUploads.add({"localPath": localPath, "firebasePath": firebasePath});
    _storage.write('pending_files', pendingUploads);
  }

  // Save Media Locally and Return File Path
  Future<String> saveFileLocally(File file, String filename) async {
    try {
      Directory dir = await getApplicationDocumentsDirectory();
      String filePath = "${dir.path}/$filename";
      await file.copy(filePath);
      return filePath;
    } catch (e) {
      // print("Error saving file locally: $e");
      rethrow;
    }
  }

  // Upload Data to Firebase Firestore
  @override
  Future<void> uploadData({
    required String title,
    required String content,
    required String category,
    File? imageFile,
    File? audioFile,
  }) async {
    try {
      isUploading.value = true;

      // Paths for Firebase Storage
      String? imageUrl;
      String? audioUrl;

      if (imageFile != null) {
        String imagePath =
            'images/${DateTime.now().millisecondsSinceEpoch}.png';
        imageUrl = await _uploadFileToStorage(imageFile, imagePath);
      }
      if (audioFile != null) {
        String audioPath =
            'audios/${DateTime.now().millisecondsSinceEpoch}.aac';
        audioUrl = await _uploadFileToStorage(audioFile, audioPath);
      }

      String createdAt = DateTime.now().toIso8601String();

      Map<String, dynamic> data = {
        "title": title,
        "content": content,
        "writerId": userId.value,
        "author": username.value,
        "category": category,
        "imageUrl": imageUrl,
        "audioUrl": audioUrl,
        "createdAt": createdAt,
      };

      if (isConnected.value) {
        await FirebaseFirestore.instance.collection('stories').add(data);
        Get.snackbar("Upload Successful", "Data uploaded to Firestore.",
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary);
      } else {
        _saveDataLocally(data);
        Get.snackbar("No Internet", "Data saved locally for later upload.",
            backgroundColor: Get.theme.disabledColor,
            colorText: Get.theme.colorScheme.onError);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to upload data: $e",
          backgroundColor: Get.theme.disabledColor,
          colorText: Get.theme.colorScheme.onError);
      // print("error: $e");
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
    // print("data yang disimpan di local: $data");
    // print("data ditulis dib local sementara");
    _storage.write('pending_uploads', pendingUploads);
  }

  // Check and Upload Local Pending Data
  void _checkLocalPendingUploads() async {
    if (isConnected.value) {
      List<Map<String, String>> pendingUploads =
          (_storage.read('pending_files') as List<dynamic>? ?? [])
              .map((item) => Map<String, String>.from(item))
              .toList();

      if (pendingUploads.isNotEmpty) {
        for (var fileData in pendingUploads) {
          try {
            // Unggah file dari path lokal ke Firebase Storage
            File localFile = File(fileData["localPath"]!);
            String firebasePath = fileData["firebasePath"]!;
            final String? downloadUrl =
                await _uploadFileToStorage(localFile, firebasePath);

            // Hapus file lokal jika berhasil diunggah
            localFile.deleteSync();
          } catch (e) {
            // Jika gagal, lanjut ke file berikutnya
            print("Gagal mengunggah file tertunda: $e");
          }
        }

        // Hapus semua data dari pending uploads jika selesai
        _storage.remove('pending_files');
      }
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
