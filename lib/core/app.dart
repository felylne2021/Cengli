import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/membership/membership.dart';
import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/presentation/home/home_tab_bar.dart';
import 'package:cengli/presentation/launch_screen/launch_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:velix/velix.dart';

import '../di/injector.dart';
import '../routes/routes.dart';
import '../services/dynamic_link_service.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final TransactionalBloc _transactionalBloc = locator.get();
  final AuthBloc _authBloc = locator.get();
  final MembershipBloc _membershipBloc = locator.get();

  final _navigatorKey = locator<NavigationService>().navigatorKey;
  final _dynamicLink = locator<DynamicLinkService>();

  Uri? _deepLinkUri;

  @override
  void initState() {
    super.initState();
    _initDynamicLink();
  }

  Widget _setLaunchScreen(Uri? uri) {
    if (uri != null) {
      var path = uri.path;
      if (path.contains('group')) {
        String? groupId = uri.queryParameters['id'];
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => _authBloc),
          BlocProvider(create: (context) => _transactionalBloc),
          BlocProvider(create: (context) => _membershipBloc),
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
