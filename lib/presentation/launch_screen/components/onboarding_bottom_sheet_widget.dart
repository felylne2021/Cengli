import 'package:cengli/presentation/launch_screen/onboarding_screen.dart';
import 'package:cengli/presentation/membership/login_page.dart';
import 'package:cengli/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class OnboardingBottomSheetWidget extends StatelessWidget {
  final List<OnboardingItem> items;
  final Function(int) callback;

  const OnboardingBottomSheetWidget(
      {super.key, required this.items, required this.callback});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<int> activeIndex = ValueNotifier(0);
    final PageController controller = PageController();

    return Container(
        padding: const EdgeInsets.only(top: 12, bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            40.0.height,
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: PageView(
                controller: controller,
                onPageChanged: ((value) {
                  activeIndex.value = value;
                  callback(value);
                }),
                children: List.generate(
                  items.length,
                  (index) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        items[index].title,
                        style: CengliTypography(
                            type: CengliFontType.subtitle2,
                            color: KxColors.neutral700),
                        textAlign: TextAlign.start,
                      ).padding(const EdgeInsets.symmetric(horizontal: 16)),
                      const SizedBox(height: 19),
                      Text(
                        items[index].caption,
                        style: KxTypography(
                            type: KxFontType.body2, color: KxColors.neutral500),
                        textAlign: TextAlign.start,
                      ).padding(const EdgeInsets.symmetric(horizontal: 16))
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
                            buttonText: value < 3 ? "Next" : "Login",
                            buttonColor: KxColors.neutral700,
                            buttonTextStyle: KxTypography(
                                type: KxFontType.buttonMedium,
                                color: Colors.white),
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
