import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../values/values.dart';

class DynamicLinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<String> createDynamicLink(String suffix, String type) async {
    String kProductpageLink = '/$type?id=$suffix';

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: Constant.dynamicLinkPrefix,
        link: Uri.parse('${Constant.dynamicLinkBaseUrl}$kProductpageLink'),
        androidParameters: AndroidParameters(
          packageName: Constant.androidBundleId,
          minimumVersion: 1,
        ),
        iosParameters: IOSParameters(
            bundleId: Constant.iOSBundleId,
            appStoreId: Constant.appStoreId,
            minimumVersion: "1.0.0"));

    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    return shortLink.shortUrl.toString();
  }
}
