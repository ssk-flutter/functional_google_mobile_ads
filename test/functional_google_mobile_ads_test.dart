import 'package:flutter_test/flutter_test.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads_platform_interface.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFunctionalGoogleMobileAdsPlatform
    with MockPlatformInterfaceMixin
    implements FunctionalGoogleMobileAdsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FunctionalGoogleMobileAdsPlatform initialPlatform = FunctionalGoogleMobileAdsPlatform.instance;

  test('$MethodChannelFunctionalGoogleMobileAds is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFunctionalGoogleMobileAds>());
  });

  test('getPlatformVersion', () async {
    FunctionalGoogleMobileAds functionalGoogleMobileAdsPlugin = FunctionalGoogleMobileAds();
    MockFunctionalGoogleMobileAdsPlatform fakePlatform = MockFunctionalGoogleMobileAdsPlatform();
    FunctionalGoogleMobileAdsPlatform.instance = fakePlatform;

    expect(await functionalGoogleMobileAdsPlugin.getPlatformVersion(), '42');
  });
}
