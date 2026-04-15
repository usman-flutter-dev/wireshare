// import 'package:get/get.dart';
// import '../views/splash/splash_view.dart';
// import '../views/home/home_view.dart';
// import '../viewmodels/home_viewmodel.dart';

// abstract class Routes {
//   static const splash = '/';
//   static const home = '/home';
// }

// class AppPages {
//   static const initial = Routes.splash;

//   static final routes = [
//     GetPage(name: Routes.splash, page: () => const SplashView()),
//     GetPage(
//       name: Routes.home,
//       page: () => const HomeView(),
//       binding: BindingsBuilder(() {
//         Get.lazyPut(() => HomeViewModel());
//       }),
//     ),
//   ];
// }

import 'package:get/get.dart';
import '../views/splash/splash_view.dart';
import '../views/home/home_view.dart';
import '../views/settings/settings_view.dart';
import '../viewmodels/home_viewmodel.dart';

abstract class Routes {
  static const splash = '/';
  static const home = '/home';
  static const settings = '/settings';
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(name: Routes.splash, page: () => const SplashView()),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeViewModel());
      }),
    ),
    GetPage(name: Routes.settings, page: () => const SettingsView()),
  ];
}
