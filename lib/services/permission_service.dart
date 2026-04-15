import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<bool> requestStoragePermission() async {
    if (!Platform.isAndroid) return true;

    final sdk = (await DeviceInfoPlugin().androidInfo).version.sdkInt;

    if (sdk >= 30) {
      // Already granted — go
      if (await Permission.manageExternalStorage.isGranted) return true;

      // Show explanation then send to settings
      await Get.dialog(
        AlertDialog(
          title: const Text('Storage Permission Required'),
          content: const Text(
            'WireShare needs "All Files Access" to share your phone storage over FTP.\n\nTap OK → enable "Allow access to all files" on the next screen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      await openAppSettings();

      // Wait for user to come back and re-check
      await Future.delayed(const Duration(seconds: 1));
      return await Permission.manageExternalStorage.isGranted;
    } else {
      return (await Permission.storage.request()).isGranted;
    }
  }
}
