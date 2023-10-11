import 'package:cengli/presentation/membership/pin_input_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';
export 'package:kinetix/extensions/kx_widget_ext.dart';

import '../../bloc/auth/auth.dart';
import '../../utils/widget_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = '/login_page';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: KxAppBarCenterTitle(
            elevationType: KxElevationAppBarEnum.ghost,
            appBarTitle: "Create Account",
            leadingWidget: const Icon(
              CupertinoIcons.chevron_left_circle,
              color: KxColors.neutral700,
            ),
            leadingCallback: () => Navigator.of(context).pop()),
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
                    showToast("Username already exist");
                  } else {
                    Navigator.of(context).pushNamed(PinInputPage.routeName,
                        arguments: PinInputArgument(
                            PinPurpose.login, controller.text));
                  }
                } else if (state is CheckUsernameLoadingState) {
                  showLoading();
                } else if (state is CheckUsernameErrorState) {
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
                    ),
                    const SizedBox(height: 30),
                    const Spacer(),
                    KxTextButton(
                            argument: KxTextButtonArgument(
                                onPressed: () => _checkUsername(),
                                buttonText: "Continue",
                                buttonColor: KxColors.auxiliary400,
                                buttonTextStyle: KxTypography(
                                    type: KxFontType.buttonMedium,
                                    color: KxColors.neutral700),
                                buttonSize: KxButtonSizeEnum.medium,
                                buttonType: KxButtonTypeEnum.primary,
                                buttonShape: KxButtonShapeEnum.square,
                                buttonContent: KxButtonContentEnum.text))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                  ],
                ),
              ),
            )));
  }

  _checkUsername() {
    context.read<AuthBloc>().add(CheckUsernameEvent(controller.text));
  }
}
