import 'functional_admob_flutter.dart';

class FunctionalAdmobRewarded {
  static Future<FunctionalAdmobRewarded> createAsync(
      {required String adUnitId}) async {
    final result = FunctionalAdmobRewarded(adUnitId: adUnitId);

    while (result.isReady == false) {
      if (result.loadAdError != null) {
        throw result.loadAdError!;
      }
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return result;
  }

  FunctionalAdmobRewarded({
    required this.adUnitId,
    AdRequest? request,
    RewardedAdLoadCallback? rewardedAdLoadCallback,
  }) : request = request ?? const AdRequest() {
    this.rewardedAdLoadCallback =
        createRewardedAdLoadCallback(rewardedAdLoadCallback);
    _initAsync();
  }

  final String adUnitId;
  final AdRequest request;
  late final RewardedAdLoadCallback rewardedAdLoadCallback;
  RewardedAd? _rewardedAd;

  bool get isReady => _rewardedAd != null;

  RewardedAd get rewardedAd => _rewardedAd!;

  LoadAdError? loadAdError;

  Future _initAsync() async {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: request,
      rewardedAdLoadCallback: rewardedAdLoadCallback,
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
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

  void showAndDispose() {
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        print('ad onAdShowFullScreen...');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('failed full');
      },
    );

    rewardedAd.setImmersiveMode(true);
    rewardedAd.show(onUserEarnedReward: (ad, reward) {});
    dispose();
  }
}
