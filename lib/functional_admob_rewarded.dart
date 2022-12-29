import 'functional_google_mobile_ads.dart';

class FunctionalAdmobRewarded {
  static Future<RewardItem> get({required String adUnitId}) async {
    final rewarded = FunctionalAdmobRewarded();
    await rewarded.load(adUnitId: adUnitId);
    return await rewarded.show();
  }

  FunctionalAdmobRewarded();

  RewardedAd? _rewardedAd;

  RewardedAd get rewardedAd => _rewardedAd!;

  LoadAdError? loadAdError;

  get isReady => _rewardedAd != null;

  Future<void> load({
    required adUnitId,
    AdRequest? request,
    RewardedAdLoadCallback? rewardedAdLoadCallback,
  }) async {
    _rewardedAd = null;
    loadAdError = null;

    await RewardedAd.load(
      adUnitId: adUnitId,
      request: request ?? const AdRequest(),
      rewardedAdLoadCallback:
          createRewardedAdLoadCallback(rewardedAdLoadCallback),
    );

    while (_rewardedAd == null) {
      if (loadAdError != null) {
        throw loadAdError!;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    loadAdError = null;
  }

  RewardedAdLoadCallback createRewardedAdLoadCallback(
      RewardedAdLoadCallback? userCallback) {
    return RewardedAdLoadCallback(
      onAdLoaded: (ad) {
        _rewardedAd = ad;
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
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
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
      rewardedAd.setImmersiveMode(immersiveMode);
    }

    RewardItem? item;
    await rewardedAd.show(onUserEarnedReward: (ad, reward) {
      item = reward;
    });

    while (item == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    dispose();
    return item!;
  }
}
