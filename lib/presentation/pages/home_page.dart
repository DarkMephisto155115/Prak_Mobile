// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/app/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.REGISTRATION);  // Navigate to Registration Page
              },
              child: Text('Go to Registration Form'),
            ),
            SizedBox(height: 20),  // Adds space between buttons
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.LOGIN);  // Navigate to Login Page
              },
              child: Text('Go to Login Form'),
            ),
          ],
        ),
      ),
    );
  }
}
