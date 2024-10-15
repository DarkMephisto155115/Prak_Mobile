import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../controllers/LoginController.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.emailController,
              decoration: InputDecoration(
                labelText: 'Email or username',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 16),
            Obx(() => TextField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
              style: TextStyle(color: Colors.white),
            )),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // controller.login();
                Get.toNamed(Routes.HOME);
              },
              child: Text('Log in'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, // Warna teks button
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTRATION);
              },
              child: Text('Register'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, // Warna teks button
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Get.snackbar('Forgot Password', 'Redirect to forgot password');
              },
              child: Text('Forgot password?', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Get.snackbar('Sign Up', 'Redirect to sign up');
              },
              child: Text("Don't have an account? Sign up", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}