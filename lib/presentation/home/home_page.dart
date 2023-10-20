import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/bloc/membership/state/get_list_groups_state.dart';
import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/bloc/transfer/transfer.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/bill.dart';
import 'package:cengli/data/modules/transactional/model/expense.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/data/modules/transfer/model/response/balance_response.dart';
import 'package:cengli/data/modules/transfer/model/response/chain_response.dart';
import 'package:cengli/data/modules/transfer/model/response/get_partners_response.dart';
import 'package:cengli/presentation/p2p/p2p_request_page.dart';
import 'package:cengli/presentation/reusable/notifier/double_notifier.dart';
import 'package:cengli/presentation/transfer/send_detail_page.dart';
import 'package:cengli/presentation/transfer/send_page.dart';
import 'package:cengli/services/services.dart';
import 'package:cengli/values/styles.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';
import 'package:intl/intl.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/transfer/model/response/transaction_response.dart';
import '../../utils/utils.dart';
import '../../values/values.dart';
import '../reusable/modal/modal_page.dart';
import '../reusable/segmented_control/segmented_control.dart';
import 'component/actions_widget.dart';
import 'component/bills/bills_page.dart';
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
  List<Bill> bills = [];
  List<Group> groups = [];

  String username = "";
  String address = "";
  String publicId = "";
  String groupId = '';

  _getWalletAddress() async {
    walletAddress.value = await SessionService.getWalletAddress();
    username = await SessionService.getUsername();

    _getUserData(username);
  }

  Future<void> _getExpenses(String groupId) async {
    context.read<TransactionalBloc>().add(FetchExpensesStoreEvent(groupId));
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
              _getAssets(state.chains
                      .firstWhere((response) => response.chainId == 43113)
                      .chainId ??
                  43113);
              selectedChain.value = state.chains
                  .firstWhere((response) => response.chainId == 43113);
              chains = state.chains
                  .where((response) =>
                      response.chainId == 43113 || response.chainId == 80001)
                  .toList();
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
          BlocListener<MembershipBloc, MembershipState>(
            listenWhen: (previous, state) {
              return state is GetListOfGroupIdSuccessState ||
                  state is GetListOfGroupsErrorState ||
                  state is GetListOfGroupsLoadingState;
            },
            listener: (context, state) {
              if (state is GetListOfGroupIdSuccessState) {
                groups = state.groups;
                _getExpenses(groupId);
              } else if (state is GetGroupErrorState) {}
            },
          ),
          BlocListener<TransactionalBloc, TransactionalState>(
            listenWhen: (previous, state) {
              return state is FetchExpensesErrorState ||
                  state is FetchExpensesLoadingState ||
                  state is FetchExpensesSuccessState;
            },
            listener: (context, state) {
              if (state is FetchExpensesSuccessState) {
                expenseResponse.value = state.expenses;
                bills.clear();
                for (var expense in expenseResponse.value) {
                  // for (var charge in expense.charges ?? []) {
                  bills.add(Bill(
                      groupId,
                      expense.memberPayId,
                      "USDC",
                      selectedChain.value.chainName,
                      expense.memberPayId,
                      expense.date,
                      "",
                      expense.status,
                      "0"));
                  // }
                }
                print(bills);
                hideLoading();

                // _getCharges(groupId);
              } else if (state is FetchExpensesErrorState) {
                hideLoading();
                showToast(state.message);
              } else if (state is FetchExpensesLoadingState) {
                showLoading();
              }
            },
          ),
          // BlocListener<TransactionalBloc, TransactionalState>(
          //   listenWhen: (previous, state) {
          //     return state is FetchChargesStoreErrorState ||
          //         state is FetchChargesStoreLoadingState ||
          //         state is FetchChargesStoreSuccessState;
          //   },
          //   listener: (context, state) {
          //     if (state is FetchChargesStoreSuccessState) {

          //       final charges = state.charges;
          //       for (int i = 0; i < charges.length; i++) {
          //         bills[i].
          //       }

          //     } else if (state is FetchChargesStoreErrorState) {}
          //   },
          // )
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
                  ActionWidget(
                      title: 'Send',
                      bgColor: softGreen,
                      iconPath: IC_SEND,
                      onTap: () => Navigator.of(context)
                              .pushNamed(SendPage.routeName,
                                  arguments: SendArgument(
                                      selectedChain.value,
                                      const ChainResponse(),
                                      const BalanceResponse(),
                                      assets.value,
                                      chains,
                                      const UserProfile(),
                                      0))
                              .then((_) {
                            _getChains();
                          })),
                  BlocBuilder<AuthBloc, AuthState>(
                    buildWhen: (previous, state) {
                      return state is GetUserDataErrorState ||
                          state is GetUserDataLoadingState ||
                          state is GetUserDataSuccessState;
                    },
                    builder: (context, state) {
                      if (state is GetUserDataSuccessState) {
                        return ActionWidget(
                            title: 'P2P',
                            bgColor: softPurple,
                            iconPath: IC_P2P,
                            onTap: () => Navigator.of(context)
                                    .pushNamed(P2pPage.routeName,
                                        arguments: P2pArgument(
                                            const GetPartnersResponse(),
                                            state.user,
                                            selectedChain.value.chainId ?? 0))
                                    .then((_) {
                                  _getChains();
                                }));
                      } else {
                        return ActionWidget(
                            title: 'P2P',
                            bgColor: softPurple,
                            iconPath: IC_P2P,
                            onTap: () {});
                      }
                    },
                  ),
                  ActionWidget(
                    title: 'Bills',
                    bgColor: softBlue,
                    iconPath: IC_BILLS,
                    onTap: () async {
                      //TODO: unhide
                      // EthService().sendTransaction("receiverAddress");
                      Navigator.of(context)
                          .pushNamed(BillsPage.routeName, arguments: bills);
                    },
                  ),
                ],
              ),
            ),
            30.0.height,
            SegmentedControl(
              activeColor: primaryGreen600,
              onSelected: (index) {
                currentIndex.value = index;
                if (index == 0) {
                  _getAssets(selectedChain.value.chainId ?? 0);
                } else {
                  _getUserId();
                }
              },
              title: segmentedTitles,
              initialIndex: currentIndex.value,
              currentIndex: currentIndex,
              segmentType: SegmentedControlEnum.ghost,
              padding: 16,
            ),
            14.0.height,
            ValueListenableBuilder(
              valueListenable: currentIndex,
              builder: (context, currIndex, child) {
                switch (currIndex) {
                  case 1:
                    return BlocBuilder<TransferBloc, TransferState>(
                      buildWhen: (previous, state) {
                        return state is GetTransactionsErrorState ||
                            state is GetTransactionsLoadingState ||
                            state is GetTransactionsSuccessState;
                      },
                      builder: (context, state) {
                        if (state is GetTransactionsSuccessState) {
                          if (state.transactions.isNotEmpty) {
                            return Column(
                                children: List.generate(
                                    state.transactions.length, (index) {
                              return Column(
                                children: [
                                  HomeItemsWidget(
                                    title: state.transactions[index].note ?? "",
                                    subtitle: DateFormat('d MMM y, h:mma')
                                        .format(DateTime.parse(state
                                                .transactions[index]
                                                .createdAt ??
                                            "")),
                                    value: NumberFormat.currency(
                                            locale: 'en_US', symbol: '\$')
                                        .format(
                                            state.transactions[index].amount),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: KxColors.neutral200,
                                  )
                                ],
                              );
                            }));
                          } else {
                            return Column(
                              children: [
                                Image.asset(
                                  IMG_EMPTY_CHAT,
                                  width: 150,
                                ),
                                Text(
                                  "No Transaction Found",
                                  style: KxTypography(
                                      type: KxFontType.buttonMedium,
                                      color: KxColors.neutral700),
                                )
                              ],
                            ).padding(
                                const EdgeInsetsDirectional.only(top: 24));
                          }
                        } else if (state is GetTransactionsLoadingState) {
                          return const CupertinoActivityIndicator().padding(
                              const EdgeInsetsDirectional.only(top: 24));
                        } else {
                          return const SizedBox();
                        }
                      },
                    );
                  default:
                    return BlocBuilder<TransferBloc, TransferState>(
                      buildWhen: (previous, state) {
                        return state is GetAssetsErrorState ||
                            state is GetAssetsLoadingState ||
                            state is GetAssetsSuccessState;
                      },
                      builder: (context, state) {
                        if (state is GetAssetsSuccessState) {
                          final tokens = state.assets.tokens ?? [];

                          if (tokens.isNotEmpty) {
                            return Column(
                                children: List.generate(tokens.length, (index) {
                              return Column(
                                children: [
                                  HomeItemsWidget(
                                    title: tokens[index].token?.name ?? "",
                                    subtitle:
                                        "${tokens[index].balance} ${tokens[index].token?.symbol}",
                                    networkImage: tokens[index].token?.logoURI,
                                    value: NumberFormat.currency(
                                            locale: 'en_US', symbol: '\$')
                                        .format(tokens[index].balanceUSd),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    color: KxColors.neutral200,
                                  )
                                ],
                              );
                            }));
                          } else {
                            return Column(
                              children: [
                                Image.asset(
                                  IMG_EMPTY_CHAT,
                                  width: 150,
                                ),
                                Text(
                                  "No Transaction Found",
                                  style: KxTypography(
                                      type: KxFontType.buttonMedium,
                                      color: KxColors.neutral700),
                                )
                              ],
                            ).padding(
                                const EdgeInsetsDirectional.only(top: 24));
                          }
                        } else if (state is GetAssetsLoadingState) {
                          return const CupertinoActivityIndicator().padding(
                              const EdgeInsetsDirectional.only(top: 24));
                        } else {
                          return const SizedBox();
                        }
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
                          style: CengliTypography(
                              type: CengliFontType.subtitle4,
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
                                      (item.chainName ?? "").split(" ").first,
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
    _getListGroupIds(userId);
  }

  _getTransactions(String userId) {
    context.read<TransferBloc>().add(GetTransactionsEvent(userId));
  }

  _getChains() {
    context.read<TransferBloc>().add(const GetChainsEvent());
  }

  _getUserData(String username) {
    context.read<AuthBloc>().add(GetUserDataEvent(username));
  }

  Future<void> _getCharges(String groupId) async {
    final String userId = await SessionService.getWalletAddress().then((id) {
      context
          .read<TransactionalBloc>()
          .add(FetchChargesStoreEvent(id, groupId));

      return id;
    });
  }

  String _findMemberName(String id) {
    String name = '';
    // for (UserProfile member in totalMembers.value) {
    //   if (id == member.id) {
    //     name = member.name ?? "";
    //   }
    // }

    return name;
  }

  _searchUser(String userId) {
    context.read<MembershipBloc>().add(SearchUserEvent(false, userId));
  }

  _getListGroupIds(String userId) {
    context.read<MembershipBloc>().add(GetListOfGroupsEvent(userId));
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
              16.0.width,
              Text(
                value,
                style: KxTypography(
                    type: KxFontType.buttonMedium, color: deepGreen),
              ).flexible()
            ],
          ).flexible(),
        ],
      ),
    );
  }
}
