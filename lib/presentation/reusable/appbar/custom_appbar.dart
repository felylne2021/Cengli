import 'package:cengli/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppbar(
      {super.key,
      required this.appbarTitle,
      this.leadingWidget,
      this.leadingCallback,
      this.trailingWidgets})
      : preferredSize = const Size.fromHeight(105);

  final String appbarTitle;
  final Widget? leadingWidget;
  final Function()? leadingCallback;
  final List<Widget>? trailingWidgets;

  @override
  Size preferredSize;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      alignment: Alignment.center,
      children: [
        KxAppBarCenterTitle(
          elevationType: KxElevationAppBarEnum.ghost,
          appBarTitle: "",
          leadingWidget: leadingWidget ?? const SizedBox(),
          leadingCallback: leadingCallback ?? () {},
          trailingWidgets: trailingWidgets,
        ),
        Text(appbarTitle,
            style: CengliTypography(
                type: CengliFontType.subtitle4, color: KxColors.neutral700)),
      ],
    ).padding(const EdgeInsets.only(top: 25)));
  }
}

class CustomAppbarBackAndCenter extends StatelessWidget
    implements PreferredSizeWidget {
  CustomAppbarBackAndCenter(
      {super.key, required this.appbarTitle, this.trailingWidgets})
      : preferredSize = const Size.fromHeight(70);

  final String appbarTitle;
  final List<Widget>? trailingWidgets;

  @override
  Size preferredSize;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      alignment: Alignment.center,
      children: [
        KxAppBarCenterTitle(
          elevationType: KxElevationAppBarEnum.ghost,
          appBarTitle: "",
          leadingWidget: const CircleAvatar(
            radius: 15,
            backgroundColor: KxColors.neutral200,
            child: Icon(
              Icons.chevron_left_rounded,
              color: KxColors.neutral700,
            ),
          ).padding(const EdgeInsets.only(right: 10)),
          leadingCallback: () => Navigator.of(context).pop(),
          trailingWidgets: trailingWidgets,
        ),
        Text(appbarTitle,
            style: CengliTypography(
                type: CengliFontType.subtitle4, color: KxColors.neutral700))
      ],
    ));
  }
}

class CustomAppbarWithBackButton extends StatelessWidget
    implements PreferredSizeWidget {
  CustomAppbarWithBackButton(
      {super.key, required this.appbarTitle, this.trailingWidgets})
      : preferredSize = const Size.fromHeight(70);
  final String appbarTitle;
  final List<Widget>? trailingWidgets;
  @override
  Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      alignment: Alignment.center,
      children: [
        KxAppBarCenterTitle(
          elevationType: KxElevationAppBarEnum.ghost,
          appBarTitle: "",
          leadingWidget: const CircleAvatar(
            radius: 15,
            backgroundColor: KxColors.neutral200,
            child: Icon(
              Icons.chevron_left_rounded,
              color: KxColors.neutral700,
            ),
          ),
          leadingCallback: () => Navigator.of(context).canPop()
              ? Navigator.of(context).pop()
              : null,
          trailingWidgets: trailingWidgets,
        ),
        Text(appbarTitle,
            style: CengliTypography(
                type: CengliFontType.subtitle4, color: KxColors.neutral700))
      ],
    ));
  }
}
