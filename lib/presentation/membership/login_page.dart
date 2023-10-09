import 'package:cengli/presentation/home/home_page.dart';
import 'package:cengli/presentation/membership/pin_input_page.dart';
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
        body: MultiBlocListener(
            listeners: [
          BlocListener<AuthBloc, AuthState>(listenWhen: (previous, state) {
            return state is CreateWalletSuccessState ||
                state is CreateWalletLoadingState ||
                state is CreateWalletErrorState;
          }, listener: ((context, state) {
            if (state is CreateWalletSuccessState) {
              hideLoading();
              debugPrint("success create wallet");
              Navigator.of(context).pushNamedAndRemoveUntil(
                  PinInputPage.routeName, (route) => false);
            } else if (state is CreateWalletLoadingState) {
              showLoading();
            } else if (state is CreateWalletErrorState) {
              debugPrint("failed create wallet ${state.message}");
              hideLoading();
            }
          })),
        ],
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Username"),
                    KxFilledTextField(controller: controller),
                    const SizedBox(height: 30),
                    ElevatedButton(
                        onPressed: () => _login(), child: const Text("Login")),
                  ],
                ),
              ),
            )));
  }

  _login() async {
    context.read<AuthBloc>().add(CreateWalletEvent(controller.text));
  }
}
