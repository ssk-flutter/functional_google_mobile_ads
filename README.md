# functional_google_mobile_ads

Functional Google Mobile Ads

## Introduction

This project is a functional version of [google mobile ads](https://pub.dev/packages/google_mobile_ads),

## First of all, you have to follow mobile ads sdk(quick-start).

[from here](https://developers.google.com/admob/flutter/quick-start)

## import

```
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';
```

## One line functional Usage

#### FunctionalInterstitialAd

```
  await FunctionalInterstitialAd.loadAndShow(adUnitId: 'adUnitId');
```

#### FunctionalRewardedAd

```
  await FunctionalRewardedAd.loadAndShow(adUnitId: 'adUnitId');
```

#### FunctionalRewardedInterstitialAd

```
  await FunctionalRewardedInterstitialAd.loadAndShow(adUnitId: 'adUnitId');
```

#### FunctionalBannerAd

```
Column(
    children: [
        FunctionalBannerAd(adUnitId: 'adUnitId', adSize: AdSize.banner),
    ] 
)
```

## Advanced Usage
```dart
    final ad = FunctionalRewardedAd();
    try {
      await ad.load(adUnitId: 'adUnitId');
      final item = await ad.show();
      print('rewarded item: $item');
    } catch (error) {
      print(error);
    } finally {
      ad.dispose();
    }
```
