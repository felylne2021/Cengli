import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/reusable/page/status_page.dart';
import 'package:cengli/presentation/transfer/send_detail_page.dart';
import 'package:cengli/services/eth_service.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';

class SendSummaryPage extends StatefulWidget {
  final SendArgument argument;

  const SendSummaryPage({super.key, required this.argument});

  @override
  State<SendSummaryPage> createState() => _SendSummaryPageState();
  static const String routeName = '/send_summary_page';
}

class _SendSummaryPageState extends State<SendSummaryPage> {
  TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Transfer Details"),
        body: BlocListener<TransferBloc, TransferState>(
            listenWhen: (previous, state) {
          return state is PostTransferErrorState ||
              state is PostTransferLoadingState ||
              state is PostTransferSuccessState;
        }, listener: (context, state) {
          if (state is PostTransferSuccessState) {
            hideLoading();
            Navigator.of(context).pushNamedAndRemoveUntil(
                StatusPage.routeName, (route) => false,
                arguments: StatusArgument(() => Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                        HomePage.routeName, (route) => false)));
          } else if (state is PostTransferLoadingState) {
            showLoading();
          } else if (state is PostTransferErrorState) {
            hideLoading();
            showToast(state.message);
          }
        }, child: LayoutBuilder(
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
                            "Amount (${widget.argument.selectedAsset.token?.symbol ?? ""})",
                            style: KxTypography(
                                type: KxFontType.body2,
                                color: KxColors.neutral500),
                          ),
                          18.0.height,
                          Text(widget.argument.amount.toString(),
                                  style: KxTypography(
                                      type: KxFontType.headline4,
                                      color: KxColors.neutral700))
                              .padding(
                                  const EdgeInsets.symmetric(horizontal: 16)),
                          22.0.height,
                          const Divider(
                              color: KxColors.neutral100, thickness: 4),
                          24.0.height,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _item(
                                  "Transfer to",
                                  widget.argument.receiverProfile.userName ??
                                      ""),
                              16.0.height,
                              _item(
                                  "Token",
                                  widget.argument.selectedAsset.token?.symbol ??
                                      ""),
                              16.0.height,
                              _item(
                                  "Chain",
                                  (widget.argument.receiverChain.chainName ??
                                          "")
                                      .split(" ")
                                      .first),
                              16.0.height,
                              _item(
                                  "Address",
                                  widget.argument.receiverProfile
                                          .walletAddress ??
                                      ""),
                              16.0.height,
                              Text(
                                "Notes",
                                style: KxTypography(
                                    type: KxFontType.fieldText3,
                                    color: KxColors.neutral500),
                              ),
                              8.0.height,
                              TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: KxColors.neutral100,
                                  hintText: "Notes",
                                  hintStyle: KxTypography(
                                      type: KxFontType.fieldText1,
                                      color: KxColors.neutral400),
                                ),
                                controller: notesController,
                              ),
                            ],
                          ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                          const Spacer(),
                          16.0.height,
                          KxTextButton(
                                  argument: KxTextButtonArgument(
                                      onPressed: () {
                                        //*TODO: Sign and Transfer
                                        EthService().sendTransaction(widget
                                                .argument
                                                .receiverProfile
                                                .walletAddress ??
                                            "");
                                      },
                                      buttonText: "Transfer",
                                      buttonColor: primaryGreen600,
                                      buttonTextStyle: KxTypography(
                                          type: KxFontType.buttonMedium,
                                          color: KxColors.neutral700),
                                      buttonSize: KxButtonSizeEnum.medium,
                                      buttonType: KxButtonTypeEnum.primary,
                                      buttonShape: KxButtonShapeEnum.square,
                                      buttonContent: KxButtonContentEnum.text))
                              .padding(
                                  const EdgeInsets.symmetric(horizontal: 16))
                        ],
                      ).padding(const EdgeInsets.symmetric(vertical: 36)),
                    )));
          },
        )));
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

  _postTransfer(TransferRequest param) {
    context.read<TransferBloc>().add(PostTransferEvent(param));
  }
}
