import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/routes/app_pages.dart';
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
        title: const Text('Profile'),
        titleTextStyle: const TextStyle(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Get.toNamed(Routes.SETTING);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => CircleAvatar(
              radius: 50,
              backgroundImage: controller.imagesURL.value.isNotEmpty
                  ? NetworkImage(controller.imagesURL.value)
                  : const AssetImage('assets/images/default_profile.jpeg') as ImageProvider,
            )),
            const SizedBox(height: 16),
            Obx(() => Text(
              controller.name.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )),
            Obx(() => Text(
              '@${controller.username.value}',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            )),
            const SizedBox(height: 16),

            // Coins and followers
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '${controller.coins.value}',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Text(
                        'Coins',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      Text(
                        '${controller.followers.value}',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Text(
                        'Followers',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),

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
                const SizedBox(width: 40),
                Column(
                  children: const [
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
            const SizedBox(height: 20),
            // Story card
            Expanded(
              child: ListView(
                children: [
                  Card(
                    color: Colors.grey[900],
                    child: const ListTile(
                      leading: Icon(Icons.book, color: Colors.white),
                      title: Text(
                        'Darksiders concept',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        '0 Published Stories',
                        style: TextStyle(color: Colors.grey),
                      ),
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
