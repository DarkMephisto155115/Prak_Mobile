import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var isPasswordHidden = true.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    String email = emailController.text;
    String password = passwordController.text;

    // Logika untuk login (tambahkan validasi email/password)
    if (email.isNotEmpty && password.isNotEmpty) {
      Get.snackbar('Success', 'Logged in successfully');
      // Navigasi ke halaman berikutnya
    } else {
      Get.snackbar('Error', 'Please enter email and password');
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}