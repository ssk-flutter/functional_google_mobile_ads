import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FunctionalAdmobBanner extends StatefulWidget {
  const FunctionalAdmobBanner({
    Key? key,
    required this.bannerAdUnitId,
    this.adSize = AdSize.banner,
    this.bannerListener,
  }) : super(key: key);

  final String bannerAdUnitId;
  final AdSize adSize;
  final BannerAdListener? bannerListener;

  @override
  State<FunctionalAdmobBanner> createState() => _FunctionalAdmobBannerState();
}

class _FunctionalAdmobBannerState extends State<FunctionalAdmobBanner> {
  late BannerAdListener _bannerListener;
  late AdRequest _adRequest;
  late BannerAd _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeAd();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  void _initializeAd() {
    _adRequest = const AdRequest();
    _bannerListener = createBannerAdListener();

    _bannerAd = BannerAd(
      size: _calculateAdSize(context),
      adUnitId: widget.bannerAdUnitId,
      listener: _bannerListener,
      request: _adRequest,
    )..load();
  }

  BannerAdListener createBannerAdListener() {
    return BannerAdListener(
      onAdLoaded: (ad) {
        widget.bannerListener?.onAdLoaded?.call(ad);
        setState(() {});
      },
      onAdFailedToLoad: (ad, error) {
        widget.bannerListener?.onAdFailedToLoad?.call(ad, error);
        ad.dispose();
        debugPrint('failed to load banner: $error)');
      },
      onAdClosed: (ad) => widget.bannerListener?.onAdClosed?.call(ad),
      onAdClicked: (ad) => widget.bannerListener?.onAdClicked?.call(ad),
      onAdImpression: (ad) => widget.bannerListener?.onAdImpression?.call(ad),
      onAdOpened: (ad) => widget.bannerListener?.onAdOpened?.call(ad),
      onAdWillDismissScreen: (ad) =>
          widget.bannerListener?.onAdWillDismissScreen?.call(ad),
      onPaidEvent: (Ad ad, double valueMicros, PrecisionType precision,
              String currencyCode) =>
          widget.bannerListener?.onPaidEvent?.call(
        ad,
        valueMicros,
        precision,
        currencyCode,
      ),
    );
  }

  AdSize _calculateAdSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var heightRatio = widget.adSize.height / widget.adSize.width;
    var height = heightRatio * width;

    final adSize = AdSize(width: width.toInt(), height: height.toInt());
    return adSize;
  }

  @override
  Widget build(BuildContext context) {
    final adSize = _calculateAdSize(context);
    return SizedBox(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: AdWidget(ad: _bannerAd),
    );
  }
}
