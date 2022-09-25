
import 'functional_google_mobile_ads_platform_interface.dart';

class FunctionalGoogleMobileAds {
  Future<String?> getPlatformVersion() {
    return FunctionalGoogleMobileAdsPlatform.instance.getPlatformVersion();
  }
}
