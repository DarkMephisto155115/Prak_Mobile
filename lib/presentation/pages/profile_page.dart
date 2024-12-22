import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:terra_brain/presentation/routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  Future<void> _showCurrentLocation() async {
    try {
      // Cek izin lokasi 
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Izin lokasi ditolak.';
        }
      }

      // Pastikan lokasi aktif
      if (permission == LocationPermission.deniedForever) {
        throw 'Izin lokasi ditolak secara permanen.';
      }

      // Dapatkan lokasi pengguna
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Format URL untuk Google Maps
      final Uri googleMapsUrl = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}');

      print('Generated URL: $googleMapsUrl');

      // Luncurkan URL di aplikasi eksternal atau fallback ke browser
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Cannot open Google Maps, fallback to browser');
        await launchUrl(
          googleMapsUrl,
          mode: LaunchMode.inAppWebView,
        );
      }
    } catch (e) {
      // Tampilkan pesan kesalahan
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error: $e');
    }
  }

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
                      // '${controller.listRead.length}',
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
                      '${controller.following.value}',
                      // '0',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      'Follwing',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
                onPressed: () => _showCurrentLocation(),
                icon: const Icon(Icons.location_on),
                label: const Text('Show Current Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
            ),
            const SizedBox(height: 20),
            // story yang user publish
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