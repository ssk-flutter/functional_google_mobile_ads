import 'package:flutter/material.dart';

import 'package:selector/selector.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _rewarded = FunctionalRewardedAd();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _rewarded.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  await FunctionalInterstitialAd.get(
                      adUnitId: TestAdId.interstitial);

                  print('interstitial ok');
                },
                child: const Text('InterstitialAd')),
            ElevatedButton(
                onPressed: () async {
                  final item = await FunctionalRewardedAd.get(
                      adUnitId: TestAdId.rewarded);

                  print('item is ${item.amount}');
                  print('item is ${item.type}');
                },
                child: const Text('RewardedAd')),
            ElevatedButton(
                onPressed: () async {
                  final item = await FunctionalRewardedInterstitialAd.get(
                      adUnitId: TestAdId.rewardedInterstitial);

                  print('item is ${item.amount}');
                  print('item is ${item.type}');
                },
                child: const Text('RewardedInterstitialAd')),
            const Spacer(),
            FunctionalBannerAd(
              bannerAdUnitId: TestAdId.banner,
              adSize: AdSize.banner,
            ),
          ],
        ),
      ),
    );
  }
}

class TestAdId {
  static final String appOpening = androidOrElse(
    'ca-app-pub-3940256099942544/3419835294',
    'ca-app-pub-3940256099942544/5662855259',
  );
  static final String banner = androidOrElse(
    'ca-app-pub-3940256099942544/6300978111',
    'ca-app-pub-3940256099942544/2934735716',
  );
  static final String interstitial = androidOrElse(
    'ca-app-pub-3940256099942544/1033173712',
    'ca-app-pub-3940256099942544/4411468910',
  );
  static final String interstitialVideo = androidOrElse(
    'ca-app-pub-3940256099942544/8691691433',
    'ca-app-pub-3940256099942544/5135589807',
  );
  static final String rewarded = androidOrElse(
    'ca-app-pub-3940256099942544/5224354917',
    'ca-app-pub-3940256099942544/1712485313',
  );
  static final String rewardedInterstitial = androidOrElse(
    'ca-app-pub-3940256099942544/5354046379',
    'ca-app-pub-3940256099942544/6978759866',
  );
  static final String nativeAdvanced = androidOrElse(
    'ca-app-pub-3940256099942544/2247696110',
    'ca-app-pub-3940256099942544/3986624511',
  );
  static final String nativeAdvancedVideo = androidOrElse(
    'ca-app-pub-3940256099942544/1044960115',
    'ca-app-pub-3940256099942544/2521693316',
  );
}
