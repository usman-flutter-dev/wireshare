import 'dart:io';
import 'package:ftp_server/ftp_server.dart';
import 'package:ftp_server/server_type.dart';
import 'package:ftp_server/file_operations/physical_file_operations.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../models/server_config.dart';

class FtpService extends GetxService {
  FtpServer? _ftpServer;
  final RxList<String> activityLog = <String>[].obs;

  void _log(String message) {
    final now = DateTime.now();
    final time =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';
    activityLog.insert(0, '[$time] $message');
    if (activityLog.length > 100) activityLog.removeLast();
  }

  Future<String?> getLocalIp() async {
    try {
      final ip = await NetworkInfo().getWifiIP();
      return (ip != null && ip.isNotEmpty) ? ip : null;
    } catch (_) {
      return null;
    }
  }

  Future<int> getAvailablePort() async {
    for (int port = 2121; port <= 2200; port++) {
      try {
        final sock = await ServerSocket.bind(
          InternetAddress.anyIPv4,
          port,
          shared: false,
        );
        await sock.close();
        return port; // ✅ first free port
      } on SocketException {
        continue; // port busy, try next
      }
    }
    throw Exception('No available port found between 2121–2200');
  }

  String getSharedPath() {
    if (Platform.isAndroid) return '/storage/emulated/0';
    if (Platform.isWindows) {
      return '${Platform.environment['USERPROFILE']}\\Documents\\WireShare';
    }
    return '/';
  }

  Future<void> startServer(ServerConfig config, String sharedPath) async {
    await stopServer();

    // Ensure folder exists
    final dir = Directory(sharedPath);
    if (!await dir.exists()) await dir.create(recursive: true);

    // Check port is free
    try {
      final sock = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        config.port,
        shared: false,
      );
      await sock.close();
    } on SocketException {
      throw Exception(
        'Port ${config.port} is already in use. Change it in Settings.',
      );
    }

    _ftpServer = FtpServer(
      config.port,
      username: config.username,
      password: config.password,
      fileOperations: PhysicalFileOperations(sharedPath),
      serverType: config.readOnly
          ? ServerType.readOnly
          : ServerType.readAndWrite,
    );

    await _ftpServer!.startInBackground();
    _log('Server started → port ${config.port} | path: $sharedPath');
  }

  Future<void> stopServer() async {
    if (_ftpServer != null) {
      await _ftpServer!.stop();
      _ftpServer = null;
      _log('Server stopped');
    }
  }

  void clearLog() => activityLog.clear();
}
