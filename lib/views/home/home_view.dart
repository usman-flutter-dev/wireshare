import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wireless_transfer/views/home/widgets/activity_log.dart';
import 'package:wireless_transfer/views/home/widgets/error_banner.dart';
import 'package:wireless_transfer/views/home/widgets/ftp_address_card.dart';
import 'package:wireless_transfer/views/home/widgets/qr_card.dart';
import 'package:wireless_transfer/views/home/widgets/server_card.dart';
import 'package:wireless_transfer/views/home/widgets/toggle_fab.dart';
import 'package:wireless_transfer/views/home/widgets/top_bar.dart';
import '../../core/enums.dart';
import '../../viewmodels/home_viewmodel.dart';

class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060610),
      body: SafeArea(
        child: Column(
          children: [
            TopBar(controller),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    ServerCard(controller),
                    const SizedBox(height: 16),
                    Obx(() {
                      if (controller.status.value != ServerStatus.running) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          AddressCard(controller),
                          const SizedBox(height: 16),
                          QrCard(controller),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    Obx(() {
                      if (controller.errorMessage.value.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          ErrorBanner(controller.errorMessage.value),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                    ActivityLog(controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: ToggleFab(controller),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
