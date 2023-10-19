import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const NOTIFICATION_ICON = 'mipmap/ic_launcher';

class NotificationUtil {
  static NotificationUtil? _instance;

  NotificationUtil._internal() {
    _instance = this;
  }

  factory NotificationUtil() => _instance ?? NotificationUtil._internal();

  static Future createAndroidNotificationChannel(
      AndroidNotificationChannel channel) async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void initPlatformNotification(
      {required String androidIconLauncher,
      required DidReceiveNotificationResponseCallback? onSelectNotification}) {
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(androidIconLauncher);
    DarwinInitializationSettings initializationSettingsIOs =
        const DarwinInitializationSettings();
    InitializationSettings initSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOs);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  static void showNotification(
      {required AndroidNotificationChannel androidNotificationChannel,
      required String? androidIcon,
      required int notificationId,
      required String title,
      required String body,
      String? payload}) {
    flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          androidNotificationChannel.id,
          androidNotificationChannel.name,
          channelDescription: androidNotificationChannel.description,
          icon: androidIcon,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  static void showLocalNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0', // channel Id
        'general' // channel Name
        );
    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );
    flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }
}
