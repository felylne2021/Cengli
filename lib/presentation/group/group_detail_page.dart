import 'package:cengli/presentation/reusable/menu/custom_menu_item_widget.dart';
import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:cengli/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';
import '../reusable/segmented_control/segmented_control.dart';
import 'components/user_item_widget.dart';

class GroupDetailPage extends StatefulWidget {
  final String chatId;

  const GroupDetailPage({super.key, required this.chatId});
  static const String routeName = '/group_detail_page';

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  List<String> segmentedTitles = ['Members', 'Expenses', 'Bills'];
  ValueNotifier<int> selectedTab = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _getGroup();
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
        body: MultiBlocListener(listeners: [
          BlocListener<MembershipBloc, MembershipState>(
              listenWhen: (previous, state) {
            return state is GetGroupLoadingState ||
                state is GetGroupSuccessState ||
                state is GetGroupErrorState;
          }, listener: ((context, state) {
            if (state is GetGroupSuccessState) {
              debugPrint(state.group.toString());
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
              debugPrint(state.membersInfo.toString());
            } else if (state is GetGroupErrorState) {
              showToast(state.message);
            }
          }))
        ], child: _body()));
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
              debugPrint(state.toString());
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
                    38.0.height,
                  ],
                );
              } else {
                return const SizedBox(
                    height: 40, width: 40, child: CupertinoActivityIndicator());
              }
            },
          ),
          SegmentedControl(
                  activeColor: primaryGreen600,
                  onSelected: (index) {
                    selectedTab.value = index;
                  },
                  title: segmentedTitles,
                  padding: MediaQuery.of(context).size.width / 30,
                  initialIndex: 0,
                  segmentType: SegmentedControlEnum.ghost)
              .center(),
          16.0.height,
          ValueListenableBuilder(
            valueListenable: selectedTab,
            builder: (context, value, child) {
              switch (value) {
                case 1:
                  return Container();
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
                        return Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Members",
                              style: KxTypography(
                                  type: KxFontType.fieldText3,
                                  color: KxColors.neutral500),
                            ).padding(
                                const EdgeInsets.symmetric(horizontal: 16)),
                            const CustomMenuItemWidget(
                                icon: CircleIconWidget(
                                  circleColor: KxColors.neutral50,
                                  iconPath: IC_ADD,
                                  iconPadding: 8,
                                ),
                                title: "Add Members"),
                            Column(
                              children: List.generate(
                                  state.membersInfo.length,
                                  (index) => UserItemWidget(
                                      isShowDivider: true,
                                      name: state.membersInfo[index].name ?? "",
                                      username:
                                          state.membersInfo[index].userName ??
                                              "",
                                      address: state.membersInfo[index]
                                              .walletAddress ??
                                          "")),
                            ).padding(
                                const EdgeInsets.symmetric(horizontal: 16))
                          ],
                        ));
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
}
