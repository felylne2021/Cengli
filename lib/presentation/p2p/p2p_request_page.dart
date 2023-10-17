import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/data/modules/transfer/model/request/create_order_request.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';
import 'package:intl/intl.dart';

import '../../bloc/transfer/transfer.dart';
import '../../values/values.dart';

class P2pArgument {
  final GetPartnersResponse partner;
  final UserProfile user;
  final int chainId;

  P2pArgument(this.partner, this.user, this.chainId);
}

class P2pRequestPage extends StatefulWidget {
  final P2pArgument argument;

  const P2pRequestPage({super.key, required this.argument});
  static const String routeName = '/p2p_request_page';

  @override
  State<P2pRequestPage> createState() => _P2pRequestPageState();
}

class _P2pRequestPageState extends State<P2pRequestPage> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> isValid = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Request Amount"),
        body: BlocListener<TransferBloc, TransferState>(
            listenWhen: (previous, state) {
              return state is CreateGroupP2pLoadingState ||
                  state is CreateGroupP2pErrorState ||
                  state is CreateGroupP2pSuccessState;
            },
            listener: (context, state) {
              if (state is CreateGroupP2pSuccessState) {
                hideLoading();
                Navigator.of(context).pop(true);
              } else if (state is CreateGroupP2pLoadingState) {
                showLoading();
              } else if (state is CreateGroupP2pErrorState) {
                hideLoading();
                showToast(state.message);
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.argument.partner.name ?? "",
                  style: KxTypography(
                      type: KxFontType.subtitle4, color: KxColors.neutral700),
                ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                4.0.height,
                Row(
                  children: [
                    Text(
                      "Quantity",
                      style: KxTypography(
                          type: KxFontType.fieldText3,
                          color: KxColors.neutral500),
                    ),
                    2.0.width,
                    Text(
                      "${NumberFormat.currency(locale: 'en_US', symbol: '').format(widget.argument.partner.balances?.first.amount ?? 0)} ${widget.argument.partner.balances?.first.token?.symbol ?? ""}",
                      style: KxTypography(
                          type: KxFontType.buttonSmall,
                          color: KxColors.neutral600),
                    ),
                  ],
                ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                16.0.height,
                const Divider(color: KxColors.neutral200, thickness: 4),
                16.0.height,
                KxFilledTextField(
                        title: "Amount",
                        hint: "00,00",
                        onChanged: (value) {
                          isValid.value = value.isNotEmpty;
                        },
                        prefix: Text(
                          "USDC",
                          style: KxTypography(
                              type: KxFontType.fieldText1,
                              color: KxColors.neutral500),
                        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                        controller: controller)
                    .padding(const EdgeInsets.symmetric(horizontal: 16)),
                const Spacer(),
                ValueListenableBuilder(
                  valueListenable: isValid,
                  builder: (context, value, child) {
                    return KxTextButton(
                            isDisabled: !value,
                            argument: KxTextButtonArgument(
                                onPressed: () => _createOrder(),
                                buttonText: "Continue",
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
            ).padding(const EdgeInsets.fromLTRB(0, 16, 0, 36))));
  }

  _createOrder() {
    context.read<TransferBloc>().add(CreateGroupP2pEvent(
        Group(
            name:
                "${widget.argument.partner.name} & ${widget.argument.user.userName}",
            groupDescription: "P2P Order",
            members: [widget.argument.partner.userId ?? ""]),
        CreateOrderRequest(
          partnerId: widget.argument.partner.id,
          buyerUserId: widget.argument.user.id,
          buyerAddress: widget.argument.user.walletAddress,
          amount: double.parse(controller.text),
          chainId: widget.argument.chainId,
          chatId: "",
          destinationChainId: widget.argument.chainId,
          tokenAddress:
              widget.argument.partner.balances?.first.token?.address ?? "",
        )));
  }
}
