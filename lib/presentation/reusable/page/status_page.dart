import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';
import '../../../values/values.dart';

class StatusArgument {
  final Function() callback;

  StatusArgument(this.callback);
}

class StatusPage extends StatelessWidget {
  final StatusArgument argument;

  const StatusPage({super.key, required this.argument});
  static const String routeName = '/status_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(appbarTitle: "Success"),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(IMG_SUCCESS, width: 180, height: 180),
          const Spacer(),
          KxTextButton(
                  argument: KxTextButtonArgument(
                      onPressed: argument.callback,
                      buttonText: "Done",
                      buttonColor: primaryGreen600,
                      buttonTextStyle: KxTypography(
                          type: KxFontType.buttonMedium,
                          color: KxColors.neutral700),
                      buttonSize: KxButtonSizeEnum.medium,
                      buttonType: KxButtonTypeEnum.primary,
                      buttonShape: KxButtonShapeEnum.square,
                      buttonContent: KxButtonContentEnum.text))
              .padding(const EdgeInsets.symmetric(horizontal: 16))
        ],
      ).padding(const EdgeInsets.symmetric(horizontal: 16, vertical: 36)),
    );
  }
}
