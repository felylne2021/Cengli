import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../utils/utils.dart';
import '../../../values/values.dart';
import 'component/modal_header.dart';

class QrModalPage extends StatelessWidget {
  final String address;
  final String chainName;
  final String username;

  const QrModalPage(
      {super.key,
      required this.address,
      required this.chainName,
      required this.username});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
          minHeight: MediaQuery.of(context).size.height * 0.3),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                14.0.height,
                const ModalHeader(title: "Address"),
                24.0.height,
                Container(
                  decoration: BoxDecoration(
                      color: primaryYellow,
                      borderRadius: BorderRadius.circular(8)),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  child: Text(
                    "Only us this address on Polygon. Never use it on other chain or you’ll lose your assets!",
                    style: KxTypography(
                        type: KxFontType.caption2, color: KxColors.neutral700),
                    textAlign: TextAlign.center,
                  ),
                ),
                24.0.height,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
                  decoration: BoxDecoration(
                      color: KxColors.neutral100,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    chainName,
                    style: KxTypography(
                        type: KxFontType.fieldText2,
                        color: KxColors.neutral700),
                  ),
                ),
                24.0.height,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      boxShadow: KxShadowStyleEnum.elevationTwo.getShadows(),
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: QrImageView(
                    data: address,
                  ),
                ),
                24.0.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username,
                      style: KxTypography(
                          type: KxFontType.subtitle3,
                          color: KxColors.neutral700),
                    ),
                    4.0.width,
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: username))
                            .then((value) {
                          showToast("Username has been copied to clipboard");
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
                27.0.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      address,
                      textAlign: TextAlign.center,
                      style: KxTypography(
                          type: KxFontType.subtitle4,
                          color: KxColors.neutral500),
                    ).flexible(),
                    4.0.width,
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: username))
                            .then((value) {
                          showToast(
                              "Wallet address has been copied to clipboard");
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
                ).padding(const EdgeInsets.symmetric(horizontal: 24)),
                50.0.height
              ],
            ),
          )),
    );
  }
}
