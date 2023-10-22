import 'package:flutter/material.dart';

class BoxSkeleton extends StatelessWidget {
  final double height;
  final double? width;
  final double? radius;
  const BoxSkeleton({super.key, required this.height, this.width, this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius ?? 20)),
    );
  }
}
