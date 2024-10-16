import 'package:get/get.dart';
import 'package:terra_brain/presentation/controllers/LoginController.dart';
import 'package:terra_brain/presentation/controllers/best_seller_list_controller.dart';
import 'package:terra_brain/presentation/controllers/profile_controller.dart';


class MainBinding extends Bindings {
  @override
  void dependencies() {
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
          () => LoginController(),
    );
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
  }
}

class APIBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BestSellerListController>(
          () => BestSellerListController(),
    );
  }
}