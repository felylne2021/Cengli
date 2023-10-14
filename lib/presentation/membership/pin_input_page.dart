import 'package:cengli/bloc/auth/auth.dart';
import 'package:cengli/presentation/home/home_tab_bar.dart';
import 'package:cengli/presentation/reusable/appbar/custom_appbar.dart';
import 'package:cengli/services/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinetix/kinetix.dart';

import '../../utils/widget_util.dart';
import '../../values/values.dart';

enum PinPurpose { login, payment }

class PinInputArgument {
  final PinPurpose pinPurpose;
  final String? username;

  PinInputArgument(this.pinPurpose, this.username);
}

class PinInputPage extends StatefulWidget {
  final PinInputArgument argument;

  const PinInputPage({super.key, required this.argument});
  static const String routeName = '/pin_input_page';

  @override
  State<PinInputPage> createState() => _PinInputPageState();
}

class _PinInputPageState extends State<PinInputPage> {
  final focusNode = FocusNode();

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
            return state is CreateWalletSuccessState ||
                state is CreateWalletLoadingState ||
                state is CreateWalletErrorState;
          }, listener: ((context, state) {
            if (state is CreateWalletSuccessState) {
              hideLoading();
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
        child: Scaffold(
          appBar: CustomAppbarWithBackButton(appbarTitle: "Enter Pin"),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: index < controller.text.length
                              ? Colors.black
                              : Colors.transparent,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      );
                    }),
                  ),
                  TextField(
                    focusNode: focusNode,
                    showCursor: false,
                    controller: controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 6,
                    style: const TextStyle(
                        color: Colors.transparent, fontSize: 18),
                    decoration: const InputDecoration(
                      counterText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ],
              ),
              const Spacer(),
              KxTextButton(
                      argument: KxTextButtonArgument(
                          onPressed: () => _didTapSubmit(),
                          buttonText: "Submit",
                          buttonColor: primaryGreen600,
                          buttonTextStyle: KxTypography(
                              type: KxFontType.buttonMedium,
                              color: KxColors.neutral700),
                          buttonSize: KxButtonSizeEnum.medium,
                          buttonType: KxButtonTypeEnum.primary,
                          buttonShape: KxButtonShapeEnum.square,
                          buttonContent: KxButtonContentEnum.text))
                  .padding(const EdgeInsets.symmetric(horizontal: 16)),
              36.0.height,
            ],
          ),
        ));
  }

  _login() async {
    context
        .read<AuthBloc>()
        .add(CreateWalletEvent(widget.argument.username ?? ""));
  }

  _didTapSubmit() {
    if (controller.text.length == 6) {
      switch (widget.argument.pinPurpose) {
        case PinPurpose.login:
          focusNode.unfocus();
          SessionService.setPin(controller.text);
          _login();
          break;
        case PinPurpose.payment:
          // TODO: Handle this case.
          break;
      }
    }
  }
}
