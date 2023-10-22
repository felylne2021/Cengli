import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/presentation/group/components/user_item_widget.dart';
import 'package:cengli/presentation/home/home_tab_bar.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:cengli/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';

class CreateGroupPage extends StatefulWidget {
  final List<UserProfile> members;

  const CreateGroupPage({super.key, required this.members});
  static const String routeName = '/create_group_page';

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController tokenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tokenController.text = "CIDR";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarBackAndCenter(
          appbarTitle: "New Group",
          trailingWidgets: [
            InkWell(
              onTap: () {
                if (descController.text.isNotEmpty &&
                    nameController.text.isNotEmpty) {
                  _createGroup();
                } else {
                  showToast("Please fill all data");
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: primaryGreen600,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Create",
                  style: KxTypography(
                      type: KxFontType.buttonSmall, color: KxColors.neutral700),
                ),
              ),
            )
          ],
        ),
        body: MultiBlocListener(listeners: [
          BlocListener<TransactionalBloc, TransactionalState>(
              listenWhen: (previous, state) {
            return state is CreateGroupStoreLoadingState ||
                state is CreateGroupStoreSuccessState ||
                state is CreateGroupStoreErrorState;
          }, listener: ((context, state) {
            if (state is CreateGroupStoreSuccessState) {
              hideLoading();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeTabBarPage.routeName, (route) => false,
                  arguments: HomeTabBarPage.chatPage);
            } else if (state is CreateGroupStoreLoadingState) {
              showLoading();
            } else if (state is CreateGroupStoreErrorState) {
              showToast(state.message);
              hideLoading();
            }
          })),
        ], child: _body()));
  }

  Widget _body() {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        36.0.height,
        KxFilledTextField(
          controller: nameController,
          title: "Group Name",
          hint: "Type here",
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        16.0.height,
        KxFilledTextField(
          controller: tokenController,
          title: "Accepted Token",
          hint: "",
          prefix: SvgPicture.asset(
            IC_CIDR,
            width: 24,
          ).padding(const EdgeInsets.only(left: 16, right: 12)),
          isEnabled: false,
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        16.0.height,
        KxFilledTextField(
          controller: descController,
          title: "Description",
          hint: "Short description",
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        16.0.height,
        const Divider(
          color: KxColors.neutral200,
          thickness: 4,
        ),
        16.0.height,
        Text(
          "Participants",
          style: KxTypography(
              type: KxFontType.fieldText3, color: KxColors.neutral500),
        ).padding(const EdgeInsets.symmetric(horizontal: 16)),
        10.0.height,
        Column(
            children: List.generate(widget.members.length, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: UserItemWidget(
              isShowDivider: true,
              name: widget.members[index].name ?? "",
              username: widget.members[index].userName ?? "",
              address: widget.members[index].walletAddress ?? "",
              image: widget.members[index].imageProfile ?? "",
            ),
          );
        })).padding(const EdgeInsets.symmetric(horizontal: 16)),
      ],
    ).padding(const EdgeInsets.symmetric(vertical: 24)));
  }

  void _createGroup() async {
    final List<String> addressMembers = widget.members
        .map((value) => (push.pCAIP10ToWallet(value.walletAddress ?? "")))
        .toList();
    context.read<TransactionalBloc>().add(CreateGroupStoreEvent(Group(
        name: nameController.text,
        groupDescription: descController.text,
        members: addressMembers)));
  }
}
