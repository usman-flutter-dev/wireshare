import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';

// ─── QR Card ─────────────────────────────────────────────────────────────────

class QrCard extends StatelessWidget {
  final HomeViewModel vm;
  const QrCard(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1C1C30), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.qr_code_2_rounded,
                color: Color(0xFF3B82F6),
                size: 14,
              ),
              const SizedBox(width: 6),
              const Text(
                'SCAN TO CONNECT',
                style: TextStyle(
                  color: Color(0xFF3B82F6),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: vm.ftpAddress,
              version: QrVersions.auto,
              size: 160,
              backgroundColor: Colors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: Color(0xFF0A0A1A),
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: Color(0xFF0A0A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
