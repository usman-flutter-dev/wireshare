import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'core/app_bindings.dart';
import 'core/app_pages.dart';
import 'services/foreground_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ForegroundServiceManager.init(); // must be before runApp
  runZonedGuarded(
    () {
      runApp(const MyApp());
    },
    (error, stack) {
      if (error.toString().contains('Connection reset by peer')) {
        // ignore this specific error
        return;
      }
      // print(error);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // WithForegroundTask ensures the foreground task port
    // is correctly torn down when the widget tree is removed.
    return WithForegroundTask(
      child: GetMaterialApp(
        title: 'WireShare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
        ),
        initialBinding: AppBindings(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
