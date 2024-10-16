
import 'package:get/get.dart';
import 'package:terra_brain/presentation/bindings/main_bindings.dart';
import 'package:terra_brain/presentation/pages/API_page.dart';
import 'package:terra_brain/presentation/pages/home_page.dart';
import 'package:terra_brain/presentation/pages/profile_page.dart';
import 'package:terra_brain/presentation/pages/image_page.dart';
import 'package:terra_brain/presentation/pages/registration_page.dart';
import '../../presentation/pages/login_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),

    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfileScreen(),
      binding: ProfileBinding()
    ),
    GetPage(
      name: Routes.IMAGE_PAGE,
      page: () => const ImagePage(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => RegistrationPage(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding()
    ),
    GetPage(
      name: Routes.API,
      page: () => BestSellerListScreen(),
      binding: APIBinding()
    ),
  ];
}
