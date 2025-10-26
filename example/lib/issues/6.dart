import 'dart:io';

import 'package:flutter/material.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const Issue6TestApp());
}

class Issue6TestApp extends StatelessWidget {
  const Issue6TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue #6 Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Issue6TestPage(),
    );
  }
}

class Issue6TestPage extends StatefulWidget {
  const Issue6TestPage({super.key});

  @override
  State<Issue6TestPage> createState() => _Issue6TestPageState();
}

class _Issue6TestPageState extends State<Issue6TestPage> {
  AdSize _selectedAdSize = AdSize.banner;
  final List<AdSize> _adSizes = [
    AdSize.banner,
    AdSize.fluid,
    AdSize.mediumRectangle,
    AdSize.largeBanner,
    AdSize.fullBanner,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue #6: AdSize in OrientationBuilder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Orientation: ${orientation.name}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Selected AdSize: ${_getAdSizeName(_selectedAdSize)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'AdSize dimensions: ${_selectedAdSize.width}x${_selectedAdSize.height}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: _adSizes.map((adSize) {
                    final isSelected = _selectedAdSize == adSize;
                    return ChoiceChip(
                      label: Text(_getAdSizeName(adSize), style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedAdSize = adSize;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Test Case 1: Ad in Expanded Widget',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        color: Colors.blue[50],
                        padding: const EdgeInsets.all(16),
                        height: 200,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue, width: 2),
                              ),
                              child: FunctionalBannerAd(
                                bannerAdUnitId: TestAdId.banner,
                                adSize: _selectedAdSize,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Expected: Ad should respect parent width\nActual: Ad uses fixed AdSize dimensions',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Test Case 2: Ad in Row with Expanded',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        color: Colors.green[50],
                        padding: const EdgeInsets.all(16),
                        height: 150,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              color: Colors.grey[300],
                              child: const Center(child: Text('Fixed\n80px', style: TextStyle(fontSize: 11))),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green, width: 2),
                                ),
                                child: FunctionalBannerAd(
                                  bannerAdUnitId: TestAdId.banner,
                                  adSize: _selectedAdSize,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getAdSizeName(AdSize adSize) {
    if (adSize == AdSize.banner) return 'banner';
    if (adSize == AdSize.fluid) return 'fluid';
    if (adSize == AdSize.mediumRectangle) return 'mediumRectangle';
    if (adSize == AdSize.largeBanner) return 'largeBanner';
    if (adSize == AdSize.fullBanner) return 'fullBanner';
    return 'unknown';
  }
}

class TestAdId {
  static final String banner = androidOrElse(
    'ca-app-pub-3940256099942544/6300978111',
    'ca-app-pub-3940256099942544/2934735716',
  );
}

String androidOrElse(String android, String orElse) =>
    Platform.isAndroid ? android : orElse;
