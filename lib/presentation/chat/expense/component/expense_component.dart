import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kinetix/kinetix.dart';

import '../../../../values/values.dart';

class ChargeFilterWidget extends StatelessWidget {
  const ChargeFilterWidget(
      {super.key,
      required this.imagePath,
      required this.selected,
      required this.onTap});
  final String imagePath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: selected ? primaryGreen600 : KxColors.neutral100,
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        duration: const Duration(milliseconds: 400),
        child: SvgPicture.asset(imagePath),
      ),
    );
  }
}

class ItemSelectionWidget extends StatelessWidget {
  const ItemSelectionWidget({
    super.key,
    this.leading,
    required this.title,
    this.trailing,
  });

  final Widget? leading;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
            const FilledBoxDecoration(backgroundColor: KxColors.neutral100),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Padding(
                padding: leading != null
                    ? const EdgeInsets.only(left: 24.0, right: 12.0)
                    : const EdgeInsets.only(left: 16),
                child: leading ?? const SizedBox(),
              ),
              Text(
                title,
                style: KxTypography(
                    type: KxFontType.fieldText2, color: KxColors.neutral700),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 24.0),
                child: trailing ?? const SizedBox(),
              ),
            ],
          ),
        ));
  }
}
