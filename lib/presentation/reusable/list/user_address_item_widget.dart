import 'package:cengli/utils/wallet_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:kinetix/kinetix.dart';

class UserAddressItemWidget extends StatelessWidget {
  final String? imageUrl;
  final String username;
  final String address;

  const UserAddressItemWidget(
      {super.key,
      this.imageUrl,
      required this.username,
      required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (imageUrl == null || imageUrl == "")
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: KxColors.neutral200),
            child: const Icon(CupertinoIcons.person_fill,
                color: KxColors.neutral400),
          )
        else
          Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: Image.network(imageUrl ?? ""),
          ),
        16.0.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
            8.0.height,
            Text(
              WalletUtil.shortAddress(address),
              style: KxTypography(
                  type: KxFontType.fieldText3, color: KxColors.neutral500),
            ),
          ],
        ),
      ],
    ).padding(const EdgeInsets.symmetric(vertical: 12));
  }
}
