# functional_google_mobile_ads

Functional Google Mobile Ads

## Introduction

This project is a functional version of the [google mobile ads](https://pub.dev/packages/google_mobile_ads),

## First of all, you have to follow mobile ads sdk(quick-start).
[from here](https://developers.google.com/admob/flutter/quick-start)

### import
```
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';
```

## One line functional Usage

#### FunctionalAdmob.interstitial

```
  await FunctionalAdmob.interstitial(adUnitId: 'adUnitId');
```

#### FunctionalAdmob.reward
```
  final rewarded = FunctionalMobileAdsRewarded();
  await rewarded.load(adUnitId: 'adUnitId');
  final item = await rewarded.show();
```

#### FunctionalAdmob.banner (for your convenience)
```
import 'package:functional_admob_flutter/functional_admob.dart';
```

```
Column(
    children: [
        FunctionalAdmob.banner(adUnitId: 'adUnitId', AdmobBannerSize.BANNER),
    ] 
)
```

## Detailed Functional Usage

#### FunctionalAdmobInterstitial
```
import 'package:functional_admob_flutter/functional_admob_interstitial.dart';
```

```
  Future _demoFunctionalInterstitial() async {
    final interstitialAd = FunctionalAdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
    );

    if (!await interstitialAd.load()) throw 'Failed to load interstitial Ad';

    await interstitialAd.show();
  }
```

#### FunctionalAdmobReward
```
import 'package:functional_admob_flutter/functional_admob_reward.dart';
```

```
  Future _demoFunctionalReward() async {
    final rewardAd = FunctionalAdmobReward(
      adUnitId: getRewardBasedVideoAdUnitId(),
    );

    if (!await rewardAd.load()) throw 'Failed to load reward Ad';

    final result = await rewardAd.show();
    if (result != null) {
      _dialogRewarded(result);

      print('Type: ${result['type']}');
      print('Amount: ${result['amount']}');
    } else {
      print('failed to get reward!');
    }
  }
```