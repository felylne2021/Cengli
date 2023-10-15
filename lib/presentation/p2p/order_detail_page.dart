import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/reusable/modal/modal_confirmation.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});
  static const String routeName = '/order_detail_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: "Order Details"),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Amount (USDC)",
                          style: KxTypography(
                              type: KxFontType.body2,
                              color: KxColors.neutral500),
                        ),
                        18.0.height,
                        Text("50,00",
                                style: KxTypography(
                                    type: KxFontType.headline4,
                                    color: KxColors.neutral700))
                            .padding(
                                const EdgeInsets.symmetric(horizontal: 16)),
                        22.0.height,
                        const Divider(color: KxColors.neutral100, thickness: 4),
                        24.0.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _item("Request from", "@miss"),
                            16.0.height,
                            _item("Address",
                                "TEGWc23432009023asda9asrR320923de09d"),
                            16.0.height,
                            _item("Status", "Waiting for payment"),
                            16.0.height,
                            _item("Method", "Cash"),
                          ],
                        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                        40.0.height,
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: primaryGreen100,
                              borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            "By accepting this order, the requested amount will be deducted from your balance and temporarily held it in our account. We'll send it to the customer when you have confirmed their payment.",
                            style: KxTypography(
                                type: KxFontType.caption2,
                                color: KxColors.neutral700),
                          ),
                        ),
                        const Spacer(),
                        16.0.height,
                        KxTextButton(
                                argument: KxTextButtonArgument(
                                    onPressed: () {},
                                    buttonText: "Accept Order",
                                    buttonColor: primaryGreen600,
                                    buttonTextStyle: KxTypography(
                                        type: KxFontType.buttonMedium,
                                        color: KxColors.neutral700),
                                    buttonSize: KxButtonSizeEnum.medium,
                                    buttonType: KxButtonTypeEnum.primary,
                                    buttonShape: KxButtonShapeEnum.square,
                                    buttonContent: KxButtonContentEnum.text))
                            .padding(
                                const EdgeInsets.symmetric(horizontal: 16)),
                        16.0.height,
                        KxTextButton(
                                argument: KxTextButtonArgument(
                                    onPressed: () {
                                      KxModalUtil()
                                          .showGeneralModal(
                                              context,
                                              const ModalConfirmationPage(
                                                  title:
                                                      "Are you sure want to cancel this order?",
                                                  caption:
                                                      "Once the order has been canceled, you will no longer be able to retrieve it.",
                                                  buttonTitle: "Cancel Order"))
                                          .then((value) {
                                        if (value != null) {
                                          //TODO: cancel order
                                        }
                                      });
                                    },
                                    buttonText: "Decline Order",
                                    buttonColor: KxColors.neutral700,
                                    buttonTextStyle: KxTypography(
                                        type: KxFontType.buttonMedium,
                                        color: Colors.white),
                                    buttonSize: KxButtonSizeEnum.medium,
                                    buttonType: KxButtonTypeEnum.primary,
                                    buttonShape: KxButtonShapeEnum.square,
                                    buttonContent: KxButtonContentEnum.text))
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                      ],
                    ).padding(const EdgeInsets.symmetric(vertical: 36)),
                  )));
        },
      ),
    );
  }

  Widget _item(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: KxTypography(
              type: KxFontType.fieldText3, color: KxColors.neutral500),
        ),
        Text(
          value,
          style: KxTypography(
              type: KxFontType.fieldText3, color: KxColors.neutral700),
        ).flexible()
      ],
    );
  }
}
