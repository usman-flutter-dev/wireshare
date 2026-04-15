import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wireless_transfer/core/enums.dart';
import 'package:wireless_transfer/viewmodels/home_viewmodel.dart';

class ServerCard extends StatelessWidget {
  final HomeViewModel vm;
  const ServerCard(this.vm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final statusData = {
        ServerStatus.stopped: (
          color: const Color(0xFF6B7280),
          label: 'Server Offline',
          sub: 'Tap Start to begin sharing files',
          icon: Icons.cloud_off_rounded,
        ),
        ServerStatus.starting: (
          color: const Color(0xFFF59E0B),
          label: 'Starting Up',
          sub: 'Initializing FTP server...',
          icon: Icons.hourglass_top_rounded,
        ),
        ServerStatus.running: (
          color: const Color(0xFF10B981),
          label: 'Server Active',
          sub: 'Accepting connections',
          icon: Icons.cloud_done_rounded,
        ),
        ServerStatus.error: (
          color: const Color(0xFFEF4444),
          label: 'Server Error',
          sub: 'See details below',
          icon: Icons.cloud_off_rounded,
        ),
      };

      final d = statusData[vm.status.value]!;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1F),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: d.color.withValues(alpha: 0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: d.color.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            _StatusOrb(
              color: d.color,
              isAnimating: vm.status.value == ServerStatus.running,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.label,
                    style: TextStyle(
                      color: d.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    d.sub,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(d.icon, color: d.color.withValues(alpha: 0.6), size: 28),
          ],
        ),
      );
    });
  }
}

class _StatusOrb extends StatefulWidget {
  final Color color;
  final bool isAnimating;
  const _StatusOrb({required this.color, required this.isAnimating});

  @override
  State<_StatusOrb> createState() => _StatusOrbState();
}

class _StatusOrbState extends State<_StatusOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulse = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAnimating) {
      return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      );
    }
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, _) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: _pulse.value * 0.25),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
