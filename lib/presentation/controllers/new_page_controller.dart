// lib/presentation/controllers/new_page_controller.dart
import 'package:get/get.dart';

class NewPageController extends GetxController {
  var counter = 0.obs;

  void incrementCounter() {
    counter.value++;
  }
}
