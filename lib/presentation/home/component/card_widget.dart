import 'package:cengli/presentation/reusable/modal/qr_modal_page.dart';
import 'package:cengli/utils/utils.dart';
import 'package:cengli/utils/wallet_util.dart';
import 'package:cengli/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';
import 'package:shimmer/shimmer.dart';

import '../../../values/values.dart';
import '../../reusable/shimmer/box_skeleton_widget.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key,
      required this.walletAddress,
      required this.tokenCount,
      required this.balance,
      required this.chainName,
      required this.username,
      required this.isLoading});

  final String walletAddress;
  final int tokenCount;
  final String balance;
  final String chainName;
  final String username;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: KxShadowDecoration(
          style: KxShadowStyleEnum.elevationOne,
          radiusBorder: 16,
          backgroundColor: Colors.white),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned(right: 0, child: SvgPicture.asset(IMG_CARD_BG)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        walletAddress.isNotEmpty
                            ? WalletUtil.shortAddress(walletAddress)
                            : "",
                        style: KxTypography(
                            type: KxFontType.caption2,
                            color: KxColors.neutral700),
                      ),
                      4.0.width,
                      InkWell(
                        onTap: () async {
                          await Clipboard.setData(
                                  ClipboardData(text: walletAddress))
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
                      ).flexible()
                    ],
                  ),
                  40.0.height,
                  if (isLoading)
                    Shimmer.fromColors(
                      baseColor: basicSkeleton,
                      highlightColor: highlightSkeleton,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: const BoxSkeleton(
                          height: 34,
                          width: 100,
                        ),
                      ),
                    )
                  else
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        balance,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CengliTypography(
                            type: CengliFontType.headline4,
                            color: KxColors.neutral700),
                      ),
                    ),
                  20.0.height,
                  if (isLoading)
                    Shimmer.fromColors(
                      baseColor: basicSkeleton,
                      highlightColor: highlightSkeleton,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: const BoxSkeleton(
                          height: 12,
                          width: 50,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '$tokenCount Tokens',
                          style: KxTypography(
                              type: KxFontType.caption2,
                              color: KxColors.neutral700),
                        ),
                        InkWell(
                            onTap: () {
                              KxModalUtil().showGeneralModal(
                                  context,
                                  QrModalPage(
                                    address: walletAddress,
                                    chainName: chainName,
                                    username: username,
                                  ));
                            },
                            child: SvgPicture.asset(IC_QR_CODE))
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
