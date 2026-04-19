import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/section_header.dart';
import 'scanner_screen_camera.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

  // mobile_scanner supports Android, iOS, macOS only
  static bool get _isCameraSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraSupported) {
      return const _UnsupportedPlatformView();
    }
    return const CameraScannerView();
  }
}

class _UnsupportedPlatformView extends StatelessWidget {
  const _UnsupportedPlatformView();

  String get _platformName {
    if (kIsWeb) return 'Web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
        return 'Windows';
      case TargetPlatform.linux:
        return 'Linux';
      case TargetPlatform.fuchsia:
        return 'Fuchsia';
      default:
        return 'this platform';
    }
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
              icon: Icons.qr_code_scanner_rounded,
              title: 'QR Code Scanner',
              subtitle: 'Point camera at any QR code to scan',
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        // FIX: withOpacity → withValues(alpha:)
                        color: AppTheme.accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_android_rounded,
                        size: 40,
                        color: AppTheme.accent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Mobile Device Required',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'QR Code scanning uses the device camera and is supported '
                      'on Android and iOS.\n\nCamera scanning is not available on '
                      '$_platformName. Please connect an Android device or launch '
                      'an emulator.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    _buildCommandHint(context),
                    const SizedBox(height: 20),
                    _buildSupportTable(context),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: AppTheme.success, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The Generate tab works fully on $_platformName!',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 13,
                              color: AppTheme.success,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandHint(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.terminal_rounded,
                  size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Run on Android device:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'flutter run -d <android-device-id>',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: AppTheme.accent,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTable(BuildContext context) {
    final rows = [
      ('Android', true, true),
      ('iOS', true, true),
      ('macOS', true, true),
      ('Windows', false, true),
      ('Web', false, true),
    ];

    return Table(
      border: TableBorder.all(color: AppTheme.divider, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: const BoxDecoration(color: AppTheme.primaryDark),
          children: ['Platform', 'Scan', 'Generate']
              .map(
                (h) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Text(
                    h,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        ...rows.map((r) {
          final isCurrent = r.$1 == _platformName;
          return TableRow(
            decoration: BoxDecoration(
              // FIX: withOpacity → withValues(alpha:)
              color: isCurrent
                  ? AppTheme.accent.withValues(alpha: 0.05)
                  : Colors.white,
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  isCurrent ? '${r.$1} ← you' : r.$1,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isCurrent ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              ...[r.$2, r.$3].map(
                (v) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Icon(
                    v ? Icons.check_rounded : Icons.close_rounded,
                    size: 16,
                    color: v ? AppTheme.success : AppTheme.error,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}