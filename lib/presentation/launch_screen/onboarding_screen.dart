import 'package:cengli/presentation/launch_screen/components/onboarding_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';

class OnboardingItem {
  final String title;
  final String caption;

  OnboardingItem(this.title, this.caption);
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});
  static const String routeName = '/onboarding_page';

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final List<OnboardingItem> items = [
    OnboardingItem("Cross chain chat powered payments",
        "Effortlessly split bills and transact across 20+ blockchains, all from a single chat interface."),
    OnboardingItem("Biometric blockchain interaction",
        "Securely manage your assets and approve transactions using just your biometrics"),
    OnboardingItem("Real-time transaction notifications",
        "Receive real-time notifications for payment requests, confirmations, and more"),
    OnboardingItem("Gasless transactions experience",
        "Experience seamless transactions without the usual gas costs. Dive into a hassle-free crypto experience"),
  ];

  @override
  void initState() {
    super.initState();
    _showModal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryGreen600,
      body: const Center(),
    );
  }

  _showModal() {
    Future.delayed(const Duration(seconds: 0)).then((_) {
      return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        context: context,
        backgroundColor: KxColors.neutral50,
        isScrollControlled: true,
        isDismissible: false,
        barrierColor: Colors.transparent,
        enableDrag: false,
        builder: (context) {
          return OnboardingBottomSheetWidget(items: items);
        },
      );
    });
  }
}
