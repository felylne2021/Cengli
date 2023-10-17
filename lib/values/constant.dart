import 'package:velix/velix.dart';

class Constant {
  static const String dynamicLinkBaseUrl = 'https://cengli-dev.web.app';
  static const String dynamicLinkPrefix = 'https://cengli.page.link';

  static String androidBundleId = FlavorConfig.isDevelopment()
      ? "com.cengli.androidapp.dev"
      : "com.cengli.androidapp";
  static String iOSBundleId = FlavorConfig.isDevelopment()
      ? "com.cengli.iosapp.dev"
      : "com.cengli.iosapp";
  static const String appStoreId = "6446429674";
  static const String commethApiKey = "4a6194e8-d56f-4ec3-bc1e-fe821c689dae";
  static const String formatDate = 'dd MMMM yyyy';
}
