import 'package:get/get.dart';
import 'package:terra_brain/presentation/bindings/main_bindings.dart';
import 'package:terra_brain/presentation/pages/API_page.dart';
import 'package:terra_brain/presentation/pages/edit_profile_page.dart';
import 'package:terra_brain/presentation/pages/favorite_page.dart';
import 'package:terra_brain/presentation/pages/gps_page.dart';
import 'package:terra_brain/presentation/pages/home_page.dart';
import 'package:terra_brain/presentation/pages/profile_page.dart';
import 'package:terra_brain/presentation/pages/image_page.dart';
import 'package:terra_brain/presentation/pages/registration_page.dart';
import 'package:terra_brain/presentation/pages/setting_page.dart';
import 'package:terra_brain/presentation/pages/splash_screen.dart';
import 'package:terra_brain/presentation/pages/story_page.dart';
import '../../presentation/pages/login_page.dart';
import '../pages/write_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
    ),
    GetPage(
        name: Routes.PROFILE,
        page: () => const ProfileScreen(),
        binding: ProfileBinding()),
    GetPage(
      name: Routes.IMAGE_PAGE,
      page: () => const ImagePage(),
    ),
    GetPage(
      name: Routes.REGISTRATION,
      page: () => const RegistrationPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
        name: Routes.API,
        page: () => BestSellerListScreen(),
        binding: APIBinding()),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.SETTING,
      page: () => const SettingPage(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: Routes.FAVORITE,
      page: () => FavoritesPage(),
      binding: FavoriteBinding(),
    ),
    GetPage(
      name: Routes.WRITE,
      page: () => const WriteStoryPage(),
      binding: SensorBinding(),
    ),
    GetPage(
      name: Routes.GPS,
      page: () => const GpsPage(),
      binding: GpsBinding(),
    ),
    GetPage(
      name: Routes.Edit,
      page: () => EditProfilePage(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: Routes.READ,
      page: () => StoryPage(),
      binding: StoryBinding(),
    ),
  ];
}
