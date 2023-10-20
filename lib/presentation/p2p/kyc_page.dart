import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class KycPage extends StatefulWidget {
  final String url;

  const KycPage({super.key, required this.url});

  @override
  State<KycPage> createState() => _KycPageState();
  static const String routeName = '/kyc_page';
}

class _KycPageState extends State<KycPage> {
  late InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "KYC Video call"),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
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
            _webViewController = controller;
            controller.addJavaScriptHandler(
                handlerName: "callHandler",
                callback: (args) {
                  debugPrint("call handler $args");
                  if (args.first == "completed") {
                    Navigator.of(context).pop(true);
                  }
                });
          },
          onConsoleMessage: (controller, ConsoleMessage consoleMessage) {
            debugPrint(consoleMessage.toString());
          },
        ));
  }
}
