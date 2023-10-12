import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  static const String routeName = '/profile_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        appbarTitle: 'Profile',
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}
