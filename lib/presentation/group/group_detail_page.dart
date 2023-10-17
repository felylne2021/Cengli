import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/presentation/chat/expense/add_expense_page.dart';
import 'package:cengli/presentation/group/components/expense_item_widget.dart';
import 'package:cengli/presentation/group/group_member_page.dart';
import 'package:cengli/presentation/reusable/menu/custom_menu_item_widget.dart';
import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../bloc/transactional/state_remote/fetch_charges_store_state.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../data/modules/transactional/model/expense.dart';
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
  List<Map<String, dynamic>> chargesFromGroup = [];

  @override
  void initState() {
    super.initState();
    _getGroup();
    chargesFromGroup.clear();
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
              _getExpenses(groupId);
              //TODO: refactor
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
            } else if (state is GetGroupErrorState) {
              showToast(state.message);
            }
          })),
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
                  ],
                );
              } else {
                return const SizedBox(
                    height: 40, width: 40, child: CupertinoActivityIndicator());
              }
            },
          ),
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
                          borderRadius: BorderRadius.all(Radius.circular(20))),
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
              },
              title: segmentedTitles,
              padding: MediaQuery.of(context).size.width / 30,
              initialIndex: 0,
              segmentType: SegmentedControlEnum.ghost),
          16.0.height,
          ValueListenableBuilder(
            valueListenable: selectedTab,
            builder: (context, value, child) {
              switch (value) {
                // *BALANCE
                case 1:
                  return Column(
                    children: [
                      //* TOTAL EXPENSES
                      BlocBuilder<TransactionalBloc, TransactionalState>(
                        buildWhen: (previous, state) {
                          return state is FetchExpensesStoreErrorState ||
                              state is FetchExpensesStoreLoadingState ||
                              state is FetchExpensesStoreSuccessState;
                        },
                        builder: (context, state) {
                          if (state is FetchExpensesStoreSuccessState) {
                            final listOfExpenses = state.expenses;

                            //TODO: refactor
                            // for (var user in totalMembers.value) {
                            //   _getCharges(groupId, user.id ?? "");
                            // }

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 10),
                                decoration: const BoxDecoration(
                                    color: KxColors.neutral100,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
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
                                          listOfExpenses[0].tokenUnit ?? "",
                                          style: KxTypography(
                                              type: KxFontType.subtitle4,
                                              color: KxColors.neutral700),
                                        ),
                                        8.0.width,
                                        Text(
                                          "${_getTotalExpense(listOfExpenses)}0",
                                          style: KxTypography(
                                              type: KxFontType.subtitle4,
                                              color: KxColors.neutral700),
                                        ),
                                      ],
                                    )
                                  ],
                                ).center(),
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: primaryGreen600,
                              ),
                            );
                          }
                        },
                      ),

                      20.0.height,

                      BlocBuilder<TransactionalBloc, TransactionalState>(
                          buildWhen: (previous, state) {
                        return state is FetchChargesStoreSuccessState ||
                            state is FetchChargesStoreErrorState ||
                            state is FetchChargesStoreLoadingState;
                      }, builder: (context, state) {
                        if (state is FetchChargesStoreSuccessState) {
                          chargesFromGroup.add(state.charges);
                          print(chargesFromGroup);
                          return const SizedBox();
                        } else {
                          return const SizedBox();
                        }
                      }),
                    ],
                  );

                case 2:
                  return Container();
                default:
                  return BlocBuilder<MembershipBloc, MembershipState>(
                    buildWhen: (context, state) {
                      return state is GetMembersInfoLoadingState ||
                          state is GetMembersInfoSuccessState ||
                          state is GetMembersInfoErrorState;
                    },
                    builder: (context, state) {
                      if (state is GetMembersInfoSuccessState) {
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
                                            amount: state.expenses[index].amount ??
                                                "",
                                            tokenUnit:
                                                state.expenses[index].tokenUnit ??
                                                    "",
                                            isShowDivider: true,
                                            name: state.expenses[index].title ??
                                                "",
                                            memberPayName:
                                                _getNameByWalletAddress(state
                                                        .expenses[index]
                                                        .memberPayId ??
                                                    ""),
                                            date: state.expenses[index].date ??
                                                "",
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
                      } else {
                        return const CupertinoActivityIndicator();
                      }
                    },
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

  _getCharges(String groupId, String userId) {
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
}
