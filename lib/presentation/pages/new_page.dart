// lib/presentation/pages/new_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/new_page_controller.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NewPageController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Page Baru'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text('Tombol Ditekan ${controller.counter.value} kali')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.incrementCounter();
              },
              child: Text('Counter'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.back();
              },
              child: Text('Kembali Ke Menu'),
            ),
          ],
        ),
      ),
    );
  }
}
