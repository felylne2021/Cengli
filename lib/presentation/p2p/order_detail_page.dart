import 'package:cengli/data/modules/transfer/model/response/order_response.dart';
import 'package:cengli/data/utils/collection_util.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/reusable/modal/modal_confirmation.dart';
import 'package:cengli/utils/widget_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/transfer/transfer.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../values/values.dart';

enum OrderStatusEventEnum { accept, cancel, payment, fund }

class OrderDetailArgument {
  final String orderId;
  final UserProfile user;

  OrderDetailArgument(this.orderId, this.user);
}

class OrderDetailPage extends StatefulWidget {
  final OrderDetailArgument argument;

  const OrderDetailPage({super.key, required this.argument});
  static const String routeName = '/order_detail_page';

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    _getOrder(widget.argument.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Order Details"),
        body: MultiBlocListener(
            listeners: [
              BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, state) {
                return state is UpdateOrderStatusSuccessState ||
                    state is UpdateOrderStatusErrorState ||
                    state is UpdateOrderStatusLoadingState;
              }, listener: (context, state) {
                if (state is UpdateOrderStatusSuccessState) {
                  hideLoading();
                  Navigator.of(context).pop(widget.argument.orderId);
                } else if (state is UpdateOrderStatusLoadingState) {
                  showLoading();
                } else if (state is UpdateOrderStatusErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
            ],
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                            child: BlocBuilder<TransferBloc, TransferState>(
                          buildWhen: (previous, state) {
                            return state is GetOrderSuccessState ||
                                state is GetOrderErrorState ||
                                state is GetOrderLoadingState;
                          },
                          builder: (context, state) {
                            if (state is GetOrderSuccessState) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Amount (USDC)",
                                    style: KxTypography(
                                        type: KxFontType.body2,
                                        color: KxColors.neutral500),
                                  ),
                                  18.0.height,
                                  Text(state.orderResponse.amount.toString(),
                                          style: KxTypography(
                                              type: KxFontType.headline4,
                                              color: KxColors.neutral700))
                                      .padding(const EdgeInsets.symmetric(
                                          horizontal: 16)),
                                  22.0.height,
                                  const Divider(
                                      color: KxColors.neutral100, thickness: 4),
                                  24.0.height,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _itemAddress(
                                          "Request from",
                                          state.orderResponse.buyerAddress ??
                                              ""),
                                      16.0.height,
                                      _item(
                                          "Status",
                                          _getStatus(
                                              state.orderResponse.status ??
                                                  "")),
                                      16.0.height,
                                      _item("Method", "Bank Transfer"),
                                    ],
                                  ).padding(const EdgeInsets.symmetric(
                                      horizontal: 16)),
                                  40.0.height,
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                        color: primaryGreen100,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Text(
                                      "By accepting this order, the requested amount will be deducted from your balance and temporarily held it in our account. We'll send it to the customer when you have confirmed their payment.",
                                      style: KxTypography(
                                          type: KxFontType.caption2,
                                          color: KxColors.neutral700),
                                    ),
                                  ).visibility(
                                      state.orderResponse.status == "WFSAC" &&
                                          widget.argument.user.userRole ==
                                              UserRoleEnum.partner.name),
                                  const Spacer(),
                                  16.0.height,
                                  KxTextButton(
                                          argument: KxTextButtonArgument(
                                              onPressed: () {
                                                bool isPartner = widget.argument
                                                        .user.userRole ==
                                                    UserRoleEnum.partner.name;
                                                String status = state
                                                        .orderResponse.status ??
                                                    "";

                                                if (isPartner) {
                                                  if (status == "WFSAC") {
                                                    _updateOrder(
                                                        OrderStatusEventEnum
                                                            .accept,
                                                        widget.argument.user
                                                                .id ??
                                                            "",
                                                        state.orderResponse
                                                                .id ??
                                                            "");
                                                  } else {
                                                    _updateOrder(
                                                        OrderStatusEventEnum
                                                            .fund,
                                                        widget.argument.user
                                                                .id ??
                                                            "",
                                                        state.orderResponse
                                                                .id ??
                                                            "");
                                                  }
                                                } else {
                                                  _updateOrder(
                                                      OrderStatusEventEnum
                                                          .payment,
                                                      widget.argument.user.id ??
                                                          "",
                                                      state.orderResponse.id ??
                                                          "");
                                                }
                                              },
                                              buttonText: _getGreenButtonTitle(
                                                  state.orderResponse.status ??
                                                      ""),
                                              buttonColor: primaryGreen600,
                                              buttonTextStyle: KxTypography(
                                                  type: KxFontType.buttonMedium,
                                                  color: KxColors.neutral700),
                                              buttonSize:
                                                  KxButtonSizeEnum.medium,
                                              buttonType:
                                                  KxButtonTypeEnum.primary,
                                              buttonShape:
                                                  KxButtonShapeEnum.square,
                                              buttonContent:
                                                  KxButtonContentEnum.text))
                                      .padding(const EdgeInsets.symmetric(
                                          horizontal: 16))
                                      .visibility(_isShowGreen(
                                          state.orderResponse.status ?? "")),
                                  16.0.height,
                                  KxTextButton(
                                          argument: KxTextButtonArgument(
                                              onPressed: () {
                                                bool isPartner = widget.argument
                                                        .user.userRole ==
                                                    UserRoleEnum.partner.name;
                                                String status = state
                                                        .orderResponse.status ??
                                                    "";
                                                if (isPartner) {
                                                  if (status == "WFSAC") {
                                                    _updateOrder(
                                                        OrderStatusEventEnum
                                                            .cancel,
                                                        widget.argument.user
                                                                .id ??
                                                            "",
                                                        state.orderResponse
                                                                .id ??
                                                            "");
                                                  } else {
                                                    KxModalUtil()
                                                        .showGeneralModal(
                                                            context,
                                                            const ModalConfirmationPage(
                                                                title:
                                                                    "Are you sure want to cancel this order?",
                                                                caption:
                                                                    "Once the order has been canceled, you will no longer be able to retrieve it.",
                                                                buttonTitle:
                                                                    "Cancel Order"))
                                                        .then((value) {
                                                      if (value != null) {
                                                        _updateOrder(
                                                            OrderStatusEventEnum
                                                                .cancel,
                                                            widget.argument.user
                                                                    .id ??
                                                                "",
                                                            state.orderResponse
                                                                    .id ??
                                                                "");
                                                      }
                                                    });
                                                  }
                                                } else {
                                                  KxModalUtil()
                                                      .showGeneralModal(
                                                          context,
                                                          const ModalConfirmationPage(
                                                              title:
                                                                  "Are you sure want to cancel this order?",
                                                              caption:
                                                                  "Once the order has been canceled, you will no longer be able to retrieve it.",
                                                              buttonTitle:
                                                                  "Cancel Order"))
                                                      .then((value) {
                                                    if (value != null) {
                                                      _updateOrder(
                                                          OrderStatusEventEnum
                                                              .cancel,
                                                          widget.argument.user
                                                                  .id ??
                                                              "",
                                                          state.orderResponse
                                                                  .id ??
                                                              "");
                                                    }
                                                  });
                                                }
                                              },
                                              buttonText: _getDarkButtonTitle(
                                                  state.orderResponse.status ??
                                                      ""),
                                              buttonColor: KxColors.neutral700,
                                              buttonTextStyle: KxTypography(
                                                  type: KxFontType.buttonMedium,
                                                  color: Colors.white),
                                              buttonSize:
                                                  KxButtonSizeEnum.medium,
                                              buttonType:
                                                  KxButtonTypeEnum.primary,
                                              buttonShape:
                                                  KxButtonShapeEnum.square,
                                              buttonContent:
                                                  KxButtonContentEnum.text))
                                      .padding(const EdgeInsets.symmetric(
                                          horizontal: 16))
                                      .visibility(_isShowDark(
                                          state.orderResponse.status ?? ""))
                                ],
                              ).padding(
                                  const EdgeInsets.symmetric(vertical: 36));
                            } else {
                              return const CupertinoActivityIndicator();
                            }
                          },
                        ))));
              },
            )));
  }

  bool _isShowGreen(String status) {
    bool isPartner = widget.argument.user.userRole == UserRoleEnum.partner.name;
    switch (status) {
      case "WFSAC":
        return isPartner ? true : false;
      case "WFSA":
        return isPartner ? true : false;
      case "WFBP":
        return isPartner ? false : true;
      default:
        return false;
    }
  }

  bool _isShowDark(String status) {
    bool isPartner = widget.argument.user.userRole == UserRoleEnum.partner.name;
    switch (status) {
      case "WFSAC":
        return true;
      case "WFBP":
        return isPartner ? true : false;
      default:
        return false;
    }
  }

  String _getDarkButtonTitle(String status) {
    bool isPartner = widget.argument.user.userRole == UserRoleEnum.partner.name;

    switch (status) {
      case "WFSAC":
        return isPartner ? "Decline Order" : "Cancel Order";
      default:
        return "Cancel Order";
    }
  }

  String _getGreenButtonTitle(String status) {
    switch (status) {
      case "WFSAC":
        return "Accept Order";
      case "WFBP":
        return "Already Transfer";
      default:
        return "Complete Order";
    }
  }

  String _getStatus(String status) {
    switch (status) {
      case "WFSAC":
        return "Waiting for seller to accept";
      case "WFBP":
        return "Waiting for buyer payment";
      case "WFSA":
        return "Waiting for seller approval";
      case "C":
        return "Completed";
      case "CB":
        return "Cancelled by buyer";
      default:
        return "Cancelled by seller";
    }
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
        ).flexible(),
      ],
    );
  }

  Widget _itemAddress(String title, String value) {
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
          textAlign: TextAlign.end,
          style: KxTypography(
              type: KxFontType.fieldText3, color: KxColors.neutral700),
        ).padding(const EdgeInsets.only(left: 50)).flexible(),
        InkWell(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: value)).then((value) {
              showToast("Wallet Address has been copied to clipboard");
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
          ).padding(const EdgeInsets.only(left: 8)),
        )
      ],
    );
  }

  _updateOrder(
      OrderStatusEventEnum status, String callerUserId, String orderId) {
    context
        .read<TransferBloc>()
        .add(UpdateOrderStatusEvent(orderId, callerUserId, status));
  }

  _getOrder(String orderId) async {
    context.read<TransferBloc>().add(GetOrderEvent(orderId));
  }
}
