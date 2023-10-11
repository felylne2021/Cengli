import 'package:cengli/bloc/transactional/transactional.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/data/modules/transactional/model/group.dart';
import 'package:cengli/presentation/group/components/user_item_widget.dart';
import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/services/push_protocol/push_restapi_dart.dart' as push;
import 'package:cengli/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: KxAppBarCenterTitle(
          elevationType: KxElevationAppBarEnum.ghost,
          appBarTitle: "New Group",
          leadingCallback: () => Navigator.of(context).pop(),
          leadingWidget: const Icon(CupertinoIcons.chevron_left_circle_fill),
          trailingWidgets: [
            InkWell(
              onTap: () {
                if (descController.text.isNotEmpty ||
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
                    color: KxColors.auxiliary700,
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
                  HomePage.routeName, (route) => false);
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
              child: Column(
                children: [
                  UserItemWidget(
                      name: widget.members[index].name ?? "",
                      username: widget.members[index].userName ?? "",
                      address: widget.members[index].walletAddress ?? ""),
                  12.0.height,
                  const Divider(thickness: 1, color: KxColors.neutral200)
                ],
              ));
        })).padding(const EdgeInsets.symmetric(horizontal: 16)),
      ],
    ).padding(const EdgeInsets.symmetric(vertical: 24)));
  }

  void _createGroup() async {
    final List<String> addressMembers = widget.members
        .map((value) => (push.pCAIP10ToWallet(value.walletAddress ?? "")))
        .toList();
    debugPrint(addressMembers.toString());
    context.read<TransactionalBloc>().add(CreateGroupStoreEvent(Group(
        name: nameController.text,
        groupDescription: descController.text,
        members: addressMembers)));
  }
}
