import 'package:cengli/values/values.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../../data/modules/transactional/model/bill.dart';
import '../../../reusable/appbar/custom_appbar.dart';
import 'component/bill_status_container.dart';
import 'detail/bills_detail_page.dart';

enum BillStatusEnum { settled, notPaid }

class BillsPage extends StatelessWidget {
  const BillsPage({super.key, required this.bills});
  static const String routeName = '/bills_page';
  final List<Bill> bills;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: 'Bills'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  final bill = bills[index];
                  return InkWell(
                    onTap: () => Navigator.of(context)
                        .pushNamed(BillsDetailPage.routeName, arguments: bill),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              bill.groupId ?? "Default Group Name",
                              style: KxTypography(
                                  type: KxFontType.subtitle4,
                                  color: KxColors.neutral700),
                            ),
                            billStatusWidget(
                                (bill.status ?? 'settled')
                                        .toLowerCase()
                                        .contains(BillStatusEnum.settled.name)
                                    ? BillStatusEnum.settled
                                    : BillStatusEnum.notPaid,
                                context)
                          ],
                        ),
                        Text(
                          bill.date ?? "Default Date",
                          style: KxTypography(
                              type: KxFontType.fieldText3, color: softGray),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Should pay to @${bill.recipient}',
                              style: KxTypography(
                                  type: KxFontType.fieldText3, color: softGray),
                            ),
                            Text(
                              '\$${bill.amount}',
                              style: KxTypography(
                                  type: KxFontType.subtitle4, color: deepGreen),
                            ),
                          ],
                        ),
                        14.0.height
                      ],
                    ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    thickness: 1,
                    color: KxColors.neutral200,
                  );
                },
                itemCount: bills.length),
          ),
        ),
      ),
    );
  }
}
