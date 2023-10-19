import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/presentation/chat/expense/add_expense_page.dart';
import 'package:cengli/presentation/group/components/balance_expense_item_widget.dart';
import 'package:cengli/presentation/group/components/expense_item_widget.dart';
import 'package:cengli/presentation/group/group_member_page.dart';
import 'package:cengli/presentation/reusable/menu/custom_menu_item_widget.dart';
import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/auth/auth.dart';
import '../../bloc/membership/membership.dart';
import '../../bloc/transactional/state_remote/fetch_charges_store_state.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../data/modules/transactional/model/expense.dart';
import '../../services/services.dart';
import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';
import '../reusable/segmented_control/segmented_control.dart';

class GroupDetailPage extends StatefulWidget {
  final String chatId;

  const GroupDetailPage({super.key, required this.chatId});
  static const String routeName = '/group_detail_page';

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  List<String> segmentedTitles = ['Expenses', 'Balance', 'Bills'];
  ValueNotifier<int> selectedTab = ValueNotifier(0);
  ValueNotifier<List<UserProfile>> totalMembers = ValueNotifier([]);
  ValueNotifier<String> memberPayName = ValueNotifier('');
  String groupId = '';
  List<List<Map<String, dynamic>>> chargesFromGroup = [];
  ValueNotifier<UserProfile> userData = ValueNotifier(UserProfile());
  ValueNotifier<List<Expense>> listOfExpenses = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
    _initiateData();
    _getGroup();
    chargesFromGroup.clear();
  }

  _initiateData() async {
    String name = await SessionService.getUsername().then((value) => value);
    _getUserData(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarBackAndCenter(
        appbarTitle: "Group Details",
        trailingWidgets: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                  color: primaryGreen600,
                  borderRadius: BorderRadius.circular(20)),
              child: Text(
                "Edit",
                style: KxTypography(
                    type: KxFontType.buttonSmall, color: KxColors.neutral700),
              ),
            ),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<MembershipBloc, MembershipState>(
              listenWhen: (previous, state) {
            return state is GetGroupLoadingState ||
                state is GetGroupSuccessState ||
                state is GetGroupErrorState;
          }, listener: ((context, state) {
            if (state is GetGroupSuccessState) {
              groupId = state.group.id ?? "";
              _getMembers(state.group.members ?? []);
            } else if (state is GetGroupErrorState) {
              showToast(state.message);
            }
          })),
          BlocListener<MembershipBloc, MembershipState>(
              listenWhen: (previous, state) {
            return state is GetMembersInfoLoadingState ||
                state is GetMembersInfoSuccessState ||
                state is GetMembersInfoErrorState;
          }, listener: ((context, state) {
            if (state is GetMembersInfoSuccessState) {
              totalMembers.value = state.membersInfo;
              _getExpenses(groupId);
            } else if (state is GetGroupErrorState) {
              showToast(state.message);
            }
          })),
          BlocListener<TransactionalBloc, TransactionalState>(
              listenWhen: (previous, state) {
            return state is FetchExpensesStoreErrorState ||
                state is FetchExpensesStoreLoadingState ||
                state is FetchExpensesStoreSuccessState;
          }, listener: (context, state) {
            if (state is FetchExpensesStoreSuccessState) {
              hideLoading();
              listOfExpenses.value = state.expenses;
            } else if (state is FetchExpensesLoadingState) {
              showLoading();
            }
          })
        ],
        child: _body(),
      ),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 107,
            width: 107,
            decoration: const BoxDecoration(
                color: KxColors.neutral200, shape: BoxShape.circle),
            child: const Icon(
              CupertinoIcons.group_solid,
              size: 67,
              color: KxColors.neutral400,
            ),
          ).center(),
          BlocBuilder<MembershipBloc, MembershipState>(
            buildWhen: (context, state) {
              return state is GetGroupLoadingState ||
                  state is GetGroupSuccessState ||
                  state is GetGroupErrorState;
            },
            builder: (context, state) {
              if (state is GetGroupSuccessState) {
                return Column(
                  children: [
                    16.0.height,
                    Text(
                      state.group.name ?? "",
                      style: KxTypography(
                          type: KxFontType.subtitle3,
                          color: KxColors.neutral700),
                    ),
                    4.0.height,
                    Text(
                      state.group.groupDescription ?? "",
                      style: KxTypography(
                          type: KxFontType.caption1,
                          color: KxColors.neutral500),
                    ),
                    17.0.height,
                    ValueListenableBuilder(
                        valueListenable: totalMembers,
                        builder: (context, members, child) {
                          return InkWell(
                              onTap: () => Navigator.of(context).pushNamed(
                                  GroupMemberPage.routeName,
                                  arguments: members.reversed.toList()),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                decoration: const BoxDecoration(
                                    color: KxColors.neutral100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${totalMembers.value.length} Members",
                                      style: KxTypography(
                                          type: KxFontType.buttonSmall,
                                          color: KxColors.neutral700),
                                    ),
                                    4.0.width,
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 14,
                                    )
                                  ],
                                ),
                              ));
                        }),
                    20.0.height,
                    SegmentedControl(
                        activeColor: primaryGreen600,
                        onSelected: (index) {
                          selectedTab.value = index;

                          switch (selectedTab.value) {
                            case 1:
                              chargesFromGroup.clear();
                              _getCharges(
                                  groupId, totalMembers.value[0].id ?? "");
                              break;
                            case 2:
                              chargesFromGroup.clear();
                              _getCharges(
                                  groupId, totalMembers.value[0].id ?? "");

                              break;
                            default:
                              listOfExpenses.value.clear();
                              _getExpenses(groupId);
                              break;
                          }
                        },
                        title: segmentedTitles,
                        padding: 16,
                        initialIndex: 0,
                        currentIndex: selectedTab,
                        segmentType: SegmentedControlEnum.ghost),
                  ],
                );
              } else {
                return const SizedBox(
                  height: 40,
                  width: 40,
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
          16.0.height,
          ValueListenableBuilder(
            valueListenable: selectedTab,
            builder: (context, value, child) {
              switch (value) {
                // *BALANCE
                case 1:
                  return Column(
                    children: [
                      // *TOTAL EXPENSE

                      ValueListenableBuilder(
                          valueListenable: listOfExpenses,
                          builder: (context, expenses, child) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 10),
                                    decoration: const BoxDecoration(
                                        color: KxColors.neutral100,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Total Expense',
                                          style: KxTypography(
                                              type: KxFontType.body2,
                                              color: KxColors.neutral500),
                                        ),
                                        8.0.height,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "USDC",
                                              style: KxTypography(
                                                  type: KxFontType.subtitle4,
                                                  color: KxColors.neutral700),
                                            ),
                                            8.0.width,
                                            Text(
                                              "${_getTotalExpense(expenses)}0",
                                              style: KxTypography(
                                                  type: KxFontType.subtitle4,
                                                  color: KxColors.neutral700),
                                            ),
                                          ],
                                        )
                                      ],
                                    ).center(),
                                  ),
                                ),
                                const Divider(
                                  color: KxColors.neutral200,
                                  thickness: 4,
                                ),
                              ],
                            );
                          }),
                      20.0.height,
                      // * LIST OF BALANCES
                      BlocBuilder<TransactionalBloc, TransactionalState>(
                          buildWhen: (previous, state) {
                        return state is FetchChargesStoreSuccessState ||
                            state is FetchChargesStoreErrorState ||
                            state is FetchChargesStoreLoadingState;
                      }, builder: (context, state) {
                        if (state is FetchChargesStoreSuccessState) {
                          _getListOfCharges(chargesFromGroup, state.charges);
                          return Column(
                            children:
                                List.generate(chargesFromGroup.length, (index) {
                              final chargeParent = chargesFromGroup[index];
                              double totalCharge = 0;
                              String userId = '';

                              userId =
                                  _getChargeDetailsOnBalance(chargeParent)[0];
                              totalCharge =
                                  _getChargeDetailsOnBalance(chargeParent)[1];
                              return BalanceExpenseItemWidget(
                                isShowDivider: true,
                                title: _findMemberName(userId),
                                description:
                                    "Expense: ${totalCharge.toString()}0",
                                onTap: () {},
                                money: '-USDC${totalCharge}0',
                              );
                            }),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  );

                case 2:
                  return BlocBuilder<TransactionalBloc, TransactionalState>(
                      buildWhen: (previous, state) {
                    return state is FetchChargesStoreSuccessState ||
                        state is FetchChargesStoreErrorState ||
                        state is FetchChargesStoreLoadingState;
                  }, builder: (context, state) {
                    if (state is FetchChargesStoreSuccessState) {
                      _getListOfCharges(chargesFromGroup, state.charges);
                      return Column(children: _getBillsData(chargesFromGroup));
                    } else {
                      return const SizedBox();
                    }
                  });
                default:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pushNamed(
                            AddExpensePage.routeName,
                            arguments: widget.chatId),
                        child: const CustomMenuItemWidget(
                            icon: CircleIconWidget(
                              circleColor: KxColors.neutral50,
                              iconPath: IC_CREATE_EXPENSES,
                              iconPadding: 8,
                            ),
                            title: "Add New Expense"),
                      ),
                      BlocBuilder<TransactionalBloc, TransactionalState>(
                        buildWhen: (previous, state) {
                          return state is FetchExpensesStoreErrorState ||
                              state is FetchExpensesStoreLoadingState ||
                              state is FetchExpensesStoreSuccessState;
                        },
                        builder: (context, state) {
                          if (state is FetchExpensesStoreSuccessState) {
                            return Column(
                              children: List.generate(
                                  state.expenses.length,
                                  (index) => ExpenseItemWidget(
                                      amount:
                                          state.expenses[index].amount ?? "",
                                      tokenUnit:
                                          state.expenses[index].tokenUnit ?? "",
                                      isShowDivider: true,
                                      name: state.expenses[index].title ?? "",
                                      memberPayName: _getNameByWalletAddress(
                                          state.expenses[index].memberPayId ??
                                              ""),
                                      date: state.expenses[index].date ?? "",
                                      expenseType:
                                          state.expenses[index].category ??
                                              "default")),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      )
                    ],
                  );
              }
            },
          )
        ],
      ).padding(const EdgeInsets.symmetric(vertical: 24)),
    );
  }

  _getGroup() {
    context.read<MembershipBloc>().add(GetGroupEvent(widget.chatId));
  }

  _getMembers(List<String> ids) {
    context.read<MembershipBloc>().add(GetMembersEvent(ids));
  }

  _getExpenses(String groupId) {
    context.read<TransactionalBloc>().add(FetchExpensesStoreEvent(groupId));
  }

  _getListOfCharges(List<List<Map<String, dynamic>>> chargesFromGroup,
      List<Map<String, dynamic>> charges) {
    chargesFromGroup.add(charges);

    if (chargesFromGroup.length == totalMembers.value.length) {
    } else {
      _getCharges(
          groupId, totalMembers.value[chargesFromGroup.length].id ?? "");
    }
  }

  Future<void> _getUserData(String name) async {
    context.read<AuthBloc>().add(GetUserDataEvent(name));
  }

  List _getChargeDetailsOnBalance(List<Map<String, dynamic>> chargeParent) {
    String id = '';
    double amount = 0;
    List result = [];
    for (var data in chargeParent) {
      id = data["userId"];

      for (var detail in data["data"]) {
        amount += detail["amount"];
      }
    }
    result.add(id);
    result.add(amount);
    return result;
  }

  String _findMemberName(String id) {
    String name = '';
    for (UserProfile member in totalMembers.value) {
      if (id == member.id) {
        name = member.name ?? "";
      }
    }
    return name;
  }

  Future<void> _getCharges(String groupId, String userId) async {
    context
        .read<TransactionalBloc>()
        .add(FetchChargesStoreEvent(userId, groupId));
  }

  double _getTotalExpense(List<Expense> expenses) {
    double total = 0;
    for (var ex in expenses) {
      total += double.parse(ex.amount ?? "0");
    }
    return total;
  }

  String _getNameByWalletAddress(String memberPayId) {
    String membersPaidName = '';
    for (var members in totalMembers.value) {
      if (memberPayId == members.walletAddress) {
        membersPaidName = members.name ?? "";
      }
    }
    return membersPaidName;
  }

  List<Widget> _getBillsData(
      List<List<Map<String, dynamic>>> chargesFromGroup) {
    List<Widget> datas = [];
    for (List<Map<String, dynamic>> element in chargesFromGroup) {
      for (Map<String, dynamic> data in element) {
        String userId = data["userId"];
        for (var detail in data["data"]) {
          String payToId = detail["payTo"];
          double amount = detail["amount"];

          BalanceExpenseItemWidget billsWidget = BalanceExpenseItemWidget(
              title: _findMemberName(userId),
              description: "Should pay to ${_findMemberName(payToId)}",
              isShowDivider: true,
              onTap: () {},
              money: 'USDC ${amount}0');
          datas.add(billsWidget);
        }
      }
    }
    return datas;
  }
}
