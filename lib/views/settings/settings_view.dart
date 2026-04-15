import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/enums.dart';
import '../../models/server_config.dart';
import '../../viewmodels/home_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final vm = Get.find<HomeViewModel>();

  late TextEditingController _portCtrl;
  late TextEditingController _userCtrl;
  late TextEditingController _passCtrl;
  late bool _readOnly;
  bool _obscurePass = true;

  bool get _serverRunning => vm.status.value == ServerStatus.running;

  @override
  void initState() {
    super.initState();
    final cfg = vm.config.value;
    _portCtrl = TextEditingController(text: cfg.port.toString());
    _userCtrl = TextEditingController(text: cfg.username);
    _passCtrl = TextEditingController(text: cfg.password);
    _readOnly = cfg.readOnly;
  }

  @override
  void dispose() {
    _portCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final port = int.tryParse(_portCtrl.text.trim());
    if (port == null || port < 1024 || port > 65535) {
      _showError('Port must be between 1024 and 65535');
      return;
    }
    final username = _userCtrl.text.trim();
    final password = _passCtrl.text.trim();
    if (username.isEmpty || password.isEmpty) {
      _showError('Username and password cannot be empty');
      return;
    }

    await vm.saveConfig(
      ServerConfig(
        port: port,
        username: username,
        password: password,
        readOnly: _readOnly,
      ),
    );

    Get.back();
    Get.snackbar(
      'Saved',
      'Settings updated${_serverRunning ? ' — restart server to apply' : ''}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1A1A2E),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void _showError(String msg) {
    Get.snackbar(
      'Invalid Input',
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1F0F0F),
      colorText: const Color(0xFFEF4444),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060610),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060610),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFF1C1C30)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (_serverRunning) ...[_WarningBanner(), const SizedBox(height: 20)],

          // ── Connection ──────────────────────────────────────
          _SectionLabel('CONNECTION'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _FieldRow(
                label: 'Port',
                hint: '21',
                controller: _portCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                helper: 'Default: 21  |  Range: 1024–65535',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Authentication ───────────────────────────────────
          _SectionLabel('AUTHENTICATION'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _FieldRow(
                label: 'Username',
                hint: 'wireshare',
                controller: _userCtrl,
              ),
              const Divider(height: 1, color: Color(0xFF1C1C30)),
              _PasswordRow(
                controller: _passCtrl,
                obscure: _obscurePass,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ── Permissions ──────────────────────────────────────
          _SectionLabel('PERMISSIONS'),
          const SizedBox(height: 10),
          _SettingsCard(
            children: [
              _ToggleRow(
                label: 'Read-only mode',
                subtitle: 'Clients can browse but not upload or delete',
                value: _readOnly,
                onChanged: (v) => setState(() => _readOnly = v),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Save button
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A5F),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: Color(0xFF3B82F6), width: 1),
                ),
              ),
              child: const Text(
                'Save Settings',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Shared folder info
          _InfoTile(
            icon: Icons.folder_outlined,
            label: 'Shared folder',
            value: 'Download/WireShare',
          ),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ─────────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2D1B00),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.5),
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 16),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Server is running. Changes apply after restart.',
              style: TextStyle(color: Color(0xFFF59E0B), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF3B82F6),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1C1C30)),
      ),
      child: Column(children: children),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final String? helper;

  const _FieldRow({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
    this.helper,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'monospace',
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF374151)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          if (helper != null) ...[
            const SizedBox(height: 4),
            Text(
              helper!,
              style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _PasswordRow extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordRow({
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 15,
                  ),
                  decoration: const InputDecoration(
                    hintText: '••••••',
                    hintStyle: TextStyle(color: Color(0xFF374151)),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Icon(
                  obscure
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: const Color(0xFF4B5563),
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF3B82F6),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F0F1F),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1C1C30)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4B5563), size: 16),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
