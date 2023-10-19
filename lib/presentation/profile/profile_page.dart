import 'package:cengli/bloc/auth/state/get_user_state.dart';
import 'package:cengli/data/modules/auth/model/user_profile.dart';
import 'package:cengli/presentation/profile/components/account_details_page.dart';
import 'package:cengli/presentation/profile/components/profile_menu_widget.dart';
import 'package:cengli/presentation/profile/edit/edit_profile_page.dart';
import 'package:dartx/dartx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/auth/auth.dart';
import '../../values/values.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const String routeName = '/profile_page';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: KxAppBarLeftTitle(
              elevationType: KxElevationAppBarEnum.ghost,
              appBarTitle: 'Profile',
              trailingWidgets: [
                InkWell(
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: KxColors.neutral200,
                    child: SvgPicture.asset(
                      IC_SETTINGS,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, state) {
            return state is GetUserDataLoadingState ||
                state is GetUserDataErrorState ||
                state is GetUserDataSuccessState;
          },
          builder: (context, state) {
            if (state is GetUserDataSuccessState) {
              return _profileBody(state.user);
            } else if (state is GetUserDataLoadingState) {
              return Center(
                child: CircularProgressIndicator(
                  color: primaryGreen600,
                ),
              );
            } else if (state is GetUserDataErrorState) {
              return SizedBox(
                child: Text(state.error).center(),
              );
            } else {
              return const SizedBox();
            }
          },
        ).padding().center());
  }

  Column _profileBody(UserProfile user) {
    final imageProfile = user.imageProfile ?? "";
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            if (imageProfile.isNotNullOrEmpty)
              Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    imageProfile,
                    fit: BoxFit.cover,
                  ))
            else
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
                  //TODO: edit
                  Navigator.of(context)
                      .pushNamed(EditProfilePage.routeName, arguments: user);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: primaryGreen600,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Edit",
                    style: KxTypography(
                        type: KxFontType.caption3, color: KxColors.neutral700),
                  ),
                ),
              ),
            )
          ],
        ),
        16.0.height,
        Text(
          user.name ?? "",
          style: KxTypography(
              type: KxFontType.subtitle4, color: KxColors.neutral700),
        ),
        4.0.height,
        Text(
          user.userName ?? "",
          style: KxTypography(
              type: KxFontType.caption2, color: KxColors.neutral500),
        ),
        18.0.height,
        ProfileMenuWidget(
          title: 'Account Details',
          description: 'Email and phone number',
          imagePath: IC_PROFILE_ACCOUNT,
          onTap: () => Navigator.of(context)
              .pushNamed(AccountDetailsPage.routeName, arguments: user),
          isShowDivider: true,
        ),
      ],
    );
  }
}
