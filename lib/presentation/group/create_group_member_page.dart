import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/group/create_group_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../utils/utils.dart';
import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';
import 'components/user_item_widget.dart';

class CreateGroupMemberPage extends StatefulWidget {
  const CreateGroupMemberPage({super.key});
  static const String routeName = '/create_group_member_page';

  @override
  State<CreateGroupMemberPage> createState() => _CreateGroupMemberPageState();
}

class _CreateGroupMemberPageState extends State<CreateGroupMemberPage> {
  ValueNotifier<List<UserProfile>> members =
      ValueNotifier<List<UserProfile>>([]);
  ValueNotifier<UserProfile> userSearched = ValueNotifier(const UserProfile());
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarBackAndCenter(
          appbarTitle: "Group Member",
          trailingWidgets: [
            InkWell(
              onTap: () {
                if (members.value.isNotEmpty) {
                  Navigator.of(context).pushNamed(CreateGroupPage.routeName,
                      arguments: members.value);
                } else {
                  showToast("Members is empty");
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: primaryGreen600,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Next",
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
                return state is SearchUserSuccessState ||
                    state is SearchUserLoadingState ||
                    state is SearchUserErrorState;
              }, listener: ((context, state) {
                if (state is SearchUserSuccessState) {
                  hideLoading();
                  userSearched.value = state.user;
                } else if (state is SearchUserLoadingState) {
                  showLoading();
                } else if (state is SearchUserErrorState) {
                  showToast(state.message);
                  hideLoading();
                }
              })),
            ],
            child: SingleChildScrollView(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KxFilledTextField(
                  controller: controller,
                  hint: "Username or address",
                  suffix: InkWell(
                      onTap: () => _searchUser(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(
                            color: primaryGreen600,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text("Check",
                            style: KxTypography(
                                type: KxFontType.buttonMedium,
                                color: KxColors.neutral700)),
                      )),
                ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                20.0.height,
                ValueListenableBuilder(
                  valueListenable: userSearched,
                  builder: (context, value, child) {
                    return Visibility(
                        visible: value.name != null,
                        child: InkWell(
                                onTap: () {
                                  if (!members.value.contains(value)) {
                                    List<UserProfile> updatedList =
                                        List.from(members.value)..add(value);
                                    members.value = updatedList;
                                    userSearched.value = const UserProfile();
                                  }
                                },
                                child: UserItemWidget(
                                  name: value.name ?? "",
                                  username: value.userName ?? "",
                                  address: value.walletAddress ?? "",
                                  image: value.imageProfile ?? "",
                                ))
                            .padding(
                                const EdgeInsets.symmetric(horizontal: 16)));
                  },
                ),
                const Divider(
                  color: KxColors.neutral200,
                  thickness: 4,
                ),
                16.0.height,
                ValueListenableBuilder(
                  valueListenable: members,
                  builder: (context, value, child) {
                    return Text(
                      "Members ${value.length} of 10",
                      style: KxTypography(
                          type: KxFontType.fieldText3,
                          color: KxColors.neutral500),
                    ).padding(const EdgeInsets.symmetric(horizontal: 16));
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: members,
                  builder: (context, value, child) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                            value.length,
                            (index) => Dismissible(
                                key: Key(value[index].id ?? ""),
                                direction: DismissDirection.endToStart,
                                background: slideLeftBackground(),
                                onDismissed: (direction) {
                                  List<UserProfile> updatedList =
                                      List.from(members.value)
                                        ..remove(value[index]);
                                  members.value = updatedList;
                                },
                                child: UserItemWidget(
                                  name: value[index].name ?? "",
                                  username: value[index].userName ?? "",
                                  address: value[index].walletAddress ?? "",
                                  image: value[index].imageProfile ?? "",
                                  isShowDivider: true,
                                )))).visibility(value.isNotEmpty);
                  },
                )
              ],
            ).padding(const EdgeInsets.only(bottom: 24)))));
  }

  Widget slideLeftBackground() {
    return Container(
      color: KxColors.danger600,
      child: Text(
        "Remove",
        style: KxTypography(color: Colors.white, type: KxFontType.buttonMedium),
        textAlign: TextAlign.center,
      ).center(),
    );
  }

  Widget imageAndSmallCloseButton(
      String icon, String username, Function() removeCallback) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Stack(
        children: [
          Column(
            children: [
              if (icon.isNotEmpty)
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    icon,
                    fit: BoxFit.fitHeight,
                  ),
                )
              else
                Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: KxColors.neutral200),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: KxColors.neutral400,
                  ),
                ),
              8.0.height,
              Text(
                username,
              )
            ],
          ),
          Positioned(
            right: 1,
            child: InkWell(
              onTap: removeCallback,
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: KxColors.neutral200,
                ),
                child: const Icon(
                  CupertinoIcons.xmark,
                  color: KxColors.neutral700,
                  size: 12,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _searchUser() {
    context.read<MembershipBloc>().add(SearchUserEvent(true, controller.text));
  }
}
