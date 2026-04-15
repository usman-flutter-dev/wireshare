import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';

class ActivityLog extends StatelessWidget {
  final HomeViewModel vm;
  const ActivityLog(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C1C30), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                const Icon(
                  Icons.terminal_rounded,
                  color: Color(0xFF3B82F6),
                  size: 14,
                ),
                const SizedBox(width: 6),
                const Text(
                  'ACTIVITY LOG',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => vm.activityLog.isNotEmpty
                      ? TextButton(
                          onPressed: vm.clearLog,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Clear',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF1C1C30)),
          Obx(() {
            if (vm.activityLog.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white.withValues(alpha: 0.1),
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No activity yet',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.2),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: vm.activityLog.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: Color(0xFF141424)),
              itemBuilder: (_, i) {
                final entry = vm.activityLog[i];
                final match = RegExp(
                  r'^\[(\d{2}:\d{2}:\d{2})\] (.+)$',
                ).firstMatch(entry);
                final time = match?.group(1) ?? '';
                final msg = match?.group(2) ?? entry;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF3B82F6),
                          fontSize: 11,
                          fontFamily: 'monospace',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          msg,
                          style: const TextStyle(
                            color: Color(0xFFD1D5DB),
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
