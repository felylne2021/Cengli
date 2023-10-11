import 'package:cengli/presentation/chat/chat_page.dart';

import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const KxAppBarLeftTitle(
          elevationType: KxElevationAppBarEnum.noShadow,
          appBarTitle: "Cengli",
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
                child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pushNamed(ChatPage.routeName);
                    },
                    child: const Text("Test")))));
  }
}
