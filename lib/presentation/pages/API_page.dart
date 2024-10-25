import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/best_seller_list_controller.dart';


class BestSellerListScreen extends GetView<BestSellerListController> {
  @override
  Widget build(BuildContext context) {
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

              },
            );
          },
        );
      }),
    );
  }
}
