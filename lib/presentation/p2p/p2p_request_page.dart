import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';

class P2pRequestPage extends StatelessWidget {
  const P2pRequestPage({super.key});
  static const String routeName = '/p2p_request_page';

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    ValueNotifier<bool> isValid = ValueNotifier(false);

    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Request Amount"),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Michael Sudirman",
              style: KxTypography(
                  type: KxFontType.subtitle4, color: KxColors.neutral700),
            ).padding(const EdgeInsets.symmetric(horizontal: 16)),
            4.0.height,
            Row(
              children: [
                Text(
                  "Quantity",
                  style: KxTypography(
                      type: KxFontType.fieldText3, color: KxColors.neutral500),
                ),
                2.0.width,
                Text(
                  "1.062,00 USDC",
                  style: KxTypography(
                      type: KxFontType.buttonSmall, color: KxColors.neutral600),
                ),
              ],
            ).padding(const EdgeInsets.symmetric(horizontal: 16)),
            16.0.height,
            const Divider(color: KxColors.neutral200, thickness: 4),
            16.0.height,
            KxFilledTextField(
                    title: "Amount",
                    hint: "00,00",
                    onChanged: (value) {
                      isValid.value = value.isNotEmpty;
                    },
                    prefix: Text(
                      "USDC",
                      style: KxTypography(
                          type: KxFontType.fieldText1,
                          color: KxColors.neutral500),
                    ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                    controller: controller)
                .padding(const EdgeInsets.symmetric(horizontal: 16)),
            const Spacer(),
            ValueListenableBuilder(
              valueListenable: isValid,
              builder: (context, value, child) {
                return KxTextButton(
                        isDisabled: !value,
                        argument: KxTextButtonArgument(
                            onPressed: () {},
                            buttonText: "Continue",
                            buttonColor: primaryGreen600,
                            buttonTextStyle: KxTypography(
                                type: KxFontType.buttonMedium,
                                color: value
                                    ? KxColors.neutral700
                                    : KxColors.neutral500),
                            buttonSize: KxButtonSizeEnum.medium,
                            buttonType: KxButtonTypeEnum.primary,
                            buttonShape: KxButtonShapeEnum.square,
                            buttonContent: KxButtonContentEnum.text))
                    .padding(const EdgeInsets.symmetric(horizontal: 16));
              },
            ),
          ],
        ).padding(const EdgeInsets.fromLTRB(0, 16, 0, 36)));
  }
}
