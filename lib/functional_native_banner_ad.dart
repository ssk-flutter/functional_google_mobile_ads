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
  State<FunctionalNativeBannerAd> createState() => _FunctionalNativeBannerAdState();
}

class _FunctionalNativeBannerAdState extends State<FunctionalNativeBannerAd> {
  NativeAd? _nativeAd;
  bool _isAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeNativeAd();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  void _initializeNativeAd() {
    _nativeAd?.dispose();
    _nativeAd = null;
    _isAdLoaded = false;

    _nativeAd = NativeAd(
      adUnitId: widget.adUnitId,
      listener: _createNativeAdListener(),
      request: widget.adRequest ?? const AdRequest(),
      nativeTemplateStyle: widget.nativeTemplateStyle ?? NativeTemplateStyle(
        templateType: widget.templateType,
      ),
      nativeAdOptions: widget.nativeAdOptions,
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
        widget.nativeAdListener?.onPaidEvent?.call(ad, valueMicros, precision, currencyCode);
      },
    );
  }



  Size _calculateAdSize(BuildContext context) {
    // 기본 크기 설정
    double defaultWidth = 320;
    double defaultHeight = 250;
    
    // 템플릿 타입에 따른 크기 조정
    switch (widget.templateType) {
      case TemplateType.small:
        defaultHeight = 150;
        break;
      case TemplateType.medium:
        defaultHeight = 250;
        break;
    }
    
    // 화면 크기에 맞춰 조정
    final screenWidth = MediaQuery.of(context).size.width;
    if (defaultWidth > screenWidth) {
      final ratio = defaultHeight / defaultWidth;
      defaultWidth = screenWidth - 32; // 패딩 고려
      defaultHeight = defaultWidth * ratio;
    }
    
    return Size(defaultWidth, defaultHeight);
  }

  Widget _buildAdWidget() {
    if (_isAdLoaded && _nativeAd != null) {
      return AdWidget(ad: _nativeAd!);
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Loading Native Ad...',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final adSize = _calculateAdSize(context);
    
    return SizedBox(
      width: widget.width ?? adSize.width,
      height: widget.height ?? adSize.height,
      child: _buildAdWidget(),
    );
  }
}