import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/presentation/transfer/send_summary_page.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

import '../../data/modules/transfer/model/response/balance_response.dart';
import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';
import '../reusable/list/user_address_item_widget.dart';
import '../reusable/modal/modal_page.dart';

class SendArgument {
  final ChainResponse selectedChain;
  final BalanceResponse selectedAsset;
  final List<BalanceResponse> assets;
  final List<ChainResponse> chains;
  final UserProfile receiverProfile;
  final double amount;

  SendArgument(this.selectedChain, this.selectedAsset, this.assets, this.chains,
      this.receiverProfile, this.amount);
}

class SendDetailPage extends StatefulWidget {
  final SendArgument argument;

  const SendDetailPage({super.key, required this.argument});

  @override
  State<SendDetailPage> createState() => _SendDetailPageState();
  static const String routeName = '/send_detail_page';
}

class _SendDetailPageState extends State<SendDetailPage> {
  TextEditingController amountController = TextEditingController();
  ValueNotifier<BalanceResponse> selectedAsset =
      ValueNotifier(const BalanceResponse());
  ValueNotifier<ChainResponse> selectedChain =
      ValueNotifier(const ChainResponse());
  ValueNotifier<bool> isValid = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    selectedAsset.value = widget.argument.assets.first;
    selectedChain.value = widget.argument.chains.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: "Transfer"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Send to",
            style: KxTypography(
                type: KxFontType.body2, color: KxColors.neutral700),
          ),
          UserAddressItemWidget(
            username: widget.argument.receiverProfile.userName ?? "",
            address: widget.argument.receiverProfile.walletAddress ?? "",
          ),
          20.0.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Amount",
                style: KxTypography(
                    type: KxFontType.body2, color: KxColors.neutral700),
              ),
              ValueListenableBuilder(
                valueListenable: selectedAsset,
                builder: (context, value, child) {
                  return Text(
                    "Balance : ${value.balance} ${value.token?.symbol ?? ""}",
                    style: KxTypography(
                        type: KxFontType.caption1, color: KxColors.neutral700),
                  );
                },
              )
            ],
          ),
          KxFilledTextField(
              controller: amountController,
              hint: "00.00",
              onChanged: (_) {
                _validate();
              },
              suffix: InkWell(
                  onTap: () {
                    KxGeneralListModalArgument argument =
                        KxGeneralListModalArgument(
                      modalTitle: 'Select Asset',
                      items: [],
                      selectedItem: KxSelectedListItem("", false),
                      modalListType: KxModalListType.general,
                    );
                    KxModalUtil()
                        .showGeneralModal(
                            context,
                            ModalListPage(
                              argument: argument,
                              isNetworkImage: true,
                              assets: widget.argument.assets,
                            ))
                        .then((value) {
                      if (value != null) {
                        selectedAsset.value = value;
                        _validate();
                      }
                    });
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                        color: KxColors.neutral200,
                        borderRadius: BorderRadius.circular(8)),
                    child: ValueListenableBuilder(
                        valueListenable: selectedAsset,
                        builder: (context, item, child) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                item.token?.logoURI ?? "",
                                height: 24,
                                width: 24,
                              ),
                              8.0.width,
                              Text(
                                (item.token?.name ?? "").split(" ").first,
                                style: KxTypography(
                                    type: KxFontType.fieldText2,
                                    color: KxColors.neutral700),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 18,
                                color: KxColors.neutral700,
                              )
                            ],
                          );
                        }),
                  ))),
          16.0.height,
          Text(
            "Chain",
            style: KxTypography(
                type: KxFontType.body2, color: KxColors.neutral700),
          ),
          8.0.height,
          ValueListenableBuilder(
            valueListenable: selectedChain,
            builder: (context, value, child) {
              return InkWell(
                onTap: () {
                  KxGeneralListModalArgument argument =
                      KxGeneralListModalArgument(
                    modalTitle: 'Select Network',
                    items: [],
                    selectedItem: KxSelectedListItem("", false),
                    modalListType: KxModalListType.general,
                  );
                  KxModalUtil()
                      .showGeneralModal(
                          context,
                          ModalListPage(
                            argument: argument,
                            isNetworkImage: true,
                            chains: widget.argument.chains,
                          ))
                      .then((value) {
                    if (value != null) {
                      selectedChain.value = value;
                      _validate();
                    }
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        color: KxColors.neutral100,
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    child: Row(
                      children: [
                        Image.network(value.logoURI ?? "",
                            width: 24, height: 24),
                        12.0.width,
                        Text(
                          (value.chainName ?? "").split(" ").first,
                          style: KxTypography(
                              type: KxFontType.fieldText3,
                              color: KxColors.neutral700),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 24,
                          color: KxColors.neutral700,
                        )
                      ],
                    )),
              );
            },
          ),
          8.0.height,
          Text(
            "You will lose assets if sent to the wrong network",
            style: KxTypography(type: KxFontType.caption1, color: darkYellow),
          ),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: isValid,
            builder: (context, value, child) {
              return KxTextButton(
                      isDisabled: !value,
                      argument: KxTextButtonArgument(
                          onPressed: () => Navigator.of(context).pushNamed(
                              SendSummaryPage.routeName,
                              arguments: SendArgument(
                                  selectedChain.value,
                                  selectedAsset.value,
                                  [],
                                  [],
                                  widget.argument.receiverProfile,
                                  double.parse(amountController.text))),
                          buttonText: "Transfer",
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
      ).padding(const EdgeInsets.fromLTRB(16, 16, 16, 36)),
    );
  }

  void _validate() {
    isValid.value = amountController.text.isNotEmpty;
  }
}
