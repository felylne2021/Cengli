import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

/// Define a top-level named handler which background/terminated messages will call
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  /** If you're going to use other Firebase services in the background, such as Firestore,
      make sure you call `initializeApp` before using other Firebase services. */
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

class FcmUtil {
  static FcmUtil? _instance;
  static FirebaseMessaging _messaging = FirebaseMessaging.instance;

  FcmUtil._internal() {
    _instance = this;
    _messaging = FirebaseMessaging.instance;
  }

  factory FcmUtil() => _instance ?? FcmUtil._internal();

  static Future<String> getFcmToken() async {
    String fcmToken = await _messaging.getToken() ?? '';
    return fcmToken;
  }

  static Future<void> deleteFcmToken() async {
    await _messaging.deleteToken();
  }

  static void initFcm({required Function(String?) onSuccess}) async {
    /// Get FCM Token
    _messaging.getToken().then((token) {
      onSuccess.call(token);
    });

    // //Subscribe to topics
    // _messaging.subscribeToTopic("all");

    /// Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /** Update the iOS foreground notification presentation options to allow
        heads up notifications. */
    _messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    NotificationSettings settings = await _messaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  static void configureFcmState(
      {required Function(RemoteMessage) onForeground,
      required Function(RemoteMessage) onBackground,
      required Function(RemoteMessage) whenTerminate,
      Function(String)? onTokenRefresh}) {
    /// Handle notifications when app is terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        whenTerminate.call(message);
      }
    });

    /// Listen to notifications when app is in the foreground
    /// by default, heads up notification won't show up, you need to show heads up notification manually
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      onForeground.call(message);
    });

    /** Handle any interaction when the app is in the background via a Stream listener */
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onBackground.call(message);
    });

    /// When the FCM token refreshes...
    FirebaseMessaging.instance.onTokenRefresh.listen((String token) {
      onTokenRefresh?.call(token);
    });
  }
}
