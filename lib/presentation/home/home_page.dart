import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/data/modules/transfer/model/response/balance_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/presentation/home/component/bills/bills_page.dart';
import 'package:cengli/presentation/reusable/notifier/double_notifier.dart';
import 'package:cengli/presentation/transfer/send_detail_page.dart';
import 'package:cengli/presentation/transfer/send_page.dart';
import 'package:cengli/services/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';
import 'package:intl/intl.dart';

import '../../data/modules/transfer/model/response/transaction_response.dart';
import '../../utils/utils.dart';
import '../../values/values.dart';
import '../reusable/modal/modal_page.dart';
import '../reusable/segmented_control/segmented_control.dart';
import 'component/actions_widget.dart';
import 'component/card_widget.dart';
import '../p2p/p2p_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = '/home_page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _getWalletAddress();
    _getChains();
    //TODO: unhide once transaction is confirmed from API
    // _getExpenses();
  }

  ValueNotifier<ChainResponse> selectedChain =
      ValueNotifier(const ChainResponse());
  List<String> segmentedTitles = ['Assets', 'Transactions'];
  List<ChainResponse> chains = [];
  ValueNotifier<int> currentIndex = ValueNotifier(0);
  ValueNotifier<String> walletAddress = ValueNotifier('');
  ValueNotifier<List<Expense>> expenseResponse = ValueNotifier([]);
  ValueNotifier<List<TransactionResponse>> transactions = ValueNotifier([]);
  ValueNotifier<List<BalanceResponse>> assets = ValueNotifier([]);

  String username = "";

  _getWalletAddress() async {
    walletAddress.value = await SessionService.getWalletAddress();
    username = await SessionService.getUsername();
  }

  _getExpenses() async {
    // TODO: refactor dyanmic group ID
    context.read<TransactionalBloc>().add(
        const FetchExpensesStoreEvent("983abe5e-078d-4a82-8f14-cd88997992e1"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: KxColors.neutral50,
        appBar: homePageAppBar(context),
        body: MultiBlocListener(listeners: [
          BlocListener<TransferBloc, TransferState>(
              listenWhen: (previous, state) {
            return state is GetChainsErrorState ||
                state is GetChainsSuccessState;
          }, listener: ((context, state) {
            if (state is GetChainsSuccessState) {
              _getAssets(state.chains.first.chainId ?? 0);
              selectedChain.value = state.chains.first;
              chains = state.chains;
              _getUserId();
            } else if (state is GetChainsErrorState) {
              showToast(state.message);
            }
          })),
          BlocListener<TransferBloc, TransferState>(
              listenWhen: (previous, state) {
            return state is GetAssetsErrorState ||
                state is GetAssetsSuccessState;
          }, listener: ((context, state) {
            if (state is GetAssetsErrorState) {
              showToast(state.message);
            } else if (state is GetAssetsSuccessState) {
              assets.value = state.assets.tokens ?? [];
            }
          })),
          BlocListener<TransferBloc, TransferState>(
              listenWhen: (previous, state) {
            return state is GetTransactionsErrorState;
          }, listener: ((context, state) {
            if (state is GetTransactionsErrorState) {
              showToast(state.message);
            } else if (state is GetTransactionsSuccessState) {
              transactions.value = state.transactions;
            }
          })),
        ], child: _body()));
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DoubleValueListenableBuilder(
                first: walletAddress,
                second: selectedChain,
                builder: (context, address, chain, child) {
                  return BlocBuilder<TransferBloc, TransferState>(
                    buildWhen: (previous, state) {
                      return state is GetAssetsSuccessState ||
                          state is GetAssetsLoadingState;
                    },
                    builder: (context, state) {
                      if (state is GetAssetsSuccessState) {
                        return CardWidget(
                          walletAddress: address,
                          balance: NumberFormat.currency(
                                  locale: 'en_US', symbol: '\$')
                              .format(state.assets.totalBalanceUsd),
                          tokenCount: state.assets.tokens?.length ?? 1,
                          chainName: (chain.chainName ?? "").split(" ").first,
                          username: username,
                        );
                      } else {
                        return CardWidget(
                            walletAddress: address,
                            tokenCount: 1,
                            balance: "\$0",
                            chainName: "",
                            username: username);
                      }
                    },
                  );
                }),
            24.0.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 31),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //TODO: FILL ONTAP ACTION
                  ActionWidget(
                      title: 'Send',
                      bgColor: softGreen,
                      iconPath: IC_SEND,
                      onTap: () => Navigator.of(context).pushNamed(
                          SendPage.routeName,
                          arguments: SendArgument(
                              selectedChain.value,
                              const BalanceResponse(),
                              assets.value,
                              chains,
                              const UserProfile(),
                              0))),
                  ActionWidget(
                      title: 'P2P',
                      bgColor: softPurple,
                      iconPath: IC_P2P,
                      onTap: () =>
                          Navigator.of(context).pushNamed(P2pPage.routeName)),
                  ActionWidget(
                      title: 'Bills',
                      bgColor: softBlue,
                      iconPath: IC_BILLS,
                      onTap: () =>
                          Navigator.of(context).pushNamed(BillsPage.routeName)),
                ],
              ),
            ),
            30.0.height,
            SegmentedControl(
              activeColor: primaryGreen600,
              onSelected: (index) {
                currentIndex.value = index;
              },
              title: segmentedTitles,
              initialIndex: currentIndex.value,
              segmentType: SegmentedControlEnum.ghost,
              padding: 50,
            ),
            14.0.height,
            DoubleValueListenableBuilder(
              first: currentIndex,
              second: expenseResponse,
              builder: (context, currIndex, expense, child) {
                switch (currIndex) {
                  case 1:
                    return ValueListenableBuilder(
                      valueListenable: transactions,
                      builder: (context, value, child) {
                        return Column(
                            children: List.generate(value.length, (index) {
                          return Column(
                            children: [
                              HomeItemsWidget(
                                title: value[index].note ?? "",
                                subtitle: DateFormat('d MMM y, h:mma').format(
                                    DateTime.parse(
                                        value[index].createdAt ?? "")),
                                value: NumberFormat.currency(
                                        locale: 'en_US', symbol: '\$')
                                    .format(value[index].amount),
                              ),
                              const Divider(
                                thickness: 1,
                                color: KxColors.neutral200,
                              )
                            ],
                          );
                        }));
                      },
                    );
                  default:
                    return ValueListenableBuilder(
                      valueListenable: assets,
                      builder: (context, value, child) {
                        return Column(
                            children: List.generate(value.length, (index) {
                          return Column(
                            children: [
                              HomeItemsWidget(
                                title: value[index].token?.name ?? "",
                                subtitle:
                                    "${value[index].balance} ${value[index].token?.symbol}",
                                networkImage: value[index].token?.logoURI,
                                value: NumberFormat.currency(
                                        locale: 'en_US', symbol: '\$')
                                    .format(value[index].balanceUSd),
                              ),
                              const Divider(
                                thickness: 1,
                                color: KxColors.neutral200,
                              )
                            ],
                          );
                        }));
                      },
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSize homePageAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(105),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SafeArea(
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Wallet",
                          style: KxTypography(
                              type: KxFontType.subtitle4,
                              color: KxColors.neutral700)),
                      InkWell(
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
                                      chains: chains))
                              .then((value) {
                            if (value != null) {
                              selectedChain.value = value;
                              _getAssets(selectedChain.value.chainId ?? 0);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: KxColors.neutral200,
                              borderRadius: BorderRadius.circular(20)),
                          child: ValueListenableBuilder(
                              valueListenable: selectedChain,
                              builder: (context, item, child) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    if (item.logoURI != null)
                                      Image.network(
                                        item.logoURI ?? "",
                                        height: 24,
                                        width: 24,
                                      )
                                    else
                                      const CupertinoActivityIndicator(),
                                    8.0.width,
                                    Text(
                                      (item.chainName ?? "Polygon")
                                          .split(" ")
                                          .first,
                                      style: KxTypography(
                                          type: KxFontType.fieldText2,
                                          color: KxColors.neutral700),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: KxColors.neutral700,
                                    )
                                  ],
                                );
                              }),
                        ),
                      )
                    ],
                  ).padding(const EdgeInsets.fromLTRB(16, 50, 16, 12)))),
        ],
      ),
    );
  }

  _getAssets(int chainId) {
    context.read<TransferBloc>().add(GetAssetsEvent(chainId));
  }

  _getUserId() async {
    final userId = await SessionService.getWalletAddress();
    _getTransactions(userId);
  }

  _getTransactions(String userId) {
    context.read<TransferBloc>().add(GetTransactionsEvent(userId));
  }

  _getChains() {
    context.read<TransferBloc>().add(const GetChainsEvent());
  }
}

class HomeItemsWidget extends StatelessWidget {
  const HomeItemsWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.value,
      this.networkImage});
  final String title;
  final String subtitle;
  final String value;
  final String? networkImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (networkImage != null)
            Image.network(
              networkImage ?? "",
              height: 40,
              width: 40,
            )
          else
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                  color: KxColors.neutral200, shape: BoxShape.circle),
            ),
          16.0.width,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: KxTypography(
                        type: KxFontType.body2, color: KxColors.neutral700),
                  ),
                  Text(
                    subtitle,
                    style: KxTypography(
                        type: KxFontType.fieldText3,
                        color: KxColors.neutral500),
                  )
                ],
              ),
              Text(
                value,
                style: KxTypography(
                    type: KxFontType.buttonMedium, color: deepGreen),
              )
            ],
          ).flexible(),
        ],
      ),
    );
  }
}
