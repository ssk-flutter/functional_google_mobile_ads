import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FunctionalBannerAd extends StatefulWidget {
  const FunctionalBannerAd({
    super.key,
    required this.bannerAdUnitId,
    this.adSize = AdSize.banner,
    this.bannerListener,
  });

  final String bannerAdUnitId;
  final AdSize adSize;
  final BannerAdListener? bannerListener;

  @override
  State<FunctionalBannerAd> createState() => _FunctionalBannerAdState();
}

class _FunctionalBannerAdState extends State<FunctionalBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void didUpdateWidget(FunctionalBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload ad if adSize or adUnitId changes
    if (oldWidget.adSize != widget.adSize ||
        oldWidget.bannerAdUnitId != widget.bannerAdUnitId) {
      _disposeAd();
      _loadAd();
    }
  }

  @override
  void dispose() {
    _disposeAd();
    super.dispose();
  }

  void _disposeAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      size: widget.adSize,
      adUnitId: widget.bannerAdUnitId,
      listener: createBannerAdListener(),
      request: const AdRequest(),
    )..load();
  }

  BannerAdListener createBannerAdListener() {
    return BannerAdListener(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() => _isAdLoaded = true);
        }
        widget.bannerListener?.onAdLoaded?.call(ad);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate actual size respecting parent constraints
        final adWidth = widget.adSize.width.toDouble();
        final adHeight = widget.adSize.height.toDouble();

        // Handle fluid AdSize (width=-1 or height=-1)
        final isFluidWidth = adWidth < 0;
        final isFluidHeight = adHeight < 0;

        // Calculate actual dimensions
        double actualWidth;
        double actualHeight;

        if (isFluidWidth && constraints.hasBoundedWidth) {
          // Fluid width - use parent's available width
          actualWidth = constraints.maxWidth.clamp(1.0, double.infinity);
        } else if (constraints.hasBoundedWidth && !isFluidWidth) {
          // Fixed width - respect parent constraints but prefer ad size
          actualWidth = constraints.maxWidth.clamp(1.0, double.infinity);
        } else {
          // No parent constraint - use ad size
          actualWidth = adWidth.abs().clamp(1.0, double.infinity);
        }

        if (isFluidHeight && constraints.hasBoundedHeight) {
          // Fluid height - use parent's available height
          actualHeight = constraints.maxHeight.clamp(1.0, double.infinity);
        } else if (constraints.hasBoundedHeight && !isFluidHeight) {
          // Fixed height - respect parent constraints but prefer ad size
          actualHeight = constraints.maxHeight.clamp(1.0, double.infinity);
        } else {
          // No parent constraint - use ad size
          actualHeight = adHeight.abs().clamp(1.0, double.infinity);
        }

        final loadingWidget = Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
              ),
            ),
          ),
        );

        if (_bannerAd == null) {
          return SizedBox(
            width: actualWidth,
            height: actualHeight,
            child: loadingWidget,
          );
        }

        return SizedBox(
          width: actualWidth,
          height: actualHeight,
          child: _isAdLoaded ? AdWidget(ad: _bannerAd!) : loadingWidget,
        );
      },
    );
  }
}
