import 'package:cengli/di/injector.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../utils/fcm_util.dart';
import 'app.dart';

void setupRunApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FcmUtil.initFcm(onSuccess: (token) {
    debugPrint('FCM token $token');
  });
  initPush(env: ENV.prod);
  injectModules();
  configLoading();

  initializeDateFormatting()
      .then((value) => runApp(const ProviderScope(child: App())));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 10.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..boxShadow = <BoxShadow>[]
    ..indicatorColor = Colors.blue
    ..textColor = Colors.blue
    ..maskColor = Colors.black.withOpacity(0)
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.clear
    ..indicatorWidget = const CupertinoActivityIndicator()
    ..dismissOnTap = true;
}
