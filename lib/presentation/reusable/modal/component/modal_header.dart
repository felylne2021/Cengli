import 'package:flutter/material.dart';
import 'package:kinetix/kinetix.dart';

class ModalHeader extends StatelessWidget {
  const ModalHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: KxColors.neutral200,
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: KxColors.neutral700,
                ),
              ),
            ),
          ],
        ),
        Text(
          title,
          style: KxTypography(
              type: KxFontType.subtitle3, color: KxColors.neutral700),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
