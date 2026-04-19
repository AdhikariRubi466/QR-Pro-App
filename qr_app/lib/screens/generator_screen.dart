import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';

class GeneratorScreen extends StatefulWidget {
  const GeneratorScreen({super.key});

  @override
  State<GeneratorScreen> createState() => _GeneratorScreenState();
}

class _GeneratorScreenState extends State<GeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _qrData;
  String? _errorText;
  bool _hasGenerated = false;

  void _generateQR() {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        _errorText = 'Please enter text or a URL to generate a QR code.';
        _qrData = null;
        _hasGenerated = false;
      });
      return;
    }
    setState(() {
      _errorText = null;
      _qrData = input;
      _hasGenerated = true;
    });
    FocusScope.of(context).unfocus();
  }

  void _clearAll() {
    _controller.clear();
    setState(() {
      _qrData = null;
      _errorText = null;
      _hasGenerated = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(
              icon: Icons.qr_code_rounded,
              title: 'QR Code Generator',
              subtitle: 'Enter any text or URL to create a QR code',
            ),
            const SizedBox(height: 18),
            // Input card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.edit_rounded,
                            size: 16, color: AppTheme.textSecondary),
                        const SizedBox(width: 8),
                        Text(
                          'Enter Content',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      maxLines: 3,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText:
                            'e.g. https://example.com or any text...',
                        errorText: _errorText,
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: _clearAll,
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  size: 18,
                                  color: AppTheme.textSecondary,
                                ),
                              )
                            : null,
                      ),
                      // FIX: simplified onChanged — single setState always rebuilds
                      onChanged: (_) => setState(() {
                        if (_errorText != null) _errorText = null;
                      }),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _generateQR,
                        icon:
                            const Icon(Icons.auto_awesome_rounded, size: 18),
                        label: const Text('Generate QR Code'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_hasGenerated && _qrData != null) ...[
              const SizedBox(height: 20),
              _buildQRResult(),
            ],
            const SizedBox(height: 20),
            _buildTipsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildQRResult() {
    return AnimatedOpacity(
      opacity: _hasGenerated ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 350),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      // FIX: withOpacity → withValues(alpha:)
                      color: AppTheme.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 16,
                      color: AppTheme.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'QR Code Generated',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 15,
                          color: AppTheme.success,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: QrImageView(
                  data: _qrData!,
                  version: QrVersions.auto,
                  size: 200,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppTheme.primaryDark,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppTheme.primaryDark,
                  ),
                  errorCorrectionLevel: QrErrorCorrectLevel.M,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.text_snippet_rounded,
                        size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _qrData!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              fontFamily: 'monospace',
                              fontSize: 12,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              OutlinedButton.icon(
                onPressed: _clearAll,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Generate Another'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryDark,
                  side: const BorderSide(color: AppTheme.divider),
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    size: 16, color: AppTheme.accent),
                const SizedBox(width: 8),
                Text(
                  'Supported Content Types',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 13,
                        color: AppTheme.accent,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTip(
                Icons.link_rounded, 'URLs & Websites', 'https://example.com'),
            _buildTip(
                Icons.text_fields_rounded, 'Plain Text', 'Any text content'),
            _buildTip(
                Icons.email_rounded, 'Email Address', 'user@example.com'),
            _buildTip(
                Icons.phone_rounded, 'Phone Numbers', '+1 234 567 8900'),
            _buildTip(Icons.wifi_rounded, 'Wi-Fi Credentials',
                'WIFI:S:MyNetwork;...'),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String label, String example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 15, color: AppTheme.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                Text(
                  example,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
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