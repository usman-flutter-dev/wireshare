// ─── FTP Address Card ────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';
import 'package:wireless_transfer/views/home/widgets/copy_btn.dart';

class AddressCard extends StatelessWidget {
  final HomeViewModel vm;
  const AddressCard(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1E3A5F), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.link_rounded,
                color: Color(0xFF3B82F6),
                size: 14,
              ),
              const SizedBox(width: 6),
              const Text(
                'FTP ADDRESS',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Text(
                'No login required',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  vm.ftpAddress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'monospace',
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              CopyButton(vm.ftpAddress),
            ],
          ),
          const SizedBox(height: 12),
          // Path info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.folder_outlined,
                  color: Color(0xFF6B7280),
                  size: 13,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Download/WireShare',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
