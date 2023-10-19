
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/services/biometric_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';
export 'package:kinetix/extensions/kx_widget_ext.dart';

import '../../bloc/auth/auth.dart';
import '../../services/services.dart';
import '../../utils/widget_util.dart';
import '../../values/values.dart';
import '../home/home_tab_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = '/login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();
  ValueNotifier<bool> isValid = ValueNotifier(false);
  ValueNotifier<String> errorMessage = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppbarWithBackButton(appbarTitle: "Create Account"),
        body: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is CheckUsernameSuccessState ||
                    state is CheckUsernameLoadingState ||
                    state is CheckUsernameErrorState;
              }, listener: ((context, state) {
                if (state is CheckUsernameSuccessState) {
                  hideLoading();
                  if (state.isExist) {
                    errorMessage.value = "This username is taken";
                    isValid.value = false;
                  } else {
                    errorMessage.value = "Username Available";
                    isValid.value = true;
                  }
                } else if (state is CheckUsernameLoadingState) {
                  showLoading();
                } else if (state is CheckUsernameErrorState) {
                  showToast(state.message);
                  hideLoading();
                }
              })),
              BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
                return state is CreateWalletSuccessState ||
                    state is CreateWalletLoadingState ||
                    state is CreateWalletErrorState;
              }, listener: ((context, state) {
                if (state is CreateWalletSuccessState) {
                  hideLoading();
                  SessionService.setUsername(controller.text);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeTabBarPage.routeName, (route) => false);
                } else if (state is CreateWalletLoadingState) {
                  showLoading();
                } else if (state is CreateWalletErrorState) {
                  showToast(state.message);
                  hideLoading();
                }
              })),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KxFilledTextField(
                      title: "Make your username for your Cengli Account",
                      controller: controller,
                      hint: "Username",
                      suffix: InkWell(
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
                    ValueListenableBuilder(
                      valueListenable: errorMessage,
                      builder: (context, value, child) {
                        return Text(value,
                                style: KxTypography(
                                    type: KxFontType.caption2,
                                    color: value.contains("taken")
                                        ? darkYellow
                                        : successGreen))
                            .padding(const EdgeInsets.only(top: 8));
                      },
                    ),
                    30.0.height,
                    const Spacer(),
                    ValueListenableBuilder(
                      valueListenable: isValid,
                      builder: (context, value, child) {
                        return KxTextButton(
                                isDisabled: !value,
                                argument: KxTextButtonArgument(
                                    onPressed: () async {
                                      bool isApprove = await BiometricService
                                          .authenticateWithBiometrics();
                                      debugPrint(isApprove.toString());
                                      if (isApprove) {
                                        _login();
                                      }
                                    },
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
                    20.0.height,
                  ],
                ),
              ),
            )));
  }

  _checkUsername() {
    context.read<AuthBloc>().add(CheckUsernameEvent(controller.text));
  }

  _login() async {
    context.read<AuthBloc>().add(CreateWalletEvent(controller.text));
  }
}
