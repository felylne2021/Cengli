import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.user});
  static const String routeName = '/edit_profile_page';
  final UserProfile user;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fullnameController.text = widget.user.name ?? "";
    userNameController.text = widget.user.userName ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(
        appbarTitle: 'Edit Profile',
        trailingWidgets: [
          SizedBox(
            width: 53,
            child: KxTextButton(
                argument: KxTextButtonArgument(
                    onPressed: () {
                      // TODO: save
                    },
                    buttonSize: KxButtonSizeEnum.small,
                    buttonType: KxButtonTypeEnum.primary,
                    buttonShape: KxButtonShapeEnum.round,
                    buttonContent: KxButtonContentEnum.text,
                    buttonText: 'Save',
                    buttonColor: primaryGreen600,
                    textColor: KxColors.neutral700)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                      color: KxColors.neutral200, shape: BoxShape.circle),
                  child: const Icon(
                    CupertinoIcons.person_fill,
                    color: KxColors.neutral400,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      //TODO: change picture
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: primaryGreen600,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Change",
                        style: KxTypography(
                            type: KxFontType.caption3,
                            color: KxColors.neutral700),
                      ),
                    ),
                  ),
                )
              ],
            ),
            24.0.height,
            _profileTextField('Fullname', fullnameController, false),
            _profileTextField('Username', userNameController, true)
          ],
        ).padding().center(),
      ),
    );
  }

  Widget _profileTextField(
      String title, TextEditingController controller, bool check) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: KxTypography(
              type: KxFontType.caption2, color: KxColors.neutral700),
        ),
        KxFilledTextField(
          controller: controller,
          suffix: !check
              ? const SizedBox()
              : InkWell(
                  onTap: () => _checkUsername(),
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
        ),
      ],
    );
  }

  _checkUsername() {
    context.read<AuthBloc>().add(CheckUsernameEvent(userNameController.text));
  }
}
