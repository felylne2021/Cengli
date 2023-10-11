import 'package:cengli/presentation/group/create_group_member_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class ChatNewPage extends StatelessWidget {
  const ChatNewPage({super.key});
  static const String routeName = '/chat_new_page';

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
        appBar: KxAppBarCenterTitle(
          elevationType: KxElevationAppBarEnum.ghost,
          appBarTitle: "New Message",
          leadingCallback: () => Navigator.of(context).pop(),
          leadingWidget: const Icon(CupertinoIcons.chevron_left_circle_fill),
        ),
        body: Column(
          children: [
            KxFilledTextField(
              controller: controller,
              hint: "Username or address",
            ),
            12.0.height,
            InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed(CreateGroupMemberPage.routeName),
              child: KxList(
                  argument: KxListArgument(
                      title: "Create Group",
                      listType: KxListTypeEnum.ghost,
                      contentType: KxListContentEnum.leadingIcon,
                      textType: KxListTextEnum.text)),
            ),
            KxList(
                argument: KxListArgument(
                    title: "New Contact",
                    listType: KxListTypeEnum.ghost,
                    contentType: KxListContentEnum.leadingIcon,
                    textType: KxListTextEnum.text))
          ],
        ).padding(const EdgeInsets.symmetric(vertical: 24, horizontal: 16)));
  }
}
