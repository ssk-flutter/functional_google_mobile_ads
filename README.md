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

#### FunctionalNativeBannerAd

```
Column(
    children: [
        FunctionalNativeBannerAd(
            adUnitId: 'adUnitId',
            templateType: TemplateType.medium,
            height: 200,
        ),
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

## Native Banner Ad Customization

```dart
FunctionalNativeBannerAd(
  adUnitId: 'your-native-ad-unit-id',
  templateType: TemplateType.small, // or TemplateType.medium
  width: 320,
  height: 150,
  nativeAdListener: NativeAdListener(
    onAdLoaded: (ad) => print('Native ad loaded'),
    onAdFailedToLoad: (ad, error) => print('Native ad failed to load: $error'),
    onAdClicked: (ad) => print('Native ad clicked'),
  ),
  nativeTemplateStyle: NativeTemplateStyle(
    templateType: TemplateType.small,
    mainBackgroundColor: Colors.white,
    cornerRadius: 8.0,
  ),
)
```
