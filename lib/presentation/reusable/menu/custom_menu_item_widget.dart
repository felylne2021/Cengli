import 'package:cengli/presentation/reusable/shapes/circle_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class CustomMenuItemWidget extends StatelessWidget {
  final CircleIconWidget icon;
  final String title;
  const CustomMenuItemWidget(
      {super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            icon,
            12.0.width,
            Text(
              title,
              style: KxTypography(
                  type: KxFontType.body2, color: KxColors.neutral700),
            )
          ],
        ).padding(const EdgeInsets.fromLTRB(16, 15, 16, 0)),
        15.0.height,
        const Divider(
          thickness: 1,
          color: KxColors.neutral200,
        )
      ],
    );
  }
}
