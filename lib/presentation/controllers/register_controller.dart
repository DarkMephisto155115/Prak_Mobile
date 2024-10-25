import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  var name = ''.obs;
  var email = ''.obs;
  var username = ''.obs;
  var password = ''.obs;
  var birthDate = ''.obs;
  var pronouns = ''.obs;
  var profileImagePath = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController birthDateController = TextEditingController();
  
 
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path; // Menyimpan path gambar
    }
  }

  Future<void> register() async {
    if (name.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        username.value.isEmpty ||
        birthDate.value.isEmpty) {
      throw Exception('Please fill in all fields');
    }
    if (profileImagePath.isNotEmpty) {
      await uploadProfileImage();
    }
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      String uid = userCredential.user!.uid;

      await _firestore.collection('users').doc(uid).set({
        'name': name.value,
        'email': email.value,
        'username': username.value,
        'birthDate': birthDate.value,
        'pronouns': pronouns.value,
        "imageURL": "",
        "coins": 0,
        "folowers": 0,
        "dolowing": 0,
      });

      Get.snackbar('Success', 'User registered successfully');
      Get.toNamed('/login');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> uploadProfileImage() async {
    File file = File(profileImagePath.value);
    try {
      // Menentukan referensi penyimpanan
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      // Mengunggah file
      await ref.putFile(file);

      String downloadUrl = await ref.getDownloadURL();

      print('Image uploaded: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
      throw e; 
    }
  }
}
