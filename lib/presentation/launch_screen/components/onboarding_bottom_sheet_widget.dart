import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/login_page.dart';
import 'package:cengli/presentation/reusable/shapes/drag_handle_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:kinetix/kinetix.dart';

import '../../../values/values.dart';

class OnboardingBottomSheetWidget extends StatelessWidget {
  final List<OnboardingItem> items;

  const OnboardingBottomSheetWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> activeIndex = ValueNotifier(0);
    final PageController controller = PageController();

    return Container(
        padding: const EdgeInsets.only(top: 12, bottom: 60),
        height: 0.5 * MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DragHandleWidget(),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: ((value) => activeIndex.value = value),
                children: List.generate(
                  items.length,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        items[index].title,
                        style: KxTypography(
                            type: KxFontType.subtitle1,
                            color: KxColors.neutral700),
                        textAlign: TextAlign.center,
                      ).padding(const EdgeInsets.symmetric(horizontal: 44)),
                      const SizedBox(height: 19),
                      Text(
                        items[index].caption,
                        style: KxTypography(
                            type: KxFontType.body2, color: KxColors.neutral500),
                        textAlign: TextAlign.center,
                      ).padding(const EdgeInsets.symmetric(horizontal: 44))
                    ],
                  ),
                ),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: activeIndex,
              builder: (context, value, child) {
                return KxTextButton(
                        argument: KxTextButtonArgument(
                            onPressed: () {
                              if (value < 3) {
                                activeIndex.value += 1;
                                controller.animateToPage(
                                  activeIndex.value,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.of(context)
                                    .pushNamed(LoginPage.routeName);
                              }
                            },
                            buttonText: value < 3 ? "Continue" : "Login",
                            buttonColor: primaryGreen600,
                            buttonTextStyle: KxTypography(
                                type: KxFontType.buttonMedium,
                                color: KxColors.neutral700),
                            buttonSize: KxButtonSizeEnum.medium,
                            buttonType: KxButtonTypeEnum.primary,
                            buttonShape: KxButtonShapeEnum.square,
                            buttonContent: KxButtonContentEnum.text))
                    .padding(const EdgeInsets.symmetric(horizontal: 22));
              },
            )
          ],
        ));
  }
}
