// best_seller_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/best_seller_list_controller.dart';


class BestSellerListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BestSellerListController());

    return Scaffold(
      appBar: AppBar(
        title: Text('WATTPAD Best Categories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.bestSellerLists.length,
          itemBuilder: (context, index) {
            final category = controller.bestSellerLists[index];
            return ListTile(
              title: Text(category.displayName),
              subtitle: Text('Updated: ${category.updated}'),
              onTap: () {
                // Action on category tap, e.g., show book list or details
              },
            );
          },
        );
      }),
    );
  }
}
