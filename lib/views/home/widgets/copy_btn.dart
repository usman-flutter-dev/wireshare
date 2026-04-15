import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyButton extends StatefulWidget {
  final String text;
  const CopyButton(this.text, {super.key});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: IconButton(
        onPressed: _copy,
        icon: Icon(
          _copied ? Icons.check_rounded : Icons.copy_rounded,
          color: _copied ? Colors.greenAccent : const Color(0xFF6B7280),
          size: 20,
        ),
        style: IconButton.styleFrom(
          backgroundColor: _copied
              ? Colors.greenAccent.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
