//
//
import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class ForegroundServiceManager {
  ForegroundServiceManager._();

  static void init() {
    if (!Platform.isAndroid) return;

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'wireshare_ftp',
        channelName: 'WireShare FTP Server',
        channelDescription: 'Keeps the FTP server running in background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.nothing(),
        autoRunOnBoot: false,
      ),
    );
  }

  static Future<void> start({required String ip, required int port}) async {
    if (!Platform.isAndroid) return;

    await FlutterForegroundTask.startService(
      serviceId: 1001,
      notificationTitle: 'WireShare Active',
      notificationText: 'ftp://$ip:$port — tap to return',
    );
  }

  static Future<void> update({required String ip, required int port}) async {
    if (!Platform.isAndroid) return;

    await FlutterForegroundTask.updateService(
      notificationTitle: 'WireShare Active',
      notificationText: 'ftp://$ip:$port — tap to return',
    );
  }

  static Future<void> stop() async {
    if (!Platform.isAndroid) return;
    await FlutterForegroundTask.stopService();
  }

  /// Request battery optimization exemption so Android
  /// doesn't kill the foreground service aggressively.
  static Future<void> requestBatteryExemption() async {
    if (!Platform.isAndroid) return;
    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }
  }
}
