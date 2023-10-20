import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/membership/membership_remote_repository.dart';
import 'package:cengli/data/modules/membership/model/request/upsert_fcm_token_request.dart';
import 'package:cengli/presentation/home/home_tab_bar.dart';
import 'package:cengli/presentation/launch_screen/launch_screen.dart';
import 'package:cengli/services/services.dart';
import 'package:cengli/utils/fcm_util.dart';
import 'package:cengli/utils/notification_util.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velix/velix.dart';

import '../di/injector.dart';
import '../routes/routes.dart';

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'CENGLI-GENERAL', // id
  'General', // title
  description: 'Bemobile General Notification', // description
  importance: Importance.high,
);

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TransactionalBloc _transactionalBloc = locator.get();
  final AuthBloc _authBloc = locator.get();
  final MembershipBloc _membershipBloc = locator.get();
  final TransferBloc _transferBloc = locator.get();

  final _navigatorKey = locator<NavigationService>().navigatorKey;
  final _dynamicLink = locator<DynamicLinkService>();

  Uri? _deepLinkUri;

  @override
  void initState() {
    super.initState();
    _initDynamicLink();
    _configureNotification();
  }

  Widget _setLaunchScreen(Uri? uri) {
    if (uri != null) {
      var path = uri.path;
      if (path.contains('group')) {
        //*TODO: handle join group
        // return HomePage(groupId: groupId);
        return const LaunchScreenPage();
      } else {
        return const LaunchScreenPage();
      }
    } else {
      return const LaunchScreenPage();
    }
  }

  void _initDynamicLink() async {
    final PendingDynamicLinkData? initialLink =
        await _dynamicLink.dynamicLinks.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;

      setState(() {
        _deepLinkUri = deepLink;
      });
    }

    _dynamicLink.dynamicLinks.onLink.listen(
      (pendingDynamicLinkData) async {
        final Uri deepLink = pendingDynamicLinkData.link;
        _handleDynamicLinks(deepLink);
      },
    );
  }

  void _handleDynamicLinks(Uri deepLink) {
    var path = deepLink.path;
    if (path.contains('group')) {
      String? groupId = deepLink.queryParameters['id'];
      locator<NavigationService>()
          .pushReplacementNamed(HomeTabBarPage.routeName, arguments: groupId);
    }
  }

  _handleNotificationCallback(NotificationResponse response) {
    _handleNotifClick(response.payload);
  }

  _handleNotifClick(String? payload) {
    if (payload != null) {
      if (payload == "chat") {
        locator<NavigationService>().pushNamed(HomeTabBarPage.routeName,
            arguments: HomeTabBarPage.chatPage);
      }
    }
  }

  void _configureNotification() {
    NotificationUtil.initPlatformNotification(
        androidIconLauncher: NOTIFICATION_ICON,
        onSelectNotification: _handleNotificationCallback,
        onSelectNotificationBackground: _handleNotificationCallback);

    FcmUtil.configureFcmState(
      onForeground: (RemoteMessage message) {
        debugPrint('zzz on background $message');
        _handleGeneralNotification(message);
      },
      onBackground: (RemoteMessage message) {
        debugPrint('zzz on background $message');
        if (message.data.isNotEmpty) {
          Map<String, dynamic> dataNotification = message.data;
          _handleNotifClick(dataNotification['screen']);
        }
      },
      onTokenRefresh: (String token) async {
        debugPrint('zzz FCM token refreshed $token');
        final String walletAddress = await SessionService.getWalletAddress();
        locator<MembershipRemoteRepository>().upsertFcmToken(
            UpsertFcmTokenRequest(
                walletAddress: walletAddress, fcmToken: token));
      },
      whenTerminate: (RemoteMessage message) {
        debugPrint('zzz on background $message');
        _handleGeneralNotification(message);
      },
    );
  }

  void _handleGeneralNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    Map<String, dynamic> dataNotification = message.data;
    if (notification != null &&
        dataNotification.isNotEmpty &&
        android != null) {
      NotificationUtil.showNotification(
          androidNotificationChannel: channel,
          androidIcon: NOTIFICATION_ICON,
          notificationId: notification.hashCode,
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          payload: dataNotification['screen']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _authBloc),
          BlocProvider(create: (context) => _transactionalBloc),
          BlocProvider(create: (context) => _membershipBloc),
          BlocProvider(create: (context) => _transferBloc)
        ],
        child: MaterialApp(
          supportedLocales: const [Locale('en')],
          title: 'Cengli',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primarySwatch: Colors.blue,
          ),
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          builder: EasyLoading.init(),
          home: _setLaunchScreen(_deepLinkUri),
        ));
  }
}
