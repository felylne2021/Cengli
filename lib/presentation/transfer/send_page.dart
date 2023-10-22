import 'package:cengli/presentation/group/components/user_item_widget.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/presentation/transfer/send_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../bloc/membership/membership.dart';
import '../../data/modules/auth/model/user_profile.dart';
import '../../values/values.dart';
import '../reusable/page/qr_scan_page.dart';

class SendPage extends StatefulWidget {
  final SendArgument argument;
  const SendPage({super.key, required this.argument});

  @override
  State<SendPage> createState() => _SendPageState();
  static const String routeName = '/send_page';
}

class _SendPageState extends State<SendPage> {
  TextEditingController controller = TextEditingController();
  ValueNotifier<bool> isValid = ValueNotifier(false);
  ValueNotifier<UserProfile> userProfile = ValueNotifier(const UserProfile());

  bool isValidEth = false;
  bool isUsername = false;
  int length = 0;

  @override
  void initState() {
    super.initState();
    controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTextChange() async {
    if ((controller.text.length - length).abs() > 1) {
      _validate(controller.text);
    }
    length = controller.text.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbarWithBackButton(appbarTitle: "Transfer"),
      body: BlocListener<MembershipBloc, MembershipState>(
          listenWhen: (previous, state) {
        return state is SearchUserSuccessState ||
            state is SearchUserLoadingState ||
            state is SearchUserErrorState;
      }, listener: ((context, state) {
        if (state is SearchUserSuccessState) {
          userProfile.value = state.user;
          isValid.value = true;
        } else if (state is SearchUserErrorState) {
          userProfile.value = const UserProfile();
          if (!controller.text.startsWith('0x')) {
            isValid.value = false;
          } else {
            isValid.value = true;
          }
        }
      }), child: LayoutBuilder(
        builder: (_, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                  child: Column(
                children: [
                  KxFilledTextField(
                    controller: controller,
                    title: "Receiver Address",
                    hint: "Username or address",
                    onChanged: (value) {
                      _validate(value);
                    },
                    suffix: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(QrScanPage.routeName)
                            .then((value) {
                          if (value != null && value is String) {
                            controller.text = value.toString();
                            _validate(value);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: SvgPicture.asset(IC_QR_CODE),
                      ),
                    ),
                  ),
                  13.0.height,
                  ValueListenableBuilder(
                    valueListenable: userProfile,
                    builder: (context, value, child) {
                      if (value.userName != null) {
                        return UserItemWidget(
                          name: value.name ?? "",
                          username: value.userName ?? "",
                          address: value.walletAddress ?? "",
                          image: value.imageProfile ?? "",
                        );
                      } else {
                        if (isValidEth) {
                          return Row(
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryGreen600),
                                alignment: Alignment.center,
                                child: Text("0x",
                                    style: KxTypography(
                                        type: KxFontType.buttonMedium,
                                        color: KxColors.neutral700)),
                              ),
                              16.0.width,
                              Text(controller.text,
                                      style: KxTypography(
                                          type: KxFontType.buttonMedium,
                                          color: KxColors.neutral700))
                                  .flexible()
                            ],
                          );
                        }
                        return const SizedBox();
                      }
                    },
                  ),
                  const Spacer(),
                  ValueListenableBuilder(
                    valueListenable: isValid,
                    builder: (context, value, child) {
                      return KxTextButton(
                              isDisabled: !value,
                              argument: KxTextButtonArgument(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(SendDetailPage.routeName,
                                          arguments: SendArgument(
                                            widget.argument.senderChain,
                                            widget.argument.senderChain,
                                            widget.argument.selectedAsset,
                                            widget.argument.assets,
                                            userProfile.value ==
                                                    const UserProfile()
                                                ? UserProfile(
                                                    walletAddress:
                                                        controller.text)
                                                : userProfile.value,
                                            1,
                                          )),
                                  buttonText: "Transfer",
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
                          .padding(const EdgeInsets.symmetric(horizontal: 16));
                    },
                  ),
                ],
              ).padding(const EdgeInsets.fromLTRB(16, 16, 16, 36))),
            ),
          );
        },
      )),
    );
  }

  _validate(String value) {
    if (value.startsWith("0x")) {
      if (isETHAddress(value)) {
        isValidEth = true;
        isUsername = false;
        isValid.value = true;
        _searchUser(false);
      } else {
        debugPrint("not valid");
        isValid.value = false;
      }
    } else {
      debugPrint("not valid start");
      isValidEth = false;
      isUsername = true;
      _searchUser(true);
    }
  }

  bool isETHAddress(String address) {
    if (!address.startsWith('0x')) {
      return false;
    }
    if (address.length != 42) {
      return false;
    }

    final validChars = RegExp(r'^[0-9a-fA-F]{40}$');
    return validChars.hasMatch(address.substring(2));
  }

  _searchUser(bool isUsername) {
    context
        .read<MembershipBloc>()
        .add(SearchUserEvent(isUsername, controller.text));
  }
}
