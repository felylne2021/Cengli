import 'dart:convert';

import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/auth/model/request/relay_transaction_request.dart';
import 'package:cengli/data/modules/transfer/model/request/prepare_erc20_request.dart';
import 'package:cengli/data/modules/transfer/model/request/transfer_request.dart';
import 'package:cengli/data/modules/transfer/model/request/usdc_prepare_request.dart';
import 'package:cengli/presentation/reusable/page/status_page.dart';
import 'package:cengli/presentation/transfer/send_detail_page.dart';
import 'package:cengli/services/biometric_service.dart';
import 'package:cengli/services/services.dart';
import 'package:cengli/services/sign_html.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kinetix/kinetix.dart';
import 'dart:math' as math;

import '../../values/values.dart';
import '../home/home_tab_bar.dart';
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
  late InAppWebViewController _webViewController;
  String userAddress = "";
  bool isCrossChain = false;
  bool isDoneApprove = false;
  bool isDoneUsdc = false;

  @override
  void initState() {
    super.initState();
    isCrossChain = widget.argument.senderChain.chainId !=
        widget.argument.receiverChain.chainId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Transfer Details"),
        body: MultiBlocListener(
            listeners: [
              BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, state) {
                return state is PrepareTransactionErrorState ||
                    state is PrepareTransactionLoadingState ||
                    state is PrepareTransactionSuccessState;
              }, listener: (context, state) {
                if (state is PrepareTransactionSuccessState) {
                  hideLoading();
                  _signTransaction(
                      state.response, widget.argument.senderChain.rpcUrl ?? "");
                } else if (state is PrepareTransactionLoadingState) {
                  showLoading();
                } else if (state is PrepareTransactionErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is RelayTransactionErrorState ||
                    state is RelayTransactionLoadingState ||
                    state is RelayTransactionSuccessState;
              }, listener: (context, state) {
                if (state is RelayTransactionSuccessState) {
                  hideLoading();
                  _saveTransfer(TransferRequest(
                      fromUserId: userAddress,
                      fromAddress: userAddress,
                      destinationAddress:
                          widget.argument.receiverProfile.walletAddress,
                      destinationUserId:
                          widget.argument.receiverProfile.walletAddress,
                      tokenAddress:
                          widget.argument.selectedAsset.token?.address,
                      fromChainId: widget.argument.senderChain.chainId,
                      destinationChainId: widget.argument.receiverChain.chainId,
                      amount: widget.argument.amount.toInt(),
                      note: notesController.text));
                  Navigator.of(context).pushNamed(StatusPage.routeName,
                      arguments: StatusArgument(
                          () => Navigator.of(context).popUntil((route) =>
                              route.settings.name == HomeTabBarPage.routeName),
                          "Hooray, Transfer is Complete!",
                          "Your transaction has been successfully completed",
                          "Go to wallet"));
                } else if (state is RelayTransactionLoadingState) {
                  showLoading();
                } else if (state is RelayTransactionErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
              BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, state) {
                return state is GetBridgeSuccessState ||
                    state is GetBridgeErrorState ||
                    state is GetBridgeLoadingState;
              }, listener: (context, state) {
                if (state is GetBridgeSuccessState) {
                  hideLoading();
                  _prepareApprove(state.response.fromBridgeAddress ?? "");
                } else if (state is GetBridgeLoadingState) {
                  showLoading();
                } else if (state is GetBridgeErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
              BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, state) {
                return state is UsdcPrepareErrorState ||
                    state is UsdcPrepareLoadingState ||
                    state is UsdcPrepareSuccessState;
              }, listener: (context, state) {
                if (state is UsdcPrepareSuccessState) {
                  hideLoading();
                  _signTransaction(
                      state.response, widget.argument.senderChain.rpcUrl ?? "");
                } else if (state is UsdcPrepareLoadingState) {
                  showLoading();
                } else if (state is UsdcPrepareErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is RelayApproveTransactionErrorState ||
                    state is RelayApproveTransactionLoadingState ||
                    state is RelayApproveTransactionSuccessState;
              }, listener: (context, state) {
                if (state is RelayApproveTransactionSuccessState) {
                  hideLoading();
                  _prepareCross();
                } else if (state is RelayApproveTransactionLoadingState) {
                  showLoading();
                } else if (state is RelayApproveTransactionErrorState) {
                  hideLoading();
                  showToast(state.message);
                }
              }),
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is RelayCrossTransactionErrorState ||
                    state is RelayCrossTransactionLoadingState ||
                    state is RelayCrossTransactionSuccessState;
              }, listener: (context, state) {
                if (state is RelayCrossTransactionSuccessState) {
                  hideLoading();
                  _saveTransfer(TransferRequest(
                      fromUserId: userAddress,
                      fromAddress: userAddress,
                      destinationAddress:
                          widget.argument.receiverProfile.walletAddress,
                      destinationUserId:
                          widget.argument.receiverProfile.walletAddress,
                      tokenAddress:
                          widget.argument.selectedAsset.token?.address,
                      fromChainId: widget.argument.senderChain.chainId,
                      destinationChainId: widget.argument.receiverChain.chainId,
                      amount: widget.argument.amount.toInt(),
                      note: notesController.text));
                  Navigator.of(context).pushNamed(StatusPage.routeName,
                      arguments: StatusArgument(
                          () => Navigator.of(context).popUntil((route) =>
                              route.settings.name == HomeTabBarPage.routeName),
                          "Hooray, Transfer is Complete!",
                          "Your transaction has been successfully completed",
                          "Go to wallet"));
                } else if (state is RelayCrossTransactionLoadingState) {
                  showLoading();
                } else if (state is RelayCrossTransactionErrorState) {
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
                                  .padding(const EdgeInsets.symmetric(
                                      horizontal: 16)),
                              22.0.height,
                              const Divider(
                                  color: KxColors.neutral100, thickness: 4),
                              24.0.height,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _item(
                                      "Transfer to",
                                      widget.argument.receiverProfile
                                              .userName ??
                                          ""),
                                  16.0.height,
                                  _item(
                                      "Token",
                                      widget.argument.selectedAsset.token
                                              ?.symbol ??
                                          ""),
                                  16.0.height,
                                  _item(
                                      "Chain",
                                      (widget.argument.receiverChain
                                                  .chainName ??
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
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
                              ).padding(
                                  const EdgeInsets.symmetric(horizontal: 16)),
                              const Spacer(),
                              16.0.height,
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: InAppWebView(
                                        initialData: InAppWebViewInitialData(
                                            data: signScript),
                                        onLoadStart: (controller, url) {
                                          showLoading();
                                        },
                                        onLoadStop: (controller, url) {
                                          hideLoading();
                                        },
                                        initialOptions:
                                            InAppWebViewGroupOptions(
                                          crossPlatform: InAppWebViewOptions(
                                              useShouldOverrideUrlLoading: true,
                                              transparentBackground: true),
                                          android: AndroidInAppWebViewOptions(
                                            useHybridComposition: true,
                                          ),
                                          ios: IOSInAppWebViewOptions(
                                            allowsInlineMediaPlayback: true,
                                          ),
                                        ),
                                        androidOnPermissionRequest:
                                            (InAppWebViewController controller,
                                                String origin,
                                                List<String> resources) async {
                                          return PermissionRequestResponse(
                                              resources: resources,
                                              action:
                                                  PermissionRequestResponseAction
                                                      .GRANT);
                                        },
                                        shouldOverrideUrlLoading: (controller,
                                            navigationAction) async {
                                          return NavigationActionPolicy.ALLOW;
                                        },
                                        onWebViewCreated: (controller) {
                                          debugPrint("Created Web");
                                          _webViewController = controller;
                                          controller.addJavaScriptHandler(
                                              handlerName: 'signedTx',
                                              callback: (args) {
                                                List<RelayTransactionRequest>
                                                    transactionList =
                                                    (json.decode(jsonEncode(
                                                            args)) as List)
                                                        .map((i) =>
                                                            RelayTransactionRequest
                                                                .fromJson(i))
                                                        .toList();
                                                if (!isCrossChain) {
                                                  _relayTransaction(
                                                      transactionList.first);
                                                } else {
                                                  if (isDoneApprove) {
                                                    isDoneApprove = true;
                                                    _relayApproveTransaction(
                                                        transactionList.first);
                                                  } else {
                                                    _relayCrossTransaction(
                                                        transactionList.first);
                                                  }
                                                }
                                              });
                                        },
                                        onConsoleMessage: (controller,
                                            ConsoleMessage consoleMessage) {
                                          debugPrint(
                                              "console : ${consoleMessage.toString()}");
                                        },
                                      )),
                                  KxTextButton(
                                          argument: KxTextButtonArgument(
                                              onPressed: () async {
                                                final isApprove =
                                                    await BiometricService
                                                        .authenticateWithBiometrics();
                                                if (isApprove) {
                                                  if (widget
                                                          .argument
                                                          .senderChain
                                                          .chainId ==
                                                      widget
                                                          .argument
                                                          .receiverChain
                                                          .chainId) {
                                                    String walletAddress =
                                                        await SessionService
                                                            .getWalletAddress();
                                                    userAddress = walletAddress;

                                                    final double pow = widget
                                                            .argument
                                                            .selectedAsset
                                                            .token
                                                            ?.decimals ??
                                                        0;

                                                    final int formattedAmount =
                                                        (widget.argument
                                                                    .amount *
                                                                math.pow(
                                                                    10, pow))
                                                            .toInt();

                                                    //Same chain
                                                    _prepareTransaction(
                                                        PrepareErc20Request(
                                                            walletAddress:
                                                                walletAddress,
                                                            tokenAddress: widget
                                                                    .argument
                                                                    .selectedAsset
                                                                    .token
                                                                    ?.address ??
                                                                "",
                                                            functionName: "transfer",
                                                            args: [
                                                          widget
                                                                  .argument
                                                                  .receiverProfile
                                                                  .walletAddress ??
                                                              "",
                                                          "$formattedAmount"
                                                        ]));
                                                  } else {
                                                    //Cross chain
                                                    _getBridge(
                                                        widget
                                                                .argument
                                                                .senderChain
                                                                .chainId ??
                                                            0,
                                                        widget
                                                                .argument
                                                                .receiverChain
                                                                .chainId ??
                                                            0);
                                                  }
                                                }
                                              },
                                              buttonText: "Transfer",
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
                                ],
                              )
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

  _signTransaction(String response, String rpcUrl) async {
    String walletAddress = await SessionService.getWalletAddress();
    String privateKey = await SessionService.getPrivateKey(walletAddress);

    await _webViewController.evaluateJavascript(
        source:
            'signTransaction("$walletAddress", "$privateKey", \'$response\', "$rpcUrl")');
  }

  _prepareTransaction(PrepareErc20Request param) {
    context.read<TransferBloc>().add(PrepareTransactionEvent(param));
  }

  _usdcPrepareTransaction(UsdcPrepareRequest param) {
    context.read<TransferBloc>().add(UsdcPrepareTransferEvent(param));
  }

  _prepareCross() async {
    String walletAddress = await SessionService.getWalletAddress();
    final double pow = widget.argument.selectedAsset.token?.decimals ?? 0;
    final int formattedAmount =
        (widget.argument.amount * math.pow(10, pow)).toInt();

    _usdcPrepareTransaction(UsdcPrepareRequest(
        walletAddress: walletAddress,
        recipientAddress: widget.argument.receiverProfile.walletAddress,
        fromChainId: widget.argument.senderChain.chainId,
        destinationChainId: widget.argument.receiverChain.chainId,
        amount: formattedAmount));
  }

  _relayTransaction(RelayTransactionRequest param) {
    context.read<AuthBloc>().add(RelayTransactionEvent(param));
  }

  _relayApproveTransaction(RelayTransactionRequest param) {
    context.read<AuthBloc>().add(RelayApproveTransactionEvent(param));
  }

  _relayCrossTransaction(RelayTransactionRequest param) {
    context.read<AuthBloc>().add(RelayCrossTransactionEvent(param));
  }

  _saveTransfer(TransferRequest param) {
    context.read<TransferBloc>().add(SaveTransactionEvent(param));
  }

  _prepareApprove(String fromBridgeAddress) async {
    String walletAddress = await SessionService.getWalletAddress();
    userAddress = walletAddress;
    final double pow = widget.argument.selectedAsset.token?.decimals ?? 0;
    final int formattedAmount =
        (widget.argument.amount * math.pow(10, pow)).toInt();

    _prepareTransaction(PrepareErc20Request(
        walletAddress: walletAddress,
        tokenAddress: widget.argument.selectedAsset.token?.address ?? "",
        functionName: "approve",
        args: [fromBridgeAddress, "$formattedAmount"]));
  }

  _getBridge(int fromChainId, int destinationChainId) {
    context
        .read<TransferBloc>()
        .add(GetBridgeEvent(fromChainId, destinationChainId));
  }
}
