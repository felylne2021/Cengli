import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});

  @override
  State<KycPage> createState() => _KycPageState();
  static const String routeName = '/kyc_page';
}

class _KycPageState extends State<KycPage> {
  final String userUrl =
      "https://cengli-2-copy-4fwin3or1-luminux.vercel.app/video-call?pkpg=35ecaf3dc46d80f17b3cdcd5248b119c7c39f5135e04b1bdfa42e897f7bb0903&recipientAddress=0x8f8A15956565670AC6F298596CBf70EF074D5A25&chatId=307c98a9939d6e908ded2191bc63405ee50335a94f9811df383241506f3a9829";

  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "KYC Video call"),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(userUrl)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true, transparentBackground: true),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            ),
          ),
          onLoadStart: (controller, url) {
            showLoading();
          },
          onLoadStop: (controller, url) {
            hideLoading();
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return NavigationActionPolicy.ALLOW;
          },
          onWebViewCreated: (controller) {
            debugPrint("Created");
            _webViewController = controller;
          },
          onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
            debugPrint(consoleMessage.toString());
          },
        ));
  }
}
