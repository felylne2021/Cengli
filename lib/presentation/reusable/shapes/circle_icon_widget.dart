import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircleIconWidget extends StatelessWidget {
  final String iconPath;
  final double circleSize;
  final Color circleColor;
  final double iconPadding;

  const CircleIconWidget(
      {super.key,
      required this.iconPath,
      required this.circleColor,
      this.circleSize = 36,
      this.iconPadding = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleSize,
      width: circleSize,
      padding: EdgeInsets.all(iconPadding),
      decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
      child: SvgPicture.asset(iconPath),
    );
  }
}
