import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wireless_transfer/core/enums.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';

class ToggleFab extends StatelessWidget {
  final HomeViewModel vm;
  const ToggleFab(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isRunning = vm.status.value == ServerStatus.running;
      final isStarting = vm.status.value == ServerStatus.starting;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: isStarting ? null : vm.toggleServer,
            style: ElevatedButton.styleFrom(
              backgroundColor: isRunning
                  ? const Color(0xFF1F0F0F)
                  : const Color(0xFF1E3A5F),
              foregroundColor: isRunning
                  ? const Color(0xFFEF4444)
                  : Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isRunning
                      ? const Color(0xFF7F1D1D)
                      : const Color(0xFF3B82F6),
                  width: 1,
                ),
              ),
            ),
            child: isStarting
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Starting...',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isRunning
                            ? Icons.stop_rounded
                            : Icons.play_arrow_rounded,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isRunning ? 'Stop Server' : 'Start Server',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
