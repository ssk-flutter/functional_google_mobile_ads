import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FunctionalAdmobBanner extends StatefulWidget {
  const FunctionalAdmobBanner({
    Key? key,
    required String bannerAdUnitId,
    AdSize adSize = AdSize.banner,
  })  : _bannerAdUnitId = bannerAdUnitId,
        _adSize = adSize,
        super(key: key);

  final String _bannerAdUnitId;
  final AdSize _adSize;

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
    _bannerListener = BannerAdListener(
      onAdLoaded: (ad) {
        setState(() {});
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint('failed to load banner: $error)');
      },
    );

    _bannerAd = BannerAd(
      size: _calculateAdSize(context),
      adUnitId: widget._bannerAdUnitId,
      listener: _bannerListener,
      request: _adRequest,
    )..load();
  }

  AdSize _calculateAdSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    var heightRatio = widget._adSize.height / widget._adSize.width;
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
