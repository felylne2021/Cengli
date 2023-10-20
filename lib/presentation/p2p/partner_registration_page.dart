import 'package:cengli/presentation/p2p/kyc_page.dart';
import 'package:cengli/presentation/reusable/checkbox/general_checkbox.dart';
import 'package:cengli/utils/utils.dart';
import 'package:cengli/values/string.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../values/values.dart';
import '../reusable/appbar/custom_appbar.dart';

class PartnerRegistrationPage extends StatefulWidget {
  final UserProfile user;

  const PartnerRegistrationPage({super.key, required this.user});
  static const String routeName = '/partner_regist_page';

  @override
  State<PartnerRegistrationPage> createState() =>
      _PartnerRegistrationPageState();
}

class _PartnerRegistrationPageState extends State<PartnerRegistrationPage> {
  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> isValid = ValueNotifier(false);

    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: 'Partner Registration'),
        body: BlocListener<MembershipBloc, MembershipState>(
            listenWhen: (previous, state) {
              return state is RequestPartnerLoadingState ||
                  state is RequestPartnerSuccessState ||
                  state is RequestPartnerErrorState;
            },
            listener: (context, state) {
              if (state is RequestPartnerSuccessState) {
                hideLoading();
                Navigator.of(context).pop();
              } else if (state is RequestPartnerLoadingState) {
                showLoading();
              } else if (state is RequestPartnerErrorState) {
                hideLoading();
                showToast("Something is wrong");
              }
            },
            child: ExpandableNotifier(
                child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Become a Cengli Partner Today!",
                      style: KxTypography(
                          type: KxFontType.subtitle3,
                          color: KxColors.neutral700),
                    ),
                    8.0.height,
                    Text(
                      "Let’s elevate your impact by join our esteemed circle of partners and be at the forefront of crypto innovation in Indonesia.",
                      style: KxTypography(
                          type: KxFontType.body2, color: KxColors.neutral700),
                    ),
                    24.0.height,
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow:
                                KxShadowStyleEnum.elevationThree.getShadows(),
                            borderRadius: BorderRadius.circular(12)),
                        child: ScrollOnExpand(
                            scrollOnExpand: true,
                            scrollOnCollapse: false,
                            child: ExpandablePanel(
                                theme: const ExpandableThemeData(
                                    iconColor: KxColors.neutral700,
                                    iconPadding: EdgeInsets.all(16)),
                                header: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(
                                      "Terms and Conditions",
                                      style: KxTypography(
                                          type: KxFontType.subtitle3,
                                          color: KxColors.neutral700),
                                    )),
                                collapsed: const SizedBox(),
                                expanded: Html(data: privacyHtml).padding(
                                    const EdgeInsets.symmetric(
                                        horizontal: 10))))),
                    24.0.height,
                    GeneralCheckbox(
                        shape: const CircleBorder(),
                        onChanged: (value) {
                          isValid.value = value == true;
                        },
                        checkboxWidget: RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'I Acknowledge that I have read and understood the',
                                  style: KxTypography(
                                      type: KxFontType.fieldText3,
                                      color: KxColors.neutral500)),
                              TextSpan(
                                  text: 'Terms & Conditions',
                                  style: KxTypography(
                                      type: KxFontType.buttonSmall,
                                      color: KxColors.neutral700)),
                            ],
                          ),
                        )),
                    40.0.height,
                    ValueListenableBuilder(
                      valueListenable: isValid,
                      builder: (context, value, child) {
                        return KxTextButton(
                                isDisabled: !value,
                                argument: KxTextButtonArgument(
                                    onPressed: () => Navigator.of(context)
                                            .pushNamed(KycPage.routeName)
                                            .then((value) {
                                          if (value != null) {
                                            //TODO: approve
                                          }
                                        }),
                                    buttonText: "Submit",
                                    buttonColor: primaryGreen600,
                                    buttonTextStyle: KxTypography(
                                        type: KxFontType.buttonMedium,
                                        color: value
                                            ? KxColors.neutral700
                                            : KxColors.neutral500),
                                    buttonSize: KxButtonSizeEnum.medium,
                                    buttonType: KxButtonTypeEnum.primary,
                                    buttonShape: KxButtonShapeEnum.square,
                                    buttonContent: KxButtonContentEnum.text))
                            .padding(
                                const EdgeInsets.symmetric(horizontal: 16));
                      },
                    ),
                  ],
                ).padding(const EdgeInsets.fromLTRB(16, 16, 16, 36)),
              ],
            ))));
  }

  _requestRegistration(String walletAddress) {
    context.read<MembershipBloc>().add(RequestPartnerEvent(walletAddress));
  }
}
