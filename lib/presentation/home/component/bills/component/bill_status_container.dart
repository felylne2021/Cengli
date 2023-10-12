import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../../../../values/values.dart';
import '../bills_page.dart';

Widget billStatusWidget(BillStatusEnum status, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17),
        color: status == BillStatusEnum.settled
            ? primaryGreen400
            : KxColors.neutral200),
    child: Text(
      status == BillStatusEnum.notPaid
          ? 'Not Paid'
          : status.name.toCapitalize(),
      style: KxTypography(
          type: KxFontType.caption2,
          color: status == BillStatusEnum.notPaid
              ? KxColors.neutral500
              : KxColors.neutral700),
    ),
  );
}
