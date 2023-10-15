import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';
import 'component/modal_header.dart';

class ModalConfirmationPage extends StatelessWidget {
  final String title;
  final String caption;
  final String buttonTitle;

  const ModalConfirmationPage(
      {super.key,
      required this.title,
      required this.caption,
      required this.buttonTitle});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.35),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.0.height,
            const ModalHeader(title: ""),
            16.0.height,
            Text(
              title,
              style: KxTypography(
                  type: KxFontType.subtitle3, color: KxColors.neutral700),
            ),
            8.0.height,
            Text(
              caption,
              style: KxTypography(
                  type: KxFontType.body2, color: KxColors.neutral500),
            ),
            40.0.height,
            KxTextButton(
                argument: KxTextButtonArgument(
                    onPressed: () => Navigator.of(context).pop(true),
                    buttonText: buttonTitle,
                    buttonColor: primaryGreen600,
                    buttonTextStyle: KxTypography(
                        type: KxFontType.buttonMedium,
                        color: KxColors.neutral700),
                    buttonSize: KxButtonSizeEnum.medium,
                    buttonType: KxButtonTypeEnum.primary,
                    buttonShape: KxButtonShapeEnum.square,
                    buttonContent: KxButtonContentEnum.text))
          ],
        ),
      ),
    );
  }
}
