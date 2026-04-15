import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wireless_transfer/core/app_pages.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';

class TopBar extends StatelessWidget {
  final HomeViewModel vm;
  const TopBar(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1C1C30), width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.blueAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.blueAccent.withValues(alpha: 0.4),
              ),
            ),
            child: const Icon(
              Icons.wifi_tethering_rounded,
              color: Colors.blueAccent,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'WireShare',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          // Isolated Obx — reads .value directly so GetX tracks it
          Obx(() {
            final ip = vm.localIp.value;
            final connected = ip.isNotEmpty;
            return Row(
              children: [
                Icon(
                  connected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                  color: connected ? Colors.greenAccent : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  connected ? ip : 'No WiFi',
                  style: TextStyle(
                    color: connected ? Colors.greenAccent : Colors.red,
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            );
          }),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: Color(0xFF6B7280),
              size: 20,
            ),
            onPressed: () => Get.toNamed(Routes.settings),
            style: IconButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
