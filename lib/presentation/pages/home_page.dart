// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/app/routes/app_pages.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Selamat datang di Menu Utama!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.NEW_PAGE);  // Navigate to New Page
              },
              child: const Text('Ke Menu Counter'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.IMAGE_PAGE);  // Navigate to Image Page
              },
              child: const Text('Ke Menu Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
