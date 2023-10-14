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
    return Padding(
      // TODO: REFACTOR AS IT'S NOT RESPONSIVE
      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.27),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Text(
            title,
            style: KxTypography(
                type: KxFontType.subtitle3, color: KxColors.neutral700),
            textAlign: TextAlign.center,
          ).flexible(),
        ],
      ),
    );
  }
}
