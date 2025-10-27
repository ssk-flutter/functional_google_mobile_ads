import 'dart:io';

import 'package:flutter/material.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const Issue6NativeBannerTestApp());
}

class Issue6NativeBannerTestApp extends StatelessWidget {
  const Issue6NativeBannerTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Issue #6 Native Banner Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Issue6NativeBannerTestPage(),
    );
  }
}

class Issue6NativeBannerTestPage extends StatefulWidget {
  const Issue6NativeBannerTestPage({super.key});

  @override
  State<Issue6NativeBannerTestPage> createState() =>
      _Issue6NativeBannerTestPageState();
}

class _Issue6NativeBannerTestPageState
    extends State<Issue6NativeBannerTestPage> {
  TemplateType _selectedTemplateType = TemplateType.medium;
  double? _customWidth;
  double? _customHeight;
  bool _useCustomSize = false;

  final List<TemplateType> _templateTypes = [
    TemplateType.small,
    TemplateType.medium,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue #6: Native Banner Test'),
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
                      'Template: ${_selectedTemplateType.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Custom Size: ${_useCustomSize ? "${_customWidth ?? 'auto'}x${_customHeight ?? 'auto'}" : "auto"}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: _templateTypes.map((templateType) {
                        final isSelected = _selectedTemplateType == templateType;
                        return ChoiceChip(
                          label: Text(
                            templateType.name,
                            style: const TextStyle(fontSize: 12),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTemplateType = templateType;
                              });
                            }
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Use Custom Size', style: TextStyle(fontSize: 12)),
                      value: _useCustomSize,
                      onChanged: (value) {
                        setState(() {
                          _useCustomSize = value;
                          if (value) {
                            _customWidth = 350;
                            _customHeight = 200;
                          }
                        });
                      },
                      dense: true,
                    ),
                  ],
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
                          'Test Case 1: Native Ad in Expanded Widget',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        color: Colors.blue[50],
                        padding: const EdgeInsets.all(16),
                        height: 280,
                        child: Column(
                          children: [
                            Expanded(
                              child: FunctionalNativeBannerAd(
                                adUnitId: TestAdId.nativeAdvanced,
                                templateType: _selectedTemplateType,
                                width: _useCustomSize ? _customWidth : null,
                                height: _useCustomSize ? _customHeight : null,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Native ad in Expanded widget',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 11, color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Test Case 2: Native Ad in Row with Expanded',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        color: Colors.green[50],
                        padding: const EdgeInsets.all(16),
                        height: 200,
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Text(
                                  'Fixed\n80px',
                                  style: TextStyle(fontSize: 11),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: FunctionalNativeBannerAd(
                                adUnitId: TestAdId.nativeAdvanced,
                                templateType: _selectedTemplateType,
                                width: _useCustomSize ? _customWidth : null,
                                height: _useCustomSize ? _customHeight : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Test Case 3: Native Ad with Fixed Size',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      Container(
                        color: Colors.orange[50],
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: FunctionalNativeBannerAd(
                            adUnitId: TestAdId.nativeAdvanced,
                            templateType: _selectedTemplateType,
                            width: _useCustomSize ? _customWidth : null,
                            height: _useCustomSize ? _customHeight : null,
                          ),
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
}

class TestAdId {
  static final String nativeAdvanced = androidOrElse(
    'ca-app-pub-3940256099942544/2247696110',
    'ca-app-pub-3940256099942544/3986624511',
  );
}

String androidOrElse(String android, String orElse) =>
    Platform.isAndroid ? android : orElse;
