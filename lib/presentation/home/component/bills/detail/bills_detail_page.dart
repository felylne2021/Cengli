import 'package:cengli/presentation/home/component/bills/component/bill_status_container.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/extensions/widget_ext.dart';
import 'package:cengli/utils/widget_util.dart';
import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../../../../data/modules/transactional/model/bill.dart';
import '../bills_page.dart';

class BillsDetailPage extends StatelessWidget {
  const BillsDetailPage({super.key, required this.bill});

  final Bill bill;
  static const String routeName = '/bills_detail_page';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: 'Bills Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // *Upper Section
            Center(
              child: Column(
                children: [
                  Text(
                    'Amount',
                    style: KxTypography(
                        type: KxFontType.body2, color: KxColors.neutral500),
                  ),
                  32.0.height,
                  Text(
                    '\$${bill.amount}',
                    style: KxTypography(
                        type: KxFontType.headline4, color: KxColors.neutral700),
                  ),
                  32.0.height,
                  billStatusWidget(
                      (bill.status ?? 'settled')
                              .toLowerCase()
                              .contains(BillStatusEnum.settled.name)
                          ? BillStatusEnum.settled
                          : BillStatusEnum.notPaid,
                      context),
                  24.0.height,
                  const Divider(
                    thickness: 4,
                    color: KxColors.neutral100,
                  ),
                  24.0.height,
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  DetailsWidget(
                    description: 'Request by',
                    value: bill.groupName ?? "",
                  ),
                  DetailsWidget(
                    description: 'Transfer to',
                    value: '@${bill.recipient}',
                  ),
                  DetailsWidget(
                    description: 'Accepted token',
                    value: '${bill.tokenUnit}',
                  ),
                  DetailsWidget(
                    description: 'Chain',
                    value: '${bill.chain}',
                  ),
                  DetailsWidget(
                    description: 'Address',
                    value: '${bill.walletAddress}',
                  ),
                  DetailsWidget(
                    description: 'Date',
                    value: '${bill.date}',
                  ),
                  DetailsWidget(
                    description: 'Notes',
                    value: '${bill.notes}',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 54.0),
                    child: KxTextButton(
                        argument: KxTextButtonArgument(
                            onPressed: () {},
                            buttonSize: KxButtonSizeEnum.large,
                            buttonType: KxButtonTypeEnum.primary,
                            buttonShape: KxButtonShapeEnum.square,
                            buttonColor: primaryGreen600,
                            textColor: KxColors.neutral700,
                            buttonContent: KxButtonContentEnum.text,
                            buttonText: 'Settle')),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    super.key,
    required this.description,
    required this.value,
  });

  final String description;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              description,
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
            description.toLowerCase() != 'address'
                ? Text(
                    value,
                    style: KxTypography(
                        type: KxFontType.fieldText3,
                        color: KxColors.neutral700),
                  )
                : Row(
                    children: [
                      Text(
                        value,
                        style: KxTypography(
                            type: KxFontType.fieldText3,
                            color: KxColors.neutral700),
                      ),
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(ClipboardData(text: value))
                              .then((value) {
                            showToast(
                                "Wallet Address has been copied to clipboard");
                          });
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: KxColors.neutral300,
                          child: SvgPicture.asset(
                            IC_COPY,
                            height: 9,
                            width: 10,
                          ),
                        ),
                      )
                    ],
                  ),
          ],
        ),
        16.0.height,
      ],
    );
  }
}
