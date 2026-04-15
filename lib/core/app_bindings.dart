// //
// //
// import 'package:get/get.dart';
// import '../services/ftp_service.dart';

// class AppBindings extends Bindings {
//   @override
//   void dependencies() {
//     Get.put<FtpService>(FtpService(), permanent: true);
//   }
// }

import 'package:get/get.dart';
import '../services/ftp_service.dart';
import '../services/permission_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<PermissionService>(PermissionService(), permanent: true);
    Get.put<FtpService>(FtpService(), permanent: true);
  }
}
