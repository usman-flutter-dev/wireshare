// ─── Error Banner ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F0F0F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF7F1D1D), width: 1),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Color(0xFFEF4444),
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
