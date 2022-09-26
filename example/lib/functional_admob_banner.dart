import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FunctionalAdmobBanner extends StatefulWidget {
  const FunctionalAdmobBanner({
    Key? key,
    required String bannerAdUnitId,
  })  : _bannerAdUnitId = bannerAdUnitId,
        super(key: key);

  final String _bannerAdUnitId;

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
    _bannerListener = BannerAdListener(onAdLoaded: (ad) {
      setState(() {});
    }, onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('failed to load banner: $error)');
    });

    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: widget._bannerAdUnitId,
      listener: _bannerListener,
      request: _adRequest,
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: AdWidget(ad: _bannerAd));
  }
}
