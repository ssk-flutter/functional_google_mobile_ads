import 'package:selector/selector.dart';

class TestAdId {
  final String appOpening = androidOrElse(
    'ca-app-pub-3940256099942544/3419835294',
    'ca-app-pub-3940256099942544/5662855259',
  );
  final String banner = androidOrElse(
    'ca-app-pub-3940256099942544/6300978111',
    'ca-app-pub-3940256099942544/2934735716',
  );
  final String interstitial = androidOrElse(
    'ca-app-pub-3940256099942544/1033173712',
    'ca-app-pub-3940256099942544/4411468910',
  );
  final String interstitialVideo = androidOrElse(
    'ca-app-pub-3940256099942544/8691691433',
    'ca-app-pub-3940256099942544/5135589807',
  );
  final String rewarded = androidOrElse(
    'ca-app-pub-3940256099942544/5224354917',
    'ca-app-pub-3940256099942544/1712485313',
  );
  final String rewardedInterstitial = androidOrElse(
    'ca-app-pub-3940256099942544/5354046379',
    'ca-app-pub-3940256099942544/6978759866',
  );
  final String nativeAdvanced = androidOrElse(
    'ca-app-pub-3940256099942544/2247696110',
    'ca-app-pub-3940256099942544/3986624511',
  );
  final String nativeAdvancedVideo = androidOrElse(
    'ca-app-pub-3940256099942544/1044960115',
    'ca-app-pub-3940256099942544/2521693316',
  );
}
