import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:functional_google_mobile_ads/functional_google_mobile_ads_method_channel.dart';

void main() {
  MethodChannelFunctionalGoogleMobileAds platform = MethodChannelFunctionalGoogleMobileAds();
  const MethodChannel channel = MethodChannel('functional_google_mobile_ads');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
