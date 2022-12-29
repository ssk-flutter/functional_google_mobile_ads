import 'functional_google_mobile_ads.dart';

class FunctionalRewardedAd {
  static Future<RewardItem> loadAndShow({required String adUnitId}) async {
    final rewarded = FunctionalRewardedAd();
    await rewarded.load(adUnitId: adUnitId);
    return await rewarded.show();
  }

  FunctionalRewardedAd();

  RewardedAd? _ad;

  RewardedAd get ad => _ad!;

  LoadAdError? loadAdError;

  get isReady => _ad != null;

  Future<void> load({
    required adUnitId,
    AdRequest? request,
    RewardedAdLoadCallback? adLoadCallback,
  }) async {
    _ad = null;
    loadAdError = null;

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: request ?? const AdRequest(),
      rewardedAdLoadCallback: createRewardedAdLoadCallback(adLoadCallback),
    );

    while (_ad == null) {
      if (loadAdError != null) {
        throw loadAdError!;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void dispose() {
    _ad?.dispose();
    _ad = null;
    loadAdError = null;
  }

  RewardedAdLoadCallback createRewardedAdLoadCallback(
      RewardedAdLoadCallback? userCallback) {
    return RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        _ad = ad;
        userCallback?.onAdLoaded.call(ad);
      },
      onAdFailedToLoad: (LoadAdError error) {
        loadAdError = error;
        userCallback?.onAdFailedToLoad(error);
      },
    );
  }

  Future<RewardItem> show({
    bool? immersiveMode,
    FullScreenContentCallback<RewardedAd>? fullScreenContentCallback,
    OnUserEarnedRewardCallback? onUserEarnedReward,
  }) async {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        fullScreenContentCallback?.onAdShowedFullScreenContent?.call(ad);
      },
      onAdImpression: (ad) {
        fullScreenContentCallback?.onAdImpression?.call(ad);
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        fullScreenContentCallback?.onAdFailedToShowFullScreenContent
            ?.call(ad, error);
      },
      onAdWillDismissFullScreenContent: (ad) {
        fullScreenContentCallback?.onAdWillDismissFullScreenContent?.call(ad);
      },
      onAdDismissedFullScreenContent: (ad) {
        fullScreenContentCallback?.onAdDismissedFullScreenContent?.call(ad);
      },
      onAdClicked: (ad) {
        fullScreenContentCallback?.onAdClicked?.call(ad);
      },
    );

    if (immersiveMode != null) {
      ad.setImmersiveMode(immersiveMode);
    }

    try {
      RewardItem? item;
      await ad.show(onUserEarnedReward: (ad, reward) {
        item = reward;
      });

      while (item == null) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return item!;
    } catch (e) {
      rethrow;
    } finally {
      dispose();
    }
  }
}
