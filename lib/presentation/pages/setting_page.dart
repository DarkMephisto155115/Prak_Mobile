import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/controllers/seeting_controller.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        title: const Text('Setting'),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Tambahkan navigasi ke halaman Edit Profile di sini
              print("Navigate to Edit Profile");
            },
          ),
          Divider(color: Colors.grey[800]),
          ListTile(
            title: const Text(
              'Favorite Books',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Tambahkan navigasi ke halaman Favorite Books di sini
              print("Navigate to Favorite Books");
            },
          ),
          Divider(color: Colors.grey[800]),
          Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.pinkAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.pinkAccent),
            ),
            onTap: () {
              // Panggil fungsi logout dari controller
              controller.logout();
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
