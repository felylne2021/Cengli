import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';
import '../../../values/values.dart';

class StatusArgument {
  final Function() callback;
  final String title;
  final String caption;
  final String buttonTitle;

  StatusArgument(this.callback, this.title, this.caption, this.buttonTitle);
}

class StatusPage extends StatelessWidget {
  final StatusArgument argument;

  const StatusPage({super.key, required this.argument});
  static const String routeName = '/status_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCenterAppbar(appbarTitle: "Success"),
      body: Column(
        children: [
          const Spacer(),
          Image.asset(IMG_SUCCESS, width: 180, height: 180),
          Text(argument.title,
              style: KxTypography(
                  type: KxFontType.buttonMedium, color: KxColors.neutral700)),
          8.0.height,
          Text(argument.caption,
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500)),
          const Spacer(),
          KxTextButton(
              argument: KxTextButtonArgument(
                  onPressed: argument.callback,
                  buttonText: argument.buttonTitle,
                  buttonColor: primaryGreen600,
                  buttonTextStyle: KxTypography(
                      type: KxFontType.buttonMedium,
                      color: KxColors.neutral700),
                  buttonSize: KxButtonSizeEnum.medium,
                  buttonType: KxButtonTypeEnum.primary,
                  buttonShape: KxButtonShapeEnum.square,
                  buttonContent: KxButtonContentEnum.text))
        ],
      ).padding(const EdgeInsets.fromLTRB(16, 0, 16, 36)),
    );
  }
}
