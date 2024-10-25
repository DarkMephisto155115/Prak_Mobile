import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF171717),
        elevation: 0,
        title: Text('Profile'),
        titleTextStyle: TextStyle(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile image and username
            GestureDetector(
              onTap: () {
                controller.pickImage();
              },
              child: Obx(() {
                return CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImagePath.value.isEmpty
                      ? AssetImage('assets/images/default_profile.jpeg')
                      : FileImage(File(controller.profileImagePath.value)),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              'Augmunted hum...',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '@AndikaSalsabilah',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 16),

            // Coins and followers
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '${controller.coins.value}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'Coins',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 40),
                  Column(
                    children: [
                      Text(
                        '${controller.followers.value}',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      Text(
                        'Followers',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              );
            }),
            SizedBox(height: 20),

            // Buttons for lists and followers
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '2',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'Reading Lists',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    Text(
                      '0',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),

            // Story card
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: Colors.grey[900],
                    child: ListTile(
                      leading: Icon(Icons.book, color: Colors.white),
                      title: Text(
                        'Darksiders concept',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text('0 Published Stories',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
