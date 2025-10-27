import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class FunctionalNativeBannerAd extends StatefulWidget {
  const FunctionalNativeBannerAd({
    super.key,
    required this.adUnitId,
    this.nativeAdOptions,
    this.nativeAdListener,
    this.adRequest,
    this.width,
    this.height,
    this.templateType = TemplateType.medium,
    this.nativeTemplateStyle,
  });

  final String adUnitId;
  final NativeAdOptions? nativeAdOptions;
  final NativeAdListener? nativeAdListener;
  final AdRequest? adRequest;
  final double? width;
  final double? height;
  final TemplateType templateType;
  final NativeTemplateStyle? nativeTemplateStyle;

  @override
  State<FunctionalNativeBannerAd> createState() =>
      _FunctionalNativeBannerAdState();
}

class _FunctionalNativeBannerAdState extends State<FunctionalNativeBannerAd> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void didUpdateWidget(FunctionalNativeBannerAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload ad if key properties change
    if (oldWidget.adUnitId != widget.adUnitId ||
        oldWidget.templateType != widget.templateType) {
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
    _nativeAd?.dispose();
    _nativeAd = null;
    _isAdLoaded = false;
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      listener: _createNativeAdListener(),
      request: widget.adRequest ?? const AdRequest(),
      nativeTemplateStyle: widget.nativeTemplateStyle ??
          NativeTemplateStyle(
            templateType: widget.templateType,
          ),
      nativeAdOptions: widget.nativeAdOptions ??
          NativeAdOptions(
            shouldRequestMultipleImages: false,
            shouldReturnUrlsForImageAssets: false,
            mediaAspectRatio: MediaAspectRatio.square,
          ),
    )..load();
  }

  NativeAdListener _createNativeAdListener() {
    return NativeAdListener(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() => _isAdLoaded = true);
        }
        widget.nativeAdListener?.onAdLoaded?.call(ad);
      },
      onAdFailedToLoad: (ad, error) {
        widget.nativeAdListener?.onAdFailedToLoad?.call(ad, error);
        ad.dispose();
        debugPrint('Failed to load native ad: ${error.message}');
      },
      onAdClicked: (ad) {
        widget.nativeAdListener?.onAdClicked?.call(ad);
      },
      onAdImpression: (ad) {
        widget.nativeAdListener?.onAdImpression?.call(ad);
      },
      onAdClosed: (ad) {
        widget.nativeAdListener?.onAdClosed?.call(ad);
      },
      onAdOpened: (ad) {
        widget.nativeAdListener?.onAdOpened?.call(ad);
      },
      onAdWillDismissScreen: (ad) {
        widget.nativeAdListener?.onAdWillDismissScreen?.call(ad);
      },
      onPaidEvent: (ad, valueMicros, precision, currencyCode) {
        widget.nativeAdListener?.onPaidEvent
            ?.call(ad, valueMicros, precision, currencyCode);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Default dimensions based on template type
        double defaultWidth = 320;
        double defaultHeight = widget.templateType == TemplateType.small ? 150 : 250;

        // Calculate actual dimensions
        double actualWidth;
        double actualHeight;

        if (widget.width != null) {
          // User specified width - use it
          actualWidth = widget.width!;
        } else if (constraints.hasBoundedWidth) {
          // Use parent's available width
          actualWidth = constraints.maxWidth.clamp(1.0, double.infinity);
        } else {
          // No parent constraint - use default
          actualWidth = defaultWidth;
        }

        if (widget.height != null) {
          // User specified height - use it
          actualHeight = widget.height!;
        } else if (constraints.hasBoundedHeight) {
          // Use parent's available height
          actualHeight = constraints.maxHeight.clamp(1.0, double.infinity);
        } else {
          // No parent constraint - use default
          actualHeight = defaultHeight;
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

        return SizedBox(
          width: actualWidth,
          height: actualHeight,
          child: _isAdLoaded && _nativeAd != null
              ? AdWidget(ad: _nativeAd!)
              : loadingWidget,
        );
      },
    );
  }
}
