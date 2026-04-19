import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_theme.dart';
import '../widgets/result_card.dart';
import '../widgets/section_header.dart';

class CameraScannerView extends StatefulWidget {
  const CameraScannerView({super.key});

  @override
  State<CameraScannerView> createState() => _CameraScannerViewState();
}

class _CameraScannerViewState extends State<CameraScannerView>
    with WidgetsBindingObserver {
  MobileScannerController? _controller;
  String? _scannedValue;
  BarcodeType? _scannedType;
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isScanning = true;
  bool _torchOn = false;
  bool _showResult = false;
  bool _controllerReady = false;
  bool _isControllerRunning = false;
  bool _isTransitioningCamera = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestPermission();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission || !_controllerReady) return;

    if (state == AppLifecycleState.resumed) {
      if (_isScanning) {
        _startScanner();
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      _stopScanner();
    }
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isGranted) {
      if (_controller == null) {
        _initController();
      }
      setState(() {
        _hasPermission = true;
        _permissionDenied = false;
      });
      await _startScanner();
    } else {
      setState(() {
        _hasPermission = false;
        _permissionDenied = true;
      });
    }
  }

  void _initController() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
    );
    setState(() => _controllerReady = true);
  }

  Future<void> _startScanner() async {
    if (!_controllerReady ||
        !_hasPermission ||
        !_isScanning ||
        _isTransitioningCamera ||
        _isControllerRunning) {
      return;
    }

    final controller = _controller;
    if (controller == null) return;

    _isTransitioningCamera = true;
    try {
      await controller.start();
      if (!mounted) return;
      setState(() {
        _isControllerRunning = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isControllerRunning = false;
      });
    } finally {
      _isTransitioningCamera = false;
    }
  }

  Future<void> _stopScanner() async {
    if (!_controllerReady || _isTransitioningCamera || !_isControllerRunning) {
      return;
    }

    final controller = _controller;
    if (controller == null) return;

    _isTransitioningCamera = true;
    try {
      await controller.stop();
    } catch (_) {
      // Keep scanner recoverable even if the platform camera reports a stop error.
    } finally {
      _isTransitioningCamera = false;
      if (!mounted) {
        _isControllerRunning = false;
        // ignore: control_flow_in_finally
        return;
      }
      setState(() {
        _isControllerRunning = false;
      });
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final barcode = barcodes.first;
    final value = barcode.rawValue;
    if (!_isScanning || value == null || value.isEmpty) return;

    _stopScanner();
    HapticFeedback.mediumImpact();

    setState(() {
      _scannedValue = value;
      _scannedType = barcode.type;
      _isScanning = false;
      _showResult = true;
    });
  }

  void _resetScan() {
    setState(() {
      _scannedValue = null;
      _scannedType = null;
      _isScanning = true;
      _showResult = false;
      _torchOn = false;
    });
    _startScanner();
  }

  Future<void> _toggleTorch() async {
    setState(() => _torchOn = !_torchOn);
    await _controller?.toggleTorch();
  }

  String _getTypeLabel(BarcodeType? type) {
    switch (type) {
      case BarcodeType.url:
        return 'URL';
      case BarcodeType.text:
        return 'Text';
      case BarcodeType.wifi:
        return 'Wi-Fi';
      case BarcodeType.email:
        return 'Email';
      case BarcodeType.phone:
        return 'Phone';
      case BarcodeType.sms:
        return 'SMS';
      case BarcodeType.contactInfo:
        return 'Contact';
      case BarcodeType.geo:
        return 'Location';
      default:
        return 'Data';
    }
  }

  IconData _getTypeIcon(BarcodeType? type) {
    switch (type) {
      case BarcodeType.url:
        return Icons.link_rounded;
      case BarcodeType.text:
        return Icons.text_snippet_rounded;
      case BarcodeType.wifi:
        return Icons.wifi_rounded;
      case BarcodeType.email:
        return Icons.email_rounded;
      case BarcodeType.phone:
        return Icons.phone_rounded;
      case BarcodeType.sms:
        return Icons.sms_rounded;
      case BarcodeType.contactInfo:
        return Icons.person_rounded;
      case BarcodeType.geo:
        return Icons.location_on_rounded;
      default:
        return Icons.data_object_rounded;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
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
              icon: Icons.qr_code_scanner_rounded,
              title: 'QR Code Scanner',
              subtitle: 'Professional live scanning with instant detection',
            ),
            const SizedBox(height: 18),
            if (_permissionDenied) _buildPermissionDenied(),
            if (_hasPermission && _controllerReady && !_showResult)
              _buildScannerView(),
            if (_hasPermission && _showResult && _scannedValue != null)
              _buildResultView(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.no_photography_rounded,
                size: 32,
                color: AppTheme.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Camera Access Required',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Please grant camera permission to scan QR codes. '
              'You can update this in your device settings.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await openAppSettings();
                  await _requestPermission();
                },
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: const Text('Open Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    final ctrl = _controller!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFDFEFF),
                Color(0xFFF2F6FB),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.divider),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140D2B4E),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Camera',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppTheme.primaryDark,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isControllerRunning
                              ? 'Camera is active and ready to read codes.'
                              : 'Reconnecting to camera feed...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(
                    icon: _isControllerRunning
                        ? Icons.videocam_rounded
                        : Icons.sync_rounded,
                    label: _isControllerRunning ? 'Ready' : 'Starting',
                    color: _isControllerRunning
                        ? AppTheme.success
                        : AppTheme.accent,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              AspectRatio(
                aspectRatio: 0.92,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: ctrl,
                        fit: BoxFit.cover,
                        onDetect: _onBarcodeDetected,
                      ),
                      CustomPaint(painter: _ScannerOverlayPainter()),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.42),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.center_focus_strong_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Center the QR code inside the frame',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _CameraButton(
                              icon: _torchOn
                                  ? Icons.flashlight_on_rounded
                                  : Icons.flashlight_off_rounded,
                              label: 'Torch',
                              onTap: _toggleTorch,
                              active: _torchOn,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Keep the device steady for faster and more reliable detection.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    final isUrl = _scannedType == BarcodeType.url ||
        (_scannedValue?.startsWith('http') ?? false);

    return Column(
      children: [
        ResultCard(
          icon: _getTypeIcon(_scannedType),
          typeLabel: _getTypeLabel(_scannedType),
          value: _scannedValue!,
          isUrl: isUrl,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _scannedValue!));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 8),
                          Text('Copied to clipboard'),
                        ],
                      ),
                      backgroundColor: AppTheme.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 16),
                label: const Text('Copy'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryDark,
                  side: const BorderSide(color: AppTheme.divider),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _resetScan,
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text('Scan Again'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CameraButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  const _CameraButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? AppTheme.accent.withValues(alpha: 0.88)
                : Colors.black.withValues(alpha: 0.36),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 28.0;
    const double margin = 48.0;

    const double left = margin;
    const double top = margin;
    final double right = size.width - margin;
    final double bottom = size.height - margin;

    canvas.drawPath(
      Path()
        ..moveTo(left, top + cornerLength)
        ..lineTo(left, top)
        ..lineTo(left + cornerLength, top),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(right - cornerLength, top)
        ..lineTo(right, top)
        ..lineTo(right, top + cornerLength),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(left, bottom - cornerLength)
        ..lineTo(left, bottom)
        ..lineTo(left + cornerLength, bottom),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(right - cornerLength, bottom)
        ..lineTo(right, bottom)
        ..lineTo(right, bottom - cornerLength),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
