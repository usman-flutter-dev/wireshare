// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../core/constants.dart';
// import '../core/enums.dart';
// import '../models/server_config.dart';
// import '../services/ftp_service.dart';

// class HomeViewModel extends GetxController {
//   final _ftp = Get.find<FtpService>();

//   final Rx<ServerStatus> status = ServerStatus.stopped.obs;
//   final RxString localIp = ''.obs;
//   final RxString errorMessage = ''.obs;
//   final Rx<ServerConfig> config = const ServerConfig().obs;

//   String get ftpAddress => 'ftp://${localIp.value}:${config.value.port}';

//   @override
//   void onInit() {
//     super.onInit();
//     _loadConfig();
//     _loadIp();
//   }

//   Future<void> _loadIp() async {
//     final ip = await _ftp.getLocalIp();
//     localIp.value = ip ?? 'Not connected to WiFi';
//   }

//   Future<void> _loadConfig() async {
//     final prefs = await SharedPreferences.getInstance();
//     config.value = ServerConfig(
//       port: prefs.getInt(AppConstants.prefPort) ?? AppConstants.defaultPort,
//       username:
//           prefs.getString(AppConstants.prefUsername) ??
//           AppConstants.defaultUsername,
//       password:
//           prefs.getString(AppConstants.prefPassword) ??
//           AppConstants.defaultPassword,
//       readOnly: prefs.getBool(AppConstants.prefReadOnly) ?? false,
//     );
//   }

//   Future<void> saveConfig(ServerConfig newConfig) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt(AppConstants.prefPort, newConfig.port);
//     await prefs.setString(AppConstants.prefUsername, newConfig.username);
//     await prefs.setString(AppConstants.prefPassword, newConfig.password);
//     await prefs.setBool(AppConstants.prefReadOnly, newConfig.readOnly);
//     config.value = newConfig;
//   }

//   Future<void> toggleServer() async {
//     if (status.value == ServerStatus.running) {
//       await _stopServer();
//     } else {
//       await _startServer();
//     }
//   }

//   Future<void> _startServer() async {
//     status.value = ServerStatus.starting;
//     errorMessage.value = '';
//     try {
//       await _loadIp();
//       if (localIp.value == 'Not connected to WiFi') {
//         errorMessage.value = 'Connect to WiFi first';
//         status.value = ServerStatus.error;
//         return;
//       }
//       final path = _ftp.getSharedPath();
//       await _ftp.startServer(config.value, path);
//       status.value = ServerStatus.running;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       status.value = ServerStatus.error;
//     }
//   }

//   Future<void> _stopServer() async {
//     await _ftp.stopServer();
//     status.value = ServerStatus.stopped;
//   }

//   @override
//   void onClose() {
//     _ftp.stopServer();
//     super.onClose();
//   }
// }

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../models/server_config.dart';
import '../services/ftp_service.dart';
import '../services/permission_service.dart';
import '../services/foreground_service.dart';

class HomeViewModel extends GetxController with WidgetsBindingObserver {
  final _ftp = Get.find<FtpService>();
  final _permissions = Get.find<PermissionService>();

  final Rx<ServerStatus> status = ServerStatus.stopped.obs;
  final RxString localIp = ''.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ServerConfig> config = const ServerConfig().obs;

  RxList<String> get activityLog => _ftp.activityLog;

  String get ftpAddress => 'ftp://${localIp.value}:${config.value.port}';
  bool get isWifiConnected => localIp.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _clearOldPort(); // ✅ add this
    WidgetsBinding.instance.addObserver(this);
    _loadConfig();
    _loadIp();
    if (Platform.isAndroid) {
      ForegroundServiceManager.requestBatteryExemption();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopServer();
    super.onClose();
  }

  // App lifecycle — only stop if foreground service is NOT running
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Foreground service keeps server alive in background.
    // No action needed here — service handles it.
  }

  Future<void> _loadIp() async {
    final ip = await _ftp.getLocalIp();
    localIp.value = ip ?? '';
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    config.value = ServerConfig(
      port: prefs.getInt(AppConstants.prefPort) ?? AppConstants.defaultPort,
      username:
          prefs.getString(AppConstants.prefUsername) ??
          AppConstants.defaultUsername,
      password:
          prefs.getString(AppConstants.prefPassword) ??
          AppConstants.defaultPassword,
      readOnly: prefs.getBool(AppConstants.prefReadOnly) ?? false,
    );
  }

  Future<void> saveConfig(ServerConfig newConfig) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefPort, newConfig.port);
    await prefs.setString(AppConstants.prefUsername, newConfig.username);
    await prefs.setString(AppConstants.prefPassword, newConfig.password);
    await prefs.setBool(AppConstants.prefReadOnly, newConfig.readOnly);
    config.value = newConfig;
  }

  Future<void> toggleServer() async {
    if (status.value == ServerStatus.running) {
      await _stopServer();
    } else {
      await _startServer();
    }
  }

  Future<void> _startServer() async {
    status.value = ServerStatus.starting;
    errorMessage.value = '';

    // 1. Storage permission (Android only)
    if (Platform.isAndroid) {
      final granted = await _permissions.requestStoragePermission();
      if (!granted) {
        errorMessage.value =
            'Storage permission denied. Grant it in App Settings.';
        status.value = ServerStatus.error;
        return;
      }
    }

    // 2. WiFi check
    await _loadIp();
    if (!isWifiConnected) {
      errorMessage.value = 'Not connected to WiFi.';
      status.value = ServerStatus.error;
      return;
    }

    // 3. Start FTP server with auto port
    try {
      final path = _ftp.getSharedPath();
      final availablePort = await _ftp.getAvailablePort(); // ✅ auto pick
      final autoConfig = config.value.copyWith(
        port: availablePort,
      ); // ✅ update port
      config.value = autoConfig; // ✅ reflect in UI address
      await _ftp.startServer(autoConfig, path);
    } on Exception catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      status.value = ServerStatus.error;
      return;
    }

    // 4. Start foreground service (Android keeps process alive)
    if (Platform.isAndroid) {
      await ForegroundServiceManager.start(
        ip: localIp.value,
        port: config.value.port, // ✅ now has the auto port
      );
    }

    status.value = ServerStatus.running;
  }

  Future<void> _stopServer() async {
    await _ftp.stopServer();
    if (Platform.isAndroid) await ForegroundServiceManager.stop();
    status.value = ServerStatus.stopped;
  }

  void clearLog() => _ftp.clearLog();

  Future<void> _clearOldPort() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getInt(AppConstants.prefPort) ?? 0;
    if (saved == 21) {
      await prefs.setInt(AppConstants.prefPort, 2121);
    }
  }
}
