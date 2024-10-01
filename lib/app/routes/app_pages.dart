// lib/app/routes/app_pages.dart
import 'package:get/get.dart';
import 'package:terra_brain/presentation/pages/home_page.dart';
import 'package:terra_brain/presentation/pages/new_page.dart';
import 'package:terra_brain/presentation/controllers/new_page_controller.dart';
import 'package:terra_brain/presentation/pages/image_page.dart';
import 'package:terra_brain/presentation/pages/registration_page.dart';

import '../../presentation/pages/login_page.dart'; // Add this import

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.NEW_PAGE,
      page: () => const NewPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut<NewPageController>(() => NewPageController());
      }),
    ),
    GetPage(
      name: Routes.IMAGE_PAGE, // Add route for the image page
      page: () => const ImagePage(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => RegistrationPage(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
    ),
  ];
}
