import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';

import '../data/koan_model.dart';
import '../data/koans_repository.dart';
import 'widgets/contributors_screen.dart';
import 'widgets/koan_card.dart';
import 'widgets/koan_fab.dart';

class ZenKoanScreen extends StatefulWidget {
  const ZenKoanScreen({super.key});

  @override
  State<ZenKoanScreen> createState() => _ZenKoanScreenState();
}

class _ZenKoanScreenState extends State<ZenKoanScreen>
    with SingleTickerProviderStateMixin {
  final KoansRepository _repository = KoansRepository();
  final ScreenshotController _screenshotController = ScreenshotController();

  KoanWithExplanation? _currentKoan;
  bool _isLoading = true;
  bool _showShakeMessage = true;
  bool _showCard = false;

  // Shake detection
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  DateTime _lastShakeTime = DateTime.now();
  double _lastX = 0, _lastY = 0, _lastZ = 0;
  DateTime _lastUpdate = DateTime.now();
  static const int _shakeThreshold = 1000;
  static const Duration _debounceDuration = Duration(milliseconds: 1500);

  @override
  void initState() {
    super.initState();
    _initRepository();
    _initShakeDetection();
  }

  Future<void> _initRepository() async {
    await _repository.load();
    _refreshKoan();
    setState(() => _isLoading = false);
  }

  void _initShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final now = DateTime.now();
      final diff = now.difference(_lastUpdate).inMilliseconds;
      if (diff > 100) {
        _lastUpdate = now;
        final speed =
            (event.x + event.y + event.z - _lastX - _lastY - _lastZ).abs() /
                diff *
                10000;

        if (speed > _shakeThreshold) {
          if (now.difference(_lastShakeTime) > _debounceDuration) {
            _lastShakeTime = now;
            _onShake();
          }
        }

        _lastX = event.x;
        _lastY = event.y;
        _lastZ = event.z;
      }
    });
  }

  void _onShake() {
    _refreshKoan();
    setState(() => _showShakeMessage = false);
  }

  void _refreshKoan() {
    setState(() {
      _showCard = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() {
        _currentKoan = _repository.getRandomKoan();
        _showCard = true;
      });
    });
  }

  Future<void> _shareKoan() async {
    if (_currentKoan == null) return;
    try {
      final image = await _screenshotController.capture();
      if (image == null) return;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/cybersecurity_zen_koan.png');
      await file.writeAsBytes(image);

      final box = context.findRenderObject() as RenderBox?;

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: 'CSZK: #${_currentKoan!.uniqueCode}',
        subject: 'Cybersecurity Zen Koan #${_currentKoan!.uniqueCode}',
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      debugPrint('Error sharing koan: $e');
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final brightness = Theme.of(ctx).brightness;
        final logoAsset = brightness == Brightness.dark
            ? 'assets/ktech_logo_dark.svg'
            : 'assets/ktech_logo_light.svg';

        return AlertDialog(
          title: Text(
            'Cybersecurity Zen Koan',
            style: TextStyle(color: Theme.of(ctx).colorScheme.primary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Version: 3.1',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(
                logoAsset,
                height: 48,
              ),
              const SizedBox(height: 8),
              Text(
                'Created by ktech Students',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(ctx).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                launchUrl(
                  Uri.parse(
                      'https://github.com/Kuwait-Technical-College/contribute_to_open_source'),
                  mode: LaunchMode.externalApplication,
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        );
      },
    );
  }

  void _showLookupDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Lookup Koan',
          style: TextStyle(color: Theme.of(ctx).colorScheme.primary),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: const InputDecoration(
            hintText: 'Enter koan code (e.g. 7H93FT)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final code = controller.text.trim().toUpperCase();
              if (code.isEmpty) return;

              final koan = _repository.getKoanByCode(code);
              Navigator.pop(ctx);

              if (koan != null) {
                setState(() {
                  _showCard = false;
                });
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (!mounted) return;
                  setState(() {
                    _currentKoan = koan;
                    _showCard = true;
                    _showShakeMessage = false;
                  });
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No koan found with code "$code"'),
                  ),
                );
              }
            },
            child: const Text('Find'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.1),
              Theme.of(context).scaffoldBackgroundColor,
              colorScheme.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Main content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        opacity: _showCard ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 500),
                        child: _currentKoan != null
                            ? Screenshot(
                                controller: _screenshotController,
                                child: KoanCard(koan: _currentKoan!),
                              )
                            : const SizedBox.shrink(),
                      ),
                      if (_showShakeMessage)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            'Shake your device for a new koan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // FAB
              if (!_showShakeMessage)
                Positioned(
                  right: 24,
                  bottom: 24,
                  child: KoanFab(
                    onShareClick: _shareKoan,
                    onAboutClick: _showAboutDialog,
                    onContributorsClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ContributorsScreen(),
                        ),
                      );
                    },
                    onLookupClick: _showLookupDialog,
                  ),
                ),
              // Debug refresh button
              if (kDebugMode)
                Positioned(
                  left: 24,
                  bottom: 24,
                  child: FloatingActionButton.small(
                    heroTag: 'debug_refresh',
                    onPressed: _onShake,
                    backgroundColor:
                        colorScheme.tertiary.withValues(alpha: 0.7),
                    foregroundColor: colorScheme.onTertiary,
                    child: const Icon(Icons.refresh),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
