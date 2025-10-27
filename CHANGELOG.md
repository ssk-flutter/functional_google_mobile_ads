## 6.0.1
- Fixed issue #6: Banner and native banner ads now respect parent constraints instead of only using MediaQuery
- FunctionalBannerAd now uses LayoutBuilder to properly size ads based on parent container
- FunctionalNativeBannerAd replaced MediaQuery with LayoutBuilder for accurate sizing
- Fixed AdWidget reuse error by implementing proper lifecycle management with didUpdateWidget
- Added support for fluid AdSize (negative width/height values)
- Ads now work correctly in Expanded widgets and OrientationBuilder
- Removed hardcoded padding calculations (screenWidth-32) in native banner ads
- Improved ad reload logic: only recreates when adSize/templateType changes
- Added comprehensive test pages for both banner and native banner ads

## 6.0.0
- Updated to match google_mobile_ads 6.0.0 version

## 0.2.2
- Fixed BoxConstraints negative minimum width issue in FunctionalNativeBannerAd
- Fixed banner ad size requirements error by using standard AdSize

## 0.2.1
- Improved pub.dev score to achieve maximum points (130/130)
- Updated Google Mobile Ads dependency to ^6.0.0 for better compatibility
- Fixed dependency constraint lower bounds compatibility issues
- Enhanced pubspec.yaml metadata with comprehensive package information
- Added topics, homepage, issue tracker, and documentation links
- Fixed all Dart formatting issues to pass static analysis
- Improved package description for better discoverability

## 0.2.0
- Add FunctionalNativeBannerAd widget for native banner advertisements
- Support for TemplateType.small and TemplateType.medium native ad templates
- Dynamic size calculation based on template type and screen dimensions
- Comprehensive error handling and loading states
- NativeAdListener wrapper for ad event handling
- NativeTemplateStyle support for customization
- Updated Android build configuration for Flutter 3.35.3 compatibility
- Updated to support latest Google Mobile Ads SDK (5.3.1)
- Added comprehensive test coverage for native banner ads
- Updated example app with native banner ad demonstration

## 0.1.5
- unspecify `google_mobile_ads` and `plugin_platform_interface` version

## 0.1.4
* dispose finally

## 0.1.3
* FunctionalInterstitialAd
* FunctionalRewardedAd
* FunctionalRewardedInterstitialAd
* FunctionalBannerAd

## 0.0.2
* FunctionalAdmobRewarded

## 0.0.1
* FunctionalAdmobBanner
