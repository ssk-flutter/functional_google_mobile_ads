import 'functional_google_mobile_ads.dart';

class FunctionalInterstitialAd {
  static Future<void> loadAndShow({required String adUnitId}) async {
    final rewarded = FunctionalInterstitialAd();
    await rewarded.load(adUnitId: adUnitId);
    return await rewarded.show();
  }

  FunctionalInterstitialAd();

  InterstitialAd? _ad;

  InterstitialAd get ad => _ad!;

  LoadAdError? loadAdError;

  bool get isReady => _ad != null;

  Future<void> load({
    required String adUnitId,
    AdRequest? request,
    InterstitialAdLoadCallback? adLoadCallback,
  }) async {
    _ad = null;
    loadAdError = null;

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: request ?? const AdRequest(),
      adLoadCallback: createAdLoadCallback(adLoadCallback),
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

  InterstitialAdLoadCallback createAdLoadCallback(
      InterstitialAdLoadCallback? userCallback) {
    return InterstitialAdLoadCallback(
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

  Future show({
    bool? immersiveMode,
    FullScreenContentCallback<InterstitialAd>? fullScreenContentCallback,
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
      await ad.show();
    } catch (e) {
      rethrow;
    } finally {
      dispose();
    }
  }
}
